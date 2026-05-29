#include <metil_rendering/metil_renderer.h>

#include <metil_application/metil_application.h>
#include <metil_audio/metil_audio.h>
#include <metil_audio/metil_audio_data.h>
#include <metil_configuration/metil_configuration.h>
#include <metil_group.h>
#include <metil_library.h>
#include <metil_mesh/metil_mesh.h>
#include <metil_model/metil_model.h>
#include <metil_object.h>
#include <metil_positioning.h>
#include <metil_rendering/metil_camera/metil_camera.h>
#include <metil_rendering/metil_descriptors/metil_pipeline_render.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderable_type.h>
#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_thread_poll_object_data.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>
#include <metil_scenes/metil_scene.h>
#include <metil_scenes/metil_scene_controller.h>
#include <metil_system_information.h>
#include <metil_termination/metil_termination.h>
#include <metil_text/metil_text_characters.h>
#include <metil_utilities/metil_time.h>

#include <clic3_char_arrays.h>
#include <clic3_memory.h>

#include <math_c_pi.h>
#include <math_c_sine.h>
#include <math_c_vector.h>

#include <Metal/MTLBuffer.h>
#include <Metal/MTLCommandBuffer.h>
#include <Metal/MTLCommandQueue.h>
#include <Metal/MTLDepthStencil.h>
#include <Metal/MTLDevice.h>
#include <Metal/MTLLibrary.h>
#include <Metal/MTLRenderCommandEncoder.h>
#include <Metal/MTLRenderPipeline.h>
#include <Metal/MTLResource.h>
#include <MetalKit/MTKView.h>

#include <limits.h>
#include <simd/simd.h>

@implementation metil_renderer

- (nonnull instancetype) metil_renderer_initialize:
  (nonnull MTKView*) metal_kit_view
  metil: (nonnull struct metil*) parameter_metil
{
  self = [
    super
    init
  ];

  if (
    self ==
    0x00
  ) {
    return (
      self
    );
  }

  self->metil = (
    parameter_metil
  );

  [
    self
    initialize_null
  ];

  self->length_threads = (
    self->metil->system_information.cores_cpu *
    metil_count_max_frames
  );

  self->threads = (
    clic3_memory_allocate_raw(
      sizeof(
        pthread_t*
      ) *
      self->length_threads
    )
  );

  self->threads_data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct metil_renderer_thread_poll_object_data
      ) *
      self->length_threads
    )
  );

  for (
    unsigned int index_thread = (
      0x00
    );
    (
      index_thread <
      self->length_threads
    );
    ++index_thread
  ) {
    self->threads[
      index_thread
    ] = (
      0x00
    );

    self->threads_data[
      index_thread
    ].metil = (
      self->metil
    );

    self->threads_data[
      index_thread
    ].matrix_static_projection = &(
      self->matrix_projection_static
    );

    self->threads_data[
      index_thread
    ].camera = &(
      self->metil->rendering_properties.camera
    );
  }

  self->metil->renderer_interface.renderer = (
    self
  );

  self->view = (
    metal_kit_view
  );

  self->metil->renderer_interface.metal_device = (
    metal_kit_view.device
  );

  [
    self
    termination_functions_initialize
  ];

  metil_text_characters_initialize(
    &self->metil->text_characters_default,
    self->metil->renderer_interface.metal_device,
    &self->metil->configuration,
    &self->metil->text_defaults.render_parameters
  );

  metil_scene_controller_after_scene_change_add(
    self->metil->scene_controller,
    metil_renderer_after_scene_change,
    self
  );

  [
    self
    command_queue_initialize
  ];

  [
    self
    data_buffer_frames_initialize
  ];

  [
    self
    stencils_depth_initialize
  ];

  [
    self
    fps_display_objects_initialize
  ];

  [
    self
    descriptor_pipeline_render_initialize
  ];

  if (
    self->metil->renderer_on_initialize !=
    0x00
  ) {
    self->metil->renderer_on_initialize(
      self->metil,
      self->metil->renderer_on_initialize_data
    );
  }

  [
    self
    pipelines_initialize
  ];

  self->destroying = (
    0x00
  );

  pthread_mutex_init(
    &self->mutex_destroying,
    0x00
  );

  pthread_mutex_lock(
    &self->mutex_destroying
  );

  return (
    self
  );
}

- (void) after_scene_change {}

- (id<MTLLogState>) log_state_create {
  return (
    0x00
  );

  MTLLogStateDescriptor* descriptor_log_state = [
    [
      MTLLogStateDescriptor
      alloc
    ]
    init
  ];

  descriptor_log_state.level = (
    MTLLogLevelDebug
  );

  id<MTLLogState> log_state = [
    self->metil->renderer_interface.metal_device
    newLogStateWithDescriptor: (
      descriptor_log_state
    )
    error: (
      0x00
    )
  ];

  [
    descriptor_log_state
    release
  ];

  [
    log_state
    addLogHandler: ^(
      NSString* subsystem,
      NSString* category,
      MTLLogLevel level_log,
      NSString* log
    ) {
      // printf("%s\n",log);
    }
  ];

  return (
    log_state
  );
}

- (void) command_queue_initialize {
  MTLCommandQueueDescriptor* descriptor_command_queue = [
    [
      MTLCommandQueueDescriptor
      alloc
    ]
    init
  ];

  descriptor_command_queue.logState = (
    [
      self
      log_state_create
    ]
  );

  self->command_queue = [
    self->metil->renderer_interface.metal_device
    newCommandQueueWithDescriptor: (
      descriptor_command_queue
    )
  ];

  [
    descriptor_command_queue
    release
  ];
}

- (void) data_buffer_frames_initialize {
  for (
    unsigned int index_buffer = (
      0x00
    );
    (
      index_buffer <
      metil_count_max_frames
    );
    ++index_buffer
  ) {
    data_buffer_frame[
      index_buffer
    ] = [
      self->metil->renderer_interface.metal_device
      newBufferWithLength: (
        sizeof(
          struct metil_renderer_data_frame
        )
      )
      options: (
        MTLResourceStorageModeShared
      )
    ];
  }
}

- (void) data_buffer_frames_length_buffer_set:
  (unsigned int) length_buffer
{
  for (
    unsigned int index_buffer = (
      0x00
    );
    (
      index_buffer <
      metil_count_max_frames
    );
    ++index_buffer
  ) {
    [
      data_buffer_frame[
        index_buffer
      ]
      release
    ];

    data_buffer_frame[
      index_buffer
    ] = [
      self->metil->renderer_interface.metal_device
      newBufferWithLength: (
        length_buffer
      )
      options: (
        MTLResourceStorageModeShared
      )
    ];
  }
}

- (void) descriptor_pipeline_render_initialize {
  if (
    self->descriptor_pipeline_render ==
    0x00
  ) {
    self->descriptor_pipeline_render = [
      [
        MTLRenderPipelineDescriptor
        alloc
      ]
      init
    ];

    metil_rendering_descriptors_pipeline_render_initialize(
      self->descriptor_pipeline_render,
      0x01,
      0x00,
      0x00,
      MTLPixelFormatBGRA8Unorm_sRGB,
      MTLPixelFormatDepth32Float_Stencil8,
      MTLPixelFormatDepth32Float_Stencil8
    );
  }
}

- (void) destroy {
  self->destroying = (
    0x01
  );

  pthread_mutex_lock(
    &self->mutex_destroying
  );

  pthread_mutex_unlock(
    &self->mutex_destroying
  );

  for (
    unsigned int index_thread = (
      0x00
    );
    (
      index_thread <
      self->length_threads
    );
    ++index_thread
  ) {
    if (
      self->threads[
        index_thread
      ] ==
      0x00
    ) {
      continue;
    }

    pthread_cancel(
      self->threads[
        index_thread
      ]
    );

    pthread_join(
      self->threads[
        index_thread
      ],
      0x00
    );
  }

  clic3_memory_free_raw(
    self->threads
  );

  clic3_memory_free_raw(
    self->threads_data
  );

  [
    self->metil->renderer_interface.metal_device
    release
  ];

  for (
    unsigned char index_data_buffer_frame_release = (
      0x00
    );
    (
      index_data_buffer_frame_release <
      metil_count_max_frames
    );
    ++index_data_buffer_frame_release
  ) {
    [
      self->data_buffer_frame[
        index_data_buffer_frame_release
      ]
      release
    ];
  }

  [
    self->index_buffer_mesh_current
    release
  ];

  [
    self->command_queue
    release
  ];

  [
    self->descriptor_pipeline_render
    release
  ];

  for (
    unsigned char index_pipeline_render = (
      0x00
    );
    (
      index_pipeline_render <
      self->length_pipelines_render
    );
    ++index_pipeline_render
  ) {
    if (
      self->pipelines_render[
        index_pipeline_render
      ] !=
      0x00
    ) {
      [
        self->pipelines_render[
          index_pipeline_render
        ]
        release
      ];
    }
  }

  clic3_memory_free_raw(
    self->pipelines_render
  );

  [
    self->depth_state
    release
  ];

  [
    self->depth_state_writes_disabled
    release
  ];

  for (
    unsigned char index_object_fps_display = (
      0x00
    );
    (
      index_object_fps_display <
      metil_renderer_length_objects_fps_display
    );
    ++index_object_fps_display
  ) {
    struct metil_object* metil_object = &(
      self->objects_fps_display[
        index_object_fps_display
      ]
    );

    [
      metil_object->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer
      release
    ];
  }

  metil_rendering_properties_destory(
    &self->metil->rendering_properties
  );
}

- (void) drawInMTKView: (nonnull MTKView*) metal_kit_view {
  [
    self
    poll: (
      self->metil->rendering_properties.frame
    )
  ];

  #if target_os_ios
  metil_application* metil_ui_application = (
    (metil_application*)
    [
      UIApplication
      sharedApplication
    ]
  );

  unsigned char state_application = [
    metil_ui_application
    applicationState
  ];

  if (
    state_application >
    0x01
  ) {
    if (
      self->destroying ==
      0x00
    ) {
      struct timespec time_sleep = {
        .tv_sec = (
          0x00
        ),
        .tv_nsec = (
          0x05f5e100
        )
      };

      struct timespec time_remaining = {
        .tv_sec = (
          0x00
        ),
        .tv_nsec = (
          0x00
        )
      };

      nanosleep(
        &time_sleep,
        &time_remaining
      );

      pthread_t thread_draw;

      pthread_create(
        &thread_draw,
        0x00,
        metil_renderer_thread_draw,
        metal_kit_view
      );
    } else {
      pthread_mutex_unlock(
        &self->mutex_destroying
      );
    }

    return;
  }
  #endif

  [
    self
    render_view: (
      metal_kit_view
    )
  ];
}

- (void) render_view: (nonnull MTKView*) metal_kit_view {
  if (
    self->metil->rendering_properties.frame !=
    self->metil->rendering_properties.count_completed_frames
  ) {
    return;
  }

  unsigned int index_frame = (
    self->metil->rendering_properties.frame++
  );

  if (
    index_frame ==
    0x00
  ) {
    self->metil->audio.muted = (
      0x00
    );
  }

  for (
    unsigned char index_time_frame = (
      0x00
    );
    (
      index_time_frame <
      (
        metil_count_time_frames -
        0x01
      )
    );
    ++index_time_frame
  ) {
    self->metil->rendering_properties.time_frames[
      index_time_frame
    ] = (
      self->metil->rendering_properties.time_frames[
        index_time_frame +
        0x01
      ]
    );
  }

  self->metil->rendering_properties.time_frames[
    metil_count_time_frames -
    0x01
  ] = (
    metil_time_milliseconds_get() -
    0x19be2bf087f
  );

  float time_difference_average = (
    0x00
  );

  for (
    unsigned char index_time_frame = (
      0x00
    );
    (
      index_time_frame <
      (
        metil_count_time_frames -
        0x01
      )
    );
    ++index_time_frame
  ) {
    time_difference_average = (
      time_difference_average + (
        (float) (
          self->metil->rendering_properties.time_frames[
            index_time_frame +
            0x01
          ] -
          self->metil->rendering_properties.time_frames[
            index_time_frame
          ]
        ) /
        (float) (
          metil_count_time_frames -
          0x01
        )
      )
    );
  }

  self->metil->rendering_properties.fps = (
    0x03e8 /
    time_difference_average
  );

  self->index_data_buffer_frame = (
    (
      self->index_data_buffer_frame +
      0x01
    ) %
    metil_count_max_frames
  );

  MTLCommandBufferDescriptor* descriptor_command_buffer = [
    [
      MTLCommandBufferDescriptor
      alloc
    ]
    init
  ];

  descriptor_command_buffer.logState = (
    [
      self
      log_state_create
    ]
  );

  id<MTLCommandBuffer> command_buffer = [
    self->command_queue
    commandBufferWithDescriptor: (
      descriptor_command_buffer
    )
  ];

  [
    descriptor_command_buffer
    release
  ];

  MTLRenderPassDescriptor* descriptor_render_pass = (
    metal_kit_view.currentRenderPassDescriptor
  );

  descriptor_render_pass.colorAttachments[
    0x00
  ].clearColor = (
    MTLClearColorMake(
      (
        self->metil->rendering_properties.colour_clear.x *
        self->metil->rendering_properties.brightness
      ),
      (
        self->metil->rendering_properties.colour_clear.y *
        self->metil->rendering_properties.brightness
      ),
      (
        self->metil->rendering_properties.colour_clear.z *
        self->metil->rendering_properties.brightness
      ),
      self->metil->rendering_properties.colour_clear.w
    )
  );

  if (
    (
      self->metil->rendering_properties.disables &
      metil_rendering_properties_disables_rendering
    ) ==
    0x00
  ) {
    descriptor_render_pass.colorAttachments[
      0x00
    ].loadAction = (
      MTLLoadActionClear
    );
  } else {
    descriptor_render_pass.colorAttachments[
      0x00
    ].loadAction = (
      MTLLoadActionLoad
    );
  }

  descriptor_render_pass.colorAttachments[
    0x00
  ].storeAction = (
    MTLStoreActionStore
  );

  encoder_render = [
    command_buffer
    renderCommandEncoderWithDescriptor: (
      descriptor_render_pass
    )
  ];

  if (
    (
      self->pipelines_render[
        self->index_pipelines_render_current
      ] ==
      0x00
    ) &&
    (
      self->pipelines_render[
        metil_renderer_pipelines_render_index_library
      ] !=
      0x00
    )
  ) {
    self->index_pipelines_render_current = (
      metil_renderer_pipelines_render_index_library
    );
  }

  [
    encoder_render
    setRenderPipelineState: (
      self->pipelines_render[
        self->index_pipelines_render_current
      ]
    )
  ];

  if (
    self->depth_state_disabled ==
    0x00
  ) {
    [
      encoder_render
      setDepthStencilState: (
        self->depth_state
      )
    ];
  } else {
    [
      encoder_render
      setDepthStencilState: (
        self->depth_state_writes_disabled
      )
    ];
  }

  self->depth_state_disabled = (
    0x00
  );

  if (
    (
      metil->rendering_properties.mode &
      metil_rendering_properties_mode_wireframe_full
    ) !=
    0x00
  ) {
    [
      encoder_render
      setTriangleFillMode: (
        MTLTriangleFillModeLines
      )
    ];
  } else {
    [
      encoder_render
      setTriangleFillMode: (
        MTLTriangleFillModeFill
      )
    ];
  }

  if (
    (
      self->metil->rendering_properties.disables &
      metil_rendering_properties_disables_rendering
    ) ==
    0x00
  ) {
    [
      self
      render
    ];
  }

  if (
    (
      self->metil->rendering_properties.fps_display ==
      0x01
    ) &&
    (
      self->pipelines_render[
        metil_renderer_pipelines_render_index_fps_display
      ] !=
      0x00
    ) &&
    (
      self->metil->rendering_properties.frame >
      0x0a
    )
  ) {
    [
      self
      render_fps_display
    ];
  }

  [
    encoder_render
    endEncoding
  ];

  [
    command_buffer
    addCompletedHandler: ^(id<MTLCommandBuffer> buffer) {
      self->metil->rendering_properties.count_completed_frames = (
        self->metil->rendering_properties.count_completed_frames +
        0x01
      );

      if (
        self->destroying ==
        0x00
      ) {
        [
          metal_kit_view
          draw
        ];
      } else {
        pthread_mutex_unlock(
          &self->mutex_destroying
        );
      }
    }
  ];

  [
    command_buffer
    presentDrawable: (
      metal_kit_view.currentDrawable
    )
  ];

  [
    command_buffer
    commit
  ];
}

- (void) drawableSizeWillChange: (CGSize) size {
  self->metil->renderer_interface.size.x = (
    size.width
  );

  self->metil->renderer_interface.size.y = (
    size.height
  );

  metil_camera_ratio_aspect_set(
    &self->metil->rendering_properties.camera,
    &self->metil->renderer_interface.size
  );

  self->matrix_projection_static.columns[
    0x00
  ][
    0x00
  ] = (
    0x01 /
    self->metil->rendering_properties.camera.ratio_aspect_view
  );
}

- (void) fps_display_objects_initialize {
  for (
    unsigned char index_object_fps_display = (
      0x00
    );
    (
      index_object_fps_display <
      metil_renderer_length_objects_fps_display
    );
    ++index_object_fps_display
  ) {
    metil_object_initialize(
      &self->objects_fps_display[
        index_object_fps_display
      ]
    );

    metil_object_buffers_add(
      &self->objects_fps_display[
        index_object_fps_display
      ],
      self->metil->renderer_interface.metal_device,
      metil_object_buffer_type_vertex
    );

    metil_object_buffers_add(
      &self->objects_fps_display[
        index_object_fps_display
      ],
      self->metil->renderer_interface.metal_device,
      metil_object_buffer_type_vertex
    );

    metil_object_texture_add(
      &self->objects_fps_display[
        index_object_fps_display
      ],
      0x00
    );

    self->objects_fps_display[
      index_object_fps_display
    ].position.y = (
      0x00
    );

    self->objects_fps_display[
      index_object_fps_display
    ].position.z = (
      0x00
    );

    self->objects_fps_display[
      index_object_fps_display
    ].positioning = (
      metil_positioning_static
    );

    self->objects_fps_display[
      index_object_fps_display
    ].buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer = [
      self->metil->renderer_interface.metal_device
      newBufferWithLength: (
        sizeof(
          struct metil_renderer_data_object
        )
      )
      options: (
        MTLResourceStorageModeShared
      )
    ];

    self->objects_fps_display[
      index_object_fps_display
    ].index_pipeline_render = (
      metil_renderer_pipelines_render_index_fps_display
    );

    struct metil_renderer_data_object* data_object = (
      self->objects_fps_display[
        index_object_fps_display
      ].buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );
  }
}

- (void) initialize_null {
  self->metil->renderer_interface.metal_device = (
    0x00
  );

  self->command_queue = (
    0x00
  );

  self->depth_state = (
    0x00
  );

  self->depth_state_disabled = (
    0x00
  );

  self->depth_state_writes_disabled = (
    0x00
  );

  self->descriptor_pipeline_render = (
    0x00
  );

  self->encoder_render = (
    0x00
  );

  self->index_buffer_mesh_current = (
    0x00
  );

  self->index_pipelines_render_current = (
    metil_renderer_pipelines_render_index_library
  );

  self->pipelines_render = (
    0x00
  );

  self->length_pipelines_render = (
    0x03
  );

  self->threads = (
    0x00
  );

  self->threads_data = (
    0x00
  );

  self->length_threads = (
    0x00
  );

  self->poll_data_frame = (
    metil_renderer_data_frame_poll
  );

  self->matrix_projection_static = (matrix_float3x4) {{
    { 0x01, 0x00, 0x00, 0x00 },
    { 0x00, 0x01, 0x00, 0x00 },
    { 0x00, 0x00, 0x01, 0x00 },
  }};

  for (
    unsigned char index_data_buffer_frame_initializer = (
      0x00
    );
    (
      index_data_buffer_frame_initializer <
      metil_count_max_frames
    );
    ++index_data_buffer_frame_initializer
  ) {
    self->data_buffer_frame[
      index_data_buffer_frame_initializer
    ] = (
      0x00
    );
  }

  self->pipelines_render = (
    clic3_memory_allocate_raw(
      sizeof(
        id<MTLRenderPipelineState>
      ) *
      self->length_pipelines_render
    )
  );

  for (
    unsigned short int index_pipeline_render = (
      0x00
    );
    (
      index_pipeline_render <
      self->length_pipelines_render
    );
    ++index_pipeline_render
  ) {
    self->pipelines_render[
      index_pipeline_render
    ] = (
      0x00
    );
  }
}

- (void) mtkView:
  (nonnull MTKView*) metal_kit_view
  drawableSizeWillChange: (CGSize) size
{}

- (unsigned short int) pipeline_add:
  (id<MTLFunction>) function_fragment
  function_vertex: (id<MTLFunction>) function_vertex
{
  self->descriptor_pipeline_render.fragmentFunction = (
    function_fragment
  );

  self->descriptor_pipeline_render.vertexFunction = (
    function_vertex
  );

  self->length_pipelines_render = (
    self->length_pipelines_render +
    0x01
  );

  clic3_memory_reallocate_raw(
    &self->pipelines_render,
    sizeof(
      id<MTLRenderPipelineState>
    ) *
    self->length_pipelines_render
  );

  self->pipelines_render[
    self->length_pipelines_render -
    0x01
  ] = [
    self->metil->renderer_interface.metal_device
    newRenderPipelineStateWithDescriptor: (
      self->descriptor_pipeline_render
    )
    error: (
      0x00
    )
  ];

  return (
    self->length_pipelines_render -
    0x01
  );
}

- (void) pipelines_clear {
  for (
    unsigned short int index_pipeline_render = (
      0x03
    );
    (
      index_pipeline_render <
      self->length_pipelines_render
    );
    ++index_pipeline_render
  ) {
    [
      self->pipelines_render[
        index_pipeline_render
      ]
      release
    ];
  }

  self->length_pipelines_render = (
    0x03
  );

  clic3_memory_reallocate_raw(
    &self->pipelines_render,
    (
      sizeof(
        id<MTLRenderPipelineState>
      ) *
      self->length_pipelines_render
    )
  );
}

- (void) pipelines_initialize {
  [
    self
    pipeline_render_fps_display_initiliaze
  ];

  [
    self
    pipeline_render_library_initiliaze
  ];

  [
    self
    pipeline_render_wireframe_initialize
  ];
}

- (void) pipeline_render_initialize:
  (unsigned short int) index_pipeline_render
  function_fragment: (id<MTLFunction>) function_fragment
  function_vertex: (id<MTLFunction>) function_vertex {
  if (
    (
      self->pipelines_render[
        index_pipeline_render
      ] ==
      0x00
    ) &&
    (
      function_fragment !=
      0x00
    ) &&
    (
      function_vertex !=
      0x00
    )
  ) {
    self->descriptor_pipeline_render.fragmentFunction = function_fragment;
    self->descriptor_pipeline_render.vertexFunction = function_vertex;

    self->pipelines_render[
      index_pipeline_render
    ] = [
      self->metil->renderer_interface.metal_device
      newRenderPipelineStateWithDescriptor: (
        self->descriptor_pipeline_render
      )
      error: (
        0x00
      )
    ];
  }
}

- (void) pipeline_render_library_initiliaze {
  [
    self
    pipeline_render_initialize: (
      metil_renderer_pipelines_render_index_library
    )
    function_fragment: (
      self->metil->library.function_fragment
    )
    function_vertex: (
      self->metil->library.function_vertex
    )
  ];
}

- (void) pipeline_render_wireframe_initialize {
  [
    self
    pipeline_render_initialize: (
      metil_renderer_pipelines_render_index_wireframe
    )
    function_fragment: (
      self->metil->library.function_fragment_wireframe
    )
    function_vertex: (
      self->metil->library.function_vertex_wireframe
    )
  ];
}

- (void) pipeline_render_fps_display_initiliaze {
  [
    self
    pipeline_render_initialize: (
      metil_renderer_pipelines_render_index_fps_display
    )
    function_fragment: (
      self->metil->library.function_fragment_fps_display
    )
    function_vertex: (
      self->metil->library.function_vertex_fps_display
    )
  ];
}

- (void) poll: (unsigned int) poll_frame {
  struct metil_scene_controller* metil_scene_controller = (
    self->metil->scene_controller
  );

  struct metil_scene* metil_scene = &(
    metil_scene_controller->scene
  );

  struct metil_player* metil_player = &(
    metil_scene->player
  );
  unsigned char disabled_polling = (
    self->metil->rendering_properties.disables &
    metil_rendering_properties_disables_polling
  );

  if (
    disabled_polling ==
    0x00
  ) {
    metil_scene_poll(
      self->metil,
      metil_scene
    );
  }

  void* data_frame = (
    data_buffer_frame[
      self->index_data_buffer_frame
    ].contents
  );

  self->poll_data_frame(
    self->metil,
    data_frame,
    poll_frame
  );

  struct math_c_vector2_float rotation_sine = {
    .x = (
      math_c_sine(
        metil_player->rotation.x,
        math_c_pi
      )
    ),
    .y = (
      math_c_sine(
        metil_player->rotation.y,
        math_c_pi
      )
    )
  };

  struct math_c_vector2_float rotation_cosine = {
    .x = (
      math_c_cosine(
        metil_player->rotation.x,
        math_c_pi
      )
    ),
    .y = (
      math_c_cosine(
        metil_player->rotation.y,
        math_c_pi
      )
    )
  };

  matrix_float4x4 matrix_player_rotation_x = (matrix_float4x4) {{
    { 0x01, 0x00, 0x00, 0x00 },
    { 0x00, rotation_cosine.x, -rotation_sine.x, 0x00 },
    { 0x00, rotation_sine.x, rotation_cosine.x, 0x00 },
    { 0x00, 0x00, 0x00, 0x01 }
  }};

  matrix_float4x4 matrix_player_rotation_y = (matrix_float4x4) {{
    { rotation_cosine.y, 0x00, rotation_sine.y, 0x00 },
    { 0x00, 0x01, 0x00, 0x00 },
    { rotation_sine.y, 0x00, -rotation_cosine.y, 0x00 },
    { 0x00, 0x00, 0x00, 0x01 }
  }};

  if (
    self->metil->rendering_properties.camera.mode ==
    metil_camera_mode_third_person
  ) {
    matrix_player_rotation_x.columns[
      0x03
    ].y = (
      self->metil->rendering_properties.camera.height *
      (
        1.0f -
        -metil_player->rotation.x /
        math_c_pi_half
      )
    );

    matrix_player_rotation_x.columns[
      0x03
    ].z = -(
      matrix_player_rotation_x.columns[
        0x03
      ].y
    );
  } else {
    matrix_player_rotation_x.columns[
      0x03
    ].z = (
      0x01
    );
  }

  matrix_float4x4 matrix_player_projection = (
    matrix_multiply(
      self->metil->rendering_properties.camera.matrix_viewport_projection,
      matrix_player_rotation_x
    )
  );

  matrix_float4x4 matrix_object_projection = (
    matrix_multiply(
      matrix_player_projection,
      matrix_player_rotation_y
    )
  );

  unsigned char _index_data_buffer_frame = (
    self->index_data_buffer_frame
  );

  if (
    disabled_polling ==
    0x00
  ) {
    unsigned int length_segment_objects = (
      metil_scene->length_renderables /
      self->metil->system_information.cores_cpu
    );

    for (
      unsigned int index_core_cpu = (
        0x00
      );
      (
        index_core_cpu <
        self->metil->system_information.cores_cpu
      );
      ++index_core_cpu
    ) {
      unsigned int index_thread = (
        self->metil->system_information.cores_cpu *
        _index_data_buffer_frame +
        index_core_cpu
      );

      if (
        self->threads[
          index_thread
        ] !=
        0x00
      ) {
        pthread_join(
          self->threads[
            index_thread
          ],
          0x00
        );
      }

      unsigned int offset_index_object = (
        length_segment_objects *
        index_core_cpu
      );

      self->threads_data[
        index_thread
      ].renderables = (
        metil_scene->renderables +
        offset_index_object
      );

      if (
        index_core_cpu < (
          self->metil->system_information.cores_cpu -
          0x01
        )
      ) {
        self->threads_data[
          index_thread
        ].length_renderables = (
          length_segment_objects
        );
      } else {
        self->threads_data[
          index_thread
        ].length_renderables = (
          metil_scene->length_renderables - (
            length_segment_objects *
            index_core_cpu
          )
        );
      }

      self->threads_data[
        index_thread
      ].matrix_object_projection = (
        &matrix_object_projection
      );

      self->threads_data[
        index_thread
      ].matrix_player_projection = (
        &matrix_player_projection
      );

      pthread_create(
        &self->threads[
          index_thread
        ],
        0x00,
        metil_renderer_thread_poll_object,
        &self->threads_data[
          index_thread
        ]
      );
    }
  }

  if (
    self->metil->rendering_properties.fps_display ==
    0x01
  ) {
    [
      self
      poll_fps_display: (
        &matrix_object_projection
      )
      matrix_player_projection: (
        &matrix_player_projection
      )
    ];
  }

  if (
    disabled_polling ==
    0x00
  ) {
    for (
      unsigned int index_core_cpu = (
        0x00
      );
      (
        index_core_cpu <
        self->metil->system_information.cores_cpu
      );
      ++index_core_cpu
    ) {
      unsigned int index_thread = (
        self->metil->system_information.cores_cpu *
        _index_data_buffer_frame +
        index_core_cpu
      );

      pthread_join(
        self->threads[
          index_thread
        ],
        0x00
      );

      self->threads[
        index_thread
      ] = (
        0x00
      );
    }
  }
}

- (void) poll_fps_display:
  (matrix_float4x4*) matrix_object_projection
  matrix_player_projection: (matrix_float4x4*) matrix_player_projection
{
  if (
    (
      self->metil->rendering_properties.frame ==
      0x00
    ) ||
    (
      (
        self->metil->rendering_properties.frame %
        0x0a
      ) !=
      0x00
    )
  ) {
    return;
  }

  char* char_array_fps = clic3_char_array_from_float(
    self->metil->rendering_properties.fps
  );

  float position_x = (
    0.0015f
  );

  for (
    signed char index_object_fps_display = (
      metil_renderer_length_objects_fps_display -
      0x01
    );
    (
      index_object_fps_display >=
      0x00
    );
    --index_object_fps_display
  ) {
    if (
      char_array_fps[
        index_object_fps_display
      ] ==
      '\0'
    ) {
      break;
    }

    self->objects_fps_display[
      index_object_fps_display
    ].mesh = (
      self->metil->text_characters_default.meshes[
        char_array_fps[
          index_object_fps_display
        ]
      ]
    );

    if (
      position_x ==
      0x00
    ) {
      position_x = (
        (
          (
            self->objects_fps_display[
              index_object_fps_display
            ].mesh.size.x /
            0x02
          ) /
          self->metil->rendering_properties.camera.ratio_aspect_view
        )
      );
    } else {
      position_x = (
        position_x +
        (
          self->objects_fps_display[
            index_object_fps_display
          ].mesh.size.x /
          self->metil->rendering_properties.camera.ratio_aspect_view
        )
      );
    }

    self->objects_fps_display[
      index_object_fps_display
    ].position.x = (
      0x01 -
      position_x
    );

    if (
      char_array_fps[
        index_object_fps_display
      ] ==
      '.'
    ) {
      self->objects_fps_display[
        index_object_fps_display
      ].position.x = (
        self->objects_fps_display[
          index_object_fps_display
        ].position.x -
        self->objects_fps_display[
          index_object_fps_display
        ].mesh.size.x /
        3.5f /
        self->metil->rendering_properties.camera.ratio_aspect_view
      );
    }

    self->objects_fps_display[
      index_object_fps_display
    ].position.y = (
      0.971f +
      self->objects_fps_display[
        index_object_fps_display
      ].mesh.size.y /
      0x02
    );

    self->objects_fps_display[
      index_object_fps_display
    ].indices = (
      self->metil->text_characters_default.indices
    );

    self->objects_fps_display[
      index_object_fps_display
    ].buffers_vertex[
      metil_object_buffer_default_index_vertices
    ].buffer = (
      self->metil->text_characters_default.vertices[
        char_array_fps[
          index_object_fps_display
        ]
      ]
    );

    self->objects_fps_display[
      index_object_fps_display
    ].textures[
      0x00
    ] = (
      self->metil->text_characters_default.textures[
        char_array_fps[
          index_object_fps_display
        ]
      ]
    );

    self->objects_fps_display[
      index_object_fps_display
    ].poll(
      self->metil,
      &self->objects_fps_display[
        index_object_fps_display
      ],
      &self->matrix_projection_static,
      matrix_object_projection,
      matrix_player_projection,
      &self->metil->rendering_properties.camera
    );
  }

  clic3_memory_free_raw(
    char_array_fps
  );
}

- (void) render_renderable:
  (struct metil_renderable*) metil_renderable
{
  switch (
    metil_renderable->type
  ) {
    case metil_renderable_type_group: {
      struct metil_group* metil_group = (
        metil_renderable->renderable
      );

      if (
        metil_group->visible !=
        0x00
      ) {
        for (
          unsigned int index_group_renderable = (
            0x00
          );
          (
            index_group_renderable <
            metil_group->length
          );
          ++index_group_renderable
        ) {
          [
            self
            render_renderable: metil_group->renderables[
              index_group_renderable
            ]
          ];
        }
      }

      break;
    }
    case metil_renderable_type_object: {
      struct metil_object* metil_object = (
        metil_renderable->renderable
      );

      if (
        (
          self->metil->rendering_properties.mode &
          (
            metil_rendering_properties_mode_default
|
            metil_rendering_properties_mode_wireframe_full
          )
        ) !=
        0x00
      ) {
        [
          self
          render_object: (
            metil_object
          )
        ];
      }

      if (
        (
          self->metil->rendering_properties.mode &
          metil_rendering_properties_mode_wireframe
        ) &&
        (
          (
            self->metil->rendering_properties.mode &
            metil_rendering_properties_mode_wireframe_full
          ) ==
          0x00
        )
      ) {
        [
          self
          render_object_wireframe: (
            metil_object
          )
        ];
      }
      break;
    }
    case metil_renderable_type_menu: {
      break;
    }
    case metil_renderable_type_model: {
      struct metil_model* metil_model = (
        metil_renderable->renderable
      );

      if (
        metil_model->visible ==
        0x00
      ) {
        break;
      }

      for (
        unsigned char index_object = (
          0x00
        );
        (
          index_object <
          metil_model->length_objects
        );
        ++index_object
      ) {
        struct metil_object* metil_object = &(
          metil_model->objects[
            index_object
          ]
        );

        if (
          self->metil->rendering_properties.mode &
          metil_rendering_properties_mode_default
        ) {
          [
            self
            render_object: metil_object
          ];
        }

        if (
          self->metil->rendering_properties.mode &
          metil_rendering_properties_mode_wireframe
        ) {
          [
            self
            render_object_wireframe: metil_object
          ];
        }
      }
      break;
    }
    default: {
      break;
    }
  }
}

- (void) render {
  struct metil_scene_controller* metil_scene_controller = (
    self->metil->scene_controller
  );

  struct metil_scene* metil_scene = &(
    metil_scene_controller->scene
  );

  for (
    unsigned int index_renderable = (
      0x00
    );
    (
      index_renderable <
      metil_scene->length_renderables
    );
    ++index_renderable
  ) {
    struct metil_renderable* metil_renderable = &(
      metil_scene->renderables[
        index_renderable
      ]
    );

    [
      self
      render_renderable: (
        metil_renderable
      )
    ];
  }
}

- (void) render_fps_display {
  for (
    unsigned char index_object_fps_display = (
      0x00
    );
    (
      index_object_fps_display <
      metil_renderer_length_objects_fps_display
    );
    ++index_object_fps_display
  ) {
    struct metil_renderer_data_object* metil_renderer_data_object = (
      self->objects_fps_display[
        index_object_fps_display
      ].buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );

    metil_renderer_data_object->colour.x = (
      self->metil->rendering_properties.colour_fps_display.x
    );

    metil_renderer_data_object->colour.y = (
      self->metil->rendering_properties.colour_fps_display.y
    );

    metil_renderer_data_object->colour.z = (
      self->metil->rendering_properties.colour_fps_display.z
    );

    metil_renderer_data_object->colour.w = (
      self->metil->rendering_properties.colour_fps_display.w
    );

    [
      self
      render_object: &self->objects_fps_display[
        index_object_fps_display
      ]
    ];
  }
}

- (void) render_encode_draw:
  (struct metil_object_buffer*) buffers_vertex
  length_buffers_vertex: (unsigned int) length_buffers_vertex
  buffers_fragment: (struct metil_object_buffer*) buffers_fragment
  length_buffers_fragment: (unsigned int) length_buffers_fragment
  indices: (id<MTLBuffer>) indices
  length_indices: (unsigned int) length_indices
  textures: (id<MTLTexture>*) textures
  length_textures: (unsigned char) length_textures
  index_pipeline_render: (unsigned short int) index_pipeline_render
  depth_disabled: (unsigned char) depth_disabled
  type_primitive: (MTLPrimitiveType) type_primitive
  type_index: (MTLIndexType) type_index
{
  [
    encoder_render
    setRenderPipelineState: (
      self->pipelines_render[
        index_pipeline_render
      ]
    )
  ];

  if (
    depth_disabled ==
    0x00
  ) {
    [
      encoder_render
      setDepthStencilState: (
        self->depth_state
      )
    ];
  } else {
    [
      encoder_render
      setDepthStencilState: (
        self->depth_state_writes_disabled
      )
    ];
  }

  struct metil_object_buffer* buffer_vertex = (
    0x00
  );

  struct metil_object_buffer* buffer_fragment = (
    0x00
  );

  [
    encoder_render
    setVertexBuffer: (
      self->data_buffer_frame[
        self->index_data_buffer_frame
      ]
    )
    offset: (
      0x00
    )
    atIndex: (
      metil_renderer_vertex_index_parameter_data_frame
    )
  ];

  for (
    unsigned char index_buffer_vertex = (
      0x00
    );
    (
      index_buffer_vertex <
      length_buffers_vertex
    );
    ++index_buffer_vertex
  ) {
    buffer_vertex = &(
      buffers_vertex[
        index_buffer_vertex
      ]
    );

    [
      encoder_render
      setVertexBuffer: buffer_vertex->buffer
      offset: buffer_vertex->offset
      atIndex: buffer_vertex->index
    ];
  }

  [
    encoder_render
    setFragmentBuffer: (
      self->data_buffer_frame[
        self->index_data_buffer_frame
      ]
    )
    offset: 0x00
    atIndex: metil_renderer_fragment_index_parameter_data_frame
  ];

  for (
    unsigned char index_buffer_fragment = (
      0x00
    );
    (
      index_buffer_fragment <
      length_buffers_fragment
    );
    ++index_buffer_fragment
  ) {
    buffer_fragment = &(
      buffers_fragment[
        index_buffer_fragment
      ]
    );

    [
      encoder_render
      setFragmentBuffer: buffer_fragment->buffer
      offset: buffer_fragment->offset
      atIndex: buffer_fragment->index
    ];
  }

  for (
    unsigned char index_texture = (
      0x00
    );
    (
      index_texture <
      length_textures
    );
    ++index_texture
  ) {
    [
      encoder_render
      setFragmentTexture: (
        textures[
          index_texture
        ]
      )
      atIndex: index_texture
    ];
  }

  [
    encoder_render
    drawIndexedPrimitives: type_primitive
    indexCount: length_indices
    indexType: type_index
    indexBuffer: indices
    indexBufferOffset: 0x00
  ];
}

- (void) render_object: (struct metil_object*) metil_object {
  if (
    metil_object->visible ==
    0x01
  ) {
    [
      self
      render_encode_draw: metil_object->buffers_vertex
      length_buffers_vertex: metil_object->length_buffers_vertex
      buffers_fragment: metil_object->buffers_fragment
      length_buffers_fragment: metil_object->length_buffers_fragment
      indices: metil_object->indices
      length_indices: metil_object->mesh.length_indices
      textures: metil_object->textures
      length_textures: metil_object->length_textures
      index_pipeline_render: metil_object->index_pipeline_render
      depth_disabled: metil_object->depth_disabled
      type_primitive: metil_object->type_primitive
      type_index: metil_object->type_index
    ];
  }
}

- (void) render_object_wireframe: (struct metil_object*) metil_object {
  if (
    metil_object->visible ==
    0x01
  ) {
    [
      self
      render_encode_draw: metil_object->buffers_vertex
      length_buffers_vertex: metil_object->length_buffers_vertex
      buffers_fragment: metil_object->buffers_fragment
      length_buffers_fragment: metil_object->length_buffers_fragment
      indices: metil_object->indices
      length_indices: metil_object->mesh.length_indices
      textures: 0x00
      length_textures: 0x00
      index_pipeline_render: metil_renderer_pipelines_render_index_wireframe
      depth_disabled: metil_object->depth_disabled
      type_primitive: MTLPrimitiveTypeLineStrip
      type_index: metil_object->type_index
    ];
  }
}

- (void) stencils_depth_initialize {
  MTLDepthStencilDescriptor* descriptor_stencil_depth = [
    [
      MTLDepthStencilDescriptor
      alloc
    ]
    init
  ];

  descriptor_stencil_depth.depthCompareFunction = (
    MTLCompareFunctionLessEqual
  );

  descriptor_stencil_depth.depthWriteEnabled = (
    0x01
  );

  self->depth_state = [
    self->metil->renderer_interface.metal_device
    newDepthStencilStateWithDescriptor: descriptor_stencil_depth
  ];

  descriptor_stencil_depth.depthWriteEnabled = (
    0x00
  );

  self->depth_state_writes_disabled = [
    self->metil->renderer_interface.metal_device
    newDepthStencilStateWithDescriptor: descriptor_stencil_depth
  ];
}

- (void) termination_functions_initialize {
  metil_termination_on_function_add(
    &self->metil->termination,
    metil_renderer_on_termination,
    self
  );

  metil_termination_on_function_add(
    &self->metil->termination,
    metil_text_characters_destroy,
    &self->metil->text_characters_default
  );
}

@end

void metil_renderer_poll_object(
  struct metil_renderer_thread_poll_object_data* metil_renderer_thread_poll_object_data,
  struct metil_renderable* metil_renderable
) {
  switch (
    metil_renderable->type
  ) {
    case metil_renderable_type_group: {
      struct metil_group* metil_group = (
        metil_renderable->renderable
      );

      for (
        unsigned int index_group_renderable = (
          0x00
        );
        (
          index_group_renderable <
          metil_group->length
        );
        ++index_group_renderable
      ) {
        metil_renderer_poll_object(
          metil_renderer_thread_poll_object_data,
          metil_group->renderables[
            index_group_renderable
          ]
        );
      }

      break;
    }
    case metil_renderable_type_object: {
      struct metil_object* object = (
        metil_renderable->renderable
      );

      object->poll(
        metil_renderer_thread_poll_object_data->metil,
        object,
        metil_renderer_thread_poll_object_data->matrix_static_projection,
        metil_renderer_thread_poll_object_data->matrix_object_projection,
        metil_renderer_thread_poll_object_data->matrix_player_projection,
        metil_renderer_thread_poll_object_data->camera
      );
      break;
    }
    case metil_renderable_type_menu: {
      break;
    }
    case metil_renderable_type_model: {
      struct metil_model* metil_model = (
        metil_renderable->renderable
      );

      metil_model->poll(
        metil_renderer_thread_poll_object_data->metil,
        metil_model,
        metil_renderer_thread_poll_object_data->matrix_static_projection,
        metil_renderer_thread_poll_object_data->matrix_object_projection,
        metil_renderer_thread_poll_object_data->matrix_player_projection,
        metil_renderer_thread_poll_object_data->camera
      );
      break;
    }
    default: {
      break;
    }
  }
}

#if target_os_ios
void* _Nullable metil_renderer_thread_draw(
  void* reference
) {
  MTKView* metal_kit_view = (    reference
  );

  [
    metal_kit_view
    draw
  ];

  return (
    0x00
  );
}
#endif

void* metil_renderer_thread_poll_object(
  void* data
) {
  struct metil_renderer_thread_poll_object_data* metil_renderer_thread_poll_object_data = (
    data
  );

  for (
    unsigned int index_renderable = (
      0x00
    );
    (
      index_renderable <
      metil_renderer_thread_poll_object_data->length_renderables
    );
    ++index_renderable
  ) {
    metil_renderer_poll_object(
      metil_renderer_thread_poll_object_data,
      &(
        metil_renderer_thread_poll_object_data->renderables[
          index_renderable
        ]
      )
    );
  }

  return (
    0x00
  );
}

void metil_renderer_after_scene_change(
  struct metil* metil,
  int id_scene,
  void* reference
) {
  metil_renderer* renderer = (
    reference
  );

  [
    renderer
    after_scene_change
  ];
}

void metil_renderer_on_termination(
  void* reference
) {
  metil_renderer* renderer = (
    reference
  );

  [
    renderer
    destroy
  ];
}
