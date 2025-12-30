#include <metil_rendering/metil_renderer.h>

#include <metil_application/metil_renderer_size.h>
#include <metil_audio/metil_audio.h>
#include <metil_audio/metil_audio_data.h>
#include <metil_configuration/metil_configuration.h>
#include <metil_group.h>
#include <metil_input/metil_controller_state.h>
#include <metil_input/metil_input_map.h>
#include <metil_input/metil_keycodes.h>
#include <metil_library.h>
#include <metil_mesh/metil_mesh.h>
#include <metil_model/metil_model.h>
#include <metil_object.h>
#include <metil_positioning.h>
#include <metil_rendering/metil_camera/metil_camera.h>
#include <metil_rendering/metil_descriptors/metil_pipeline_render.h>
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
#include <clic3_vector.h>

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

metil_renderer_on_initialize_function metil_renderer_on_initialize = (void*)0;
void* metil_renderer_on_initialize_data = (void*)0;

@implementation metil_renderer

- (nonnull instancetype) metil_renderer_initialize:
  (nonnull MTKView*) metal_kit_view
  metil: (nonnull struct metil*) parameter_metil
{
  self = [super init];

  if (
    self == (void*)0
  ) {
    return self;
  }

  self->metil = (
    parameter_metil
  );

  [self initialize_null];

  self->length_threads = (
    metil_system_information.cores_cpu *
    metil_count_max_frames
  );

  self->threads = malloc(
    sizeof(pthread_t*) *
    self->length_threads
  );

  self->threads_data = malloc(
    sizeof(struct metil_renderer_thread_poll_object_data) *
    self->length_threads
  );

  for (
    unsigned int index_thread = 0;
    index_thread < self->length_threads;
    ++index_thread
  ) {
    self->threads[
      index_thread
    ] = (void*)0;

    self->threads_data[
      index_thread
    ].matrix_static_projection = (
      &self->matrix_projection_static
    );

    self->threads_data[
      index_thread
    ].camera = (
      &self->metil->rendering_properties.camera
    );
  }

  self->metal_device = (
    metal_kit_view.device
  );

  [self rendering_properties_initialize];
  [self termination_functions_initialize];

  metil_text_characters_initialize(
    self->metal_device
  );

  metil_scene_controller_after_scene_change_add(
    metil_renderer_after_scene_change,
    self
  );

  [self command_queue_initialize];
  [self data_buffer_frames_initialize];
  [self stencils_depth_initialize];
  [self fps_display_objects_initialize];
  [self descriptor_pipeline_render_initialize];

  self->metil->renderer_interface.renderer = self;
  self->metil->renderer_interface.metal_device = self->metal_device;

  if (metil_renderer_on_initialize != (void*)0) {
    metil_renderer_on_initialize(
      self->metil,
      metil_renderer_on_initialize_data
    );
  }

  [self pipelines_initialize];

  return self;
}

- (void) after_scene_change {}

- (void) command_queue_initialize {
  self->command_queue = [self->metal_device
    newCommandQueue
  ];
}

- (void) data_buffer_frames_initialize {
  for (
    unsigned int index_buffer = 0;
    index_buffer < metil_count_max_frames;
    ++index_buffer
  ) {
    data_buffer_frame[
      index_buffer
    ] = [self->metal_device
      newBufferWithLength: sizeof(struct metil_renderer_data_frame)
      options: MTLResourceStorageModeShared
    ];
  }
}

- (void) descriptor_pipeline_render_initialize {
  if (
    self->descriptor_pipeline_render == (void*)0
  ) {
    self->descriptor_pipeline_render = [[MTLRenderPipelineDescriptor alloc] init];
    metil_rendering_descriptors_pipeline_render_initialize(
      self->descriptor_pipeline_render,
      1,
      (void*)0,
      (void*)0,
      MTLPixelFormatBGRA8Unorm_sRGB,
      MTLPixelFormatDepth32Float_Stencil8,
      MTLPixelFormatDepth32Float_Stencil8
    );
  }
}

- (void) destroy {
  for (
    unsigned int index_thread = 0;
    index_thread < self->length_threads;
    ++index_thread
  ) {
    if (
      self->threads[
        index_thread
      ] == (void*)0
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
      (void*)0
    );
  }

  free(self->threads);
  free(self->threads_data);

  [self->metal_device release];

  for (
    unsigned char index_data_buffer_frame_release = 0;
    index_data_buffer_frame_release < metil_count_max_frames;
    ++index_data_buffer_frame_release
  ) {
    [self->data_buffer_frame[index_data_buffer_frame_release] release];
  }

  [self->index_buffer_mesh_current release];
  [self->command_queue release];
  [self->descriptor_pipeline_render release];

  if (
    self->encoder_render_encoding == 1
  ) {
    [self->encoder_render endEncoding];
  }
  
  #if !target_os_ios
  [self->encoder_render release];
  #endif

  for (
    unsigned char index_pipeline_render = 0;
    index_pipeline_render < self->length_pipelines_render;
    ++index_pipeline_render
  ) {
    if (
      self->pipelines_render[index_pipeline_render] != (void*)0
    ) {
      [self->pipelines_render[index_pipeline_render] release];
    }
  }

  free(
    self->pipelines_render
  );

  [self->depth_state release];
  [self->depth_state_writes_disabled release];

  for (
    unsigned char index_object_fps_display = 0;
    index_object_fps_display < metil_renderer_length_objects_fps_display;
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
  const unsigned int _frame = (
    self->metil->rendering_properties.frame++
  );

  if (_frame == 0) {
    metil_audio_data.muted = 0;
  }

  if (
    self->metil->rendering_properties.frame + 1 >= UINT_MAX - 1
  ) {
    self->metil->rendering_properties.frame = 1;
  }

  self->metil->rendering_properties.count_completed_frames = (
    self->metil->rendering_properties.count_completed_frames - 1
  );

  if (
    self->metil->rendering_properties.count_completed_frames <= 0
  ) {
    pthread_mutex_lock(
      &self->metil->rendering_properties.mutex_frame
    );
  }

  self->index_data_buffer_frame = (
    (self->index_data_buffer_frame + 1) % metil_count_max_frames
  );

  id<MTLCommandBuffer> command_buffer = [self->command_queue commandBuffer];

  MTLRenderPassDescriptor* descriptor_render_pass = metal_kit_view.currentRenderPassDescriptor;
  descriptor_render_pass.colorAttachments[0].clearColor = MTLClearColorMake(
    self->metil->rendering_properties.color_clear.x,
    self->metil->rendering_properties.color_clear.y,
    self->metil->rendering_properties.color_clear.z,
    self->metil->rendering_properties.color_clear.w
  );

  encoder_render = [command_buffer renderCommandEncoderWithDescriptor: descriptor_render_pass];
  self->encoder_render_encoding = 1;

  if (
    self->pipelines_render[
      self->index_pipelines_render_current
    ] == (void*)0 &&
    self->pipelines_render[
      metil_renderer_pipelines_render_index_library
    ] != (void*)0
  ) {
    self->index_pipelines_render_current = metil_renderer_pipelines_render_index_library;
  }

  [encoder_render setRenderPipelineState: self->pipelines_render[
    self->index_pipelines_render_current
  ]];

  if (
    self->depth_state_disabled == 0
  ) {
    [encoder_render setDepthStencilState: self->depth_state];
  } else {
    [encoder_render setDepthStencilState: self->depth_state_writes_disabled];
  }
  self->depth_state_disabled = 0;

  [self poll: _frame];
  [self render];

  if (
    self->metil->rendering_properties.fps_display == 1 &&
    self->pipelines_render[
      metil_renderer_pipelines_render_index_fps_display
    ] != (void*)0 &&
    self->metil->rendering_properties.frame > 10
  ) {
    [self render_fps_display];
  }

  [encoder_render endEncoding];
  self->encoder_render_encoding = 0;

  [command_buffer addCompletedHandler:^(id<MTLCommandBuffer> buffer) {
    self->metil->rendering_properties.count_completed_frames = (
      self->metil->rendering_properties.count_completed_frames + 1
    );

    for (
      unsigned char index_time_frame = 0;
      index_time_frame < metil_count_time_frames - 1;
      ++index_time_frame
    ) {
      self->metil->rendering_properties.time_frames[
        index_time_frame
      ] = self->metil->rendering_properties.time_frames[
        index_time_frame + 1
      ];
    }

    self->metil->rendering_properties.time_frames[
      metil_count_time_frames - 1
    ] = metil_time_milliseconds_get() - 1759219190000;

    float time_difference_average = 0.0f;

    for (
      unsigned char index_time_frame = 0;
      index_time_frame < metil_count_time_frames - 1;
      ++index_time_frame
    ) {
      time_difference_average = (
        time_difference_average + (float) (
          self->metil->rendering_properties.time_frames[
          index_time_frame + 1
        ] - self->metil->rendering_properties.time_frames[
          index_time_frame
        ]) / (float) (metil_count_time_frames - 1)
      );
    }

    self->metil->rendering_properties.fps = (
      1000.0f /
      time_difference_average
    );

    if (
      self->metil->rendering_properties.count_completed_frames == 0 ||
      self->metil->rendering_properties.count_completed_frames == 1
    ) {
      pthread_mutex_unlock(
        &self->metil->rendering_properties.mutex_frame
      );
    }
  }];

  [command_buffer presentDrawable: metal_kit_view.currentDrawable];
  [command_buffer commit];
}

- (void) drawableSizeWillChange: (CGSize) size {
  /*
    Certain sizes cause rendering to stutter and slow down

    1920x1204 is fine
    1920x1203 is fine
    1920x1202 causes slow down
  */
  metil_renderer_size.x = size.width;
  metil_renderer_size.y = size.height;

  metil_camera_ratio_aspect_set(
    &self->metil->rendering_properties.camera,
    16 / 9,
    metil_renderer_size.x,
    metil_renderer_size.y
  );

  self->matrix_projection_static.columns[0][0] = (
    self->metil->rendering_properties.camera.ratio_aspect /
    self->metil->rendering_properties.camera.ratio_aspect_view
  );
}

- (void) fps_display_objects_initialize {
  for (
    unsigned char index_object_fps_display = 0;
    index_object_fps_display < metil_renderer_length_objects_fps_display;
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
      self->metal_device,
      metil_object_buffer_type_vertex
    );

    metil_object_buffers_add(
      &self->objects_fps_display[
        index_object_fps_display
      ],
      self->metal_device,
      metil_object_buffer_type_vertex
    );

    metil_object_texture_add(
      &self->objects_fps_display[
        index_object_fps_display
      ],
      (void*)0
    );

    self->objects_fps_display[
      index_object_fps_display
    ].position.y = 0.0f;

    self->objects_fps_display[
      index_object_fps_display
    ].position.z = 0.0f;

    self->objects_fps_display[
      index_object_fps_display
    ].positioning = (
      metil_positioning_static
    );

    self->objects_fps_display[
      index_object_fps_display
    ].buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer = [self->metal_device
      newBufferWithLength: sizeof(struct metil_renderer_data_object)
      options: MTLResourceStorageModeShared
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
  self->metal_device = (void*)0;

  self->command_queue = (void*)0;
  self->depth_state = (void*)0;
  self->depth_state_writes_disabled = (void*)0;
  self->descriptor_pipeline_render = (void*)0;
  self->encoder_render = (void*)0;
  self->encoder_render_encoding = 0;
  self->index_buffer_mesh_current = (void*)0;

  self->matrix_projection_static = (matrix_float3x4) {{
    { 1.0f, 0.0f, 0.0f, 0.0f },
    { 0.0f, 1.0f, 0.0f, 0.0f },
    { 0.0f, 0.0f, 1.0f, 0.0f },
  }};

  for (
    unsigned char index_data_buffer_frame_initializer = 0;
    index_data_buffer_frame_initializer < metil_count_max_frames;
    ++index_data_buffer_frame_initializer
  ) {
    self->data_buffer_frame[
      index_data_buffer_frame_initializer
    ] = (void*)0;
  }

  self->length_pipelines_render = 3;
  self->pipelines_render = malloc(
    sizeof(id<MTLRenderPipelineState>) *
    self->length_pipelines_render
  );

  for (
    unsigned short int index_pipeline_render = 0;
    index_pipeline_render < self->length_pipelines_render;
    ++index_pipeline_render
  ) {
    self->pipelines_render[
      index_pipeline_render
    ] = (void*)0;
  }

  self->depth_state_disabled = 0;
  self->index_pipelines_render_current = metil_renderer_pipelines_render_index_library;
}

- (void) mtkView: (nonnull MTKView*) metal_kit_view drawableSizeWillChange: (CGSize) size {}

- (unsigned short int) pipeline_add: (id<MTLFunction>) function_fragment function_vertex: (id<MTLFunction>) function_vertex {
  self->descriptor_pipeline_render.fragmentFunction = function_fragment;
  self->descriptor_pipeline_render.vertexFunction = function_vertex;

  self->length_pipelines_render = (
    self->length_pipelines_render + 1
  );

  self->pipelines_render = realloc(
    self->pipelines_render,
    sizeof(id<MTLRenderPipelineState>) *
    self->length_pipelines_render
  );

  self->pipelines_render[
    self->length_pipelines_render - 1
  ] = [self->metal_device
    newRenderPipelineStateWithDescriptor: self->descriptor_pipeline_render
    error: (void*)0
  ];

  return self->length_pipelines_render - 1;
}

- (void) pipelines_clear {
  for (
    unsigned short int index_pipeline_render = 3;
    index_pipeline_render < self->length_pipelines_render;
    ++index_pipeline_render
  ) {
    [self->pipelines_render[index_pipeline_render] release];
  }

  self->length_pipelines_render = 3;
  self->pipelines_render = realloc(
    self->pipelines_render,
    sizeof(id<MTLRenderPipelineState>) *
    self->length_pipelines_render
  );
}

- (void) pipelines_initialize {
  [self pipeline_render_fps_display_initiliaze];
  [self pipeline_render_library_initiliaze];
  [self pipeline_render_wireframe_initialize];
}

- (void) pipeline_render_initialize:
  (unsigned short int) index_pipeline_render
  function_fragment: (id<MTLFunction>) function_fragment
  function_vertex: (id<MTLFunction>) function_vertex {
  if (
    self->pipelines_render[
      index_pipeline_render
    ] == (void*) 0 &&
    function_fragment != (void*)0 &&
    function_vertex != (void*)0
  ) {
    self->descriptor_pipeline_render.fragmentFunction = function_fragment;
    self->descriptor_pipeline_render.vertexFunction = function_vertex;

    self->pipelines_render[
      index_pipeline_render
    ] = [self->metal_device
      newRenderPipelineStateWithDescriptor: self->descriptor_pipeline_render
      error: (void*)0
    ];
  }
}


- (void) pipeline_render_library_initiliaze {
  [self
    pipeline_render_initialize: metil_renderer_pipelines_render_index_library
    function_fragment: self->metil->library.function_fragment
    function_vertex: self->metil->library.function_vertex
  ];
}

- (void) pipeline_render_wireframe_initialize {
  [self
    pipeline_render_initialize: metil_renderer_pipelines_render_index_wireframe
    function_fragment: self->metil->library.function_fragment_wireframe
    function_vertex: self->metil->library.function_vertex_wireframe
  ];
}

- (void) pipeline_render_fps_display_initiliaze {
  [self
    pipeline_render_initialize: metil_renderer_pipelines_render_index_fps_display
    function_fragment: self->metil->library.function_fragment_fps_display
    function_vertex: self->metil->library.function_vertex_fps_display
  ];
}

- (void) poll: (unsigned int) _frame {
  metil_controller_state_poll();

  unsigned long int time = metil_time_milliseconds_get();

  metil_scene_poll_input(
    &metil_scene_controller.scene,
    time
  );

  metil_scene_poll(
    &metil_scene_controller.scene,
    time
  );

  struct metil_renderer_data_frame* data_frame = (
    data_buffer_frame[self->index_data_buffer_frame]
  ).contents;

  data_frame->frame = _frame;

  data_frame->rotation_camera.x = metil_scene_controller.scene.player.rotation.x;
  data_frame->rotation_camera.y = metil_scene_controller.scene.player.rotation.y;
  data_frame->rotation_camera.z = metil_scene_controller.scene.player.rotation.z;

  data_frame->position_player.x = metil_scene_controller.scene.player.position.x;
  data_frame->position_player.y = metil_scene_controller.scene.player.position.y;
  data_frame->position_player.z = metil_scene_controller.scene.player.position.z;

  data_frame->brightness = (
    metil_scene_controller.scene.rendering_properties.brightness *
    self->metil->rendering_properties.brightness
  );

  data_frame->brightness_text = (
    metil_scene_controller.scene.rendering_properties.brightness_text *
    self->metil->rendering_properties.brightness_text
  );

  matrix_float4x4 matrix_player_rotation_x = (matrix_float4x4) {{
    { 1.0f, 0.0f, 0.0f, 0.0f },
    { 0.0f, cos(metil_scene_controller.scene.player.rotation.x), -sin(metil_scene_controller.scene.player.rotation.x), 0.0f },
    { 0.0f, sin(metil_scene_controller.scene.player.rotation.x), cos(metil_scene_controller.scene.player.rotation.x), 0.0f },
    { 0.0f, 0.0f, 0.0f, 1.0f }
  }};

  if (
    self->metil->rendering_properties.camera.mode == metil_camera_mode_third_person
  ) {
    matrix_player_rotation_x.columns[
      3
    ].y = (
      self->metil->rendering_properties.camera.height * (
        1.0f - (
          (
            -metil_scene_controller.scene.player.rotation.x
          ) / (
            M_PI / 2.0f
          )
        )
      )
    );

    matrix_player_rotation_x.columns[
      3
    ].z = -(
      matrix_player_rotation_x.columns[
        3
      ].y
    );
  }

  matrix_float4x4 matrix_player_rotation_y = (matrix_float4x4) {{
    { cos(metil_scene_controller.scene.player.rotation.y), 0.0f, sin(metil_scene_controller.scene.player.rotation.y), 0.0f },
    { 0.0f, 1.0f, 0.0f, 0.0f },
    { sin(metil_scene_controller.scene.player.rotation.y), 0.0f, -cos(metil_scene_controller.scene.player.rotation.y), 0.0f },
    { 0.0f, 0.0f, 0.0f, 1.0f }
  }};

  matrix_float4x4 matrix_player_projection = matrix_multiply(
    self->metil->rendering_properties.camera.matrix_viewport_projection,
    matrix_player_rotation_x
  );

  matrix_float4x4 matrix_object_projection = matrix_multiply(
    matrix_player_projection,
    matrix_player_rotation_y
  );

  unsigned char _index_data_buffer_frame = self->index_data_buffer_frame;
  unsigned int length_segment_objects = (
    metil_scene_controller.scene.length_renderables /
    metil_system_information.cores_cpu
  );

  for (
    unsigned int index_core_cpu = 0;
    index_core_cpu < metil_system_information.cores_cpu;
    ++index_core_cpu
  ) {
    unsigned int index_thread = (
      metil_system_information.cores_cpu *
      _index_data_buffer_frame +
      index_core_cpu 
    );

    if (
      self->threads[
        index_thread
      ] != (void*)0
    ) {
      pthread_join(
        self->threads[
          index_thread
        ],
        (void*)0
      );
    }

    unsigned int offset_index_object = (
      length_segment_objects * index_core_cpu
    );

    self->threads_data[
      index_thread
    ].renderables = (
      metil_scene_controller.scene.renderables +
      offset_index_object
    );

    self->threads_data[
      index_thread
    ].length_renderables = (
      index_core_cpu < metil_system_information.cores_cpu - 1
      ? length_segment_objects
      : (metil_scene_controller.scene.length_renderables) - (
        length_segment_objects * index_core_cpu
      )
    );

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
      (void*)0,
      metil_renderer_thread_poll_object,
      &self->threads_data[
        index_thread
      ]
    );
  }

  if (
    self->metil->rendering_properties.fps_display == 1
  ) {
    [self
      poll_fps_display: &matrix_object_projection
      matrix_player_projection: &matrix_player_projection
    ];
  }

  for (
    unsigned int index_core_cpu = 0;
    index_core_cpu < metil_system_information.cores_cpu;
    ++index_core_cpu
  ) {
    unsigned int index_thread = (
      metil_system_information.cores_cpu *
      _index_data_buffer_frame +
      index_core_cpu 
    );

    pthread_join(
      self->threads[
        index_thread
      ],
      (void*)0
    );

    self->threads[
      index_thread
    ] = (void*)0;
  }
}

- (void) poll_fps_display:
  (matrix_float4x4*) matrix_object_projection
  matrix_player_projection: (matrix_float4x4*) matrix_player_projection
{
  if (
    self->metil->rendering_properties.frame == 0 ||
    self->metil->rendering_properties.frame % 10 != 0
  ) {
    return;
  }

  char* char_array_fps = clic3_char_array_from_float(
    self->metil->rendering_properties.fps
  );

  float position_x = 0.0f;

  for (
    signed char index_object_fps_display = metil_renderer_length_objects_fps_display - 1;
    index_object_fps_display >= 0;
    --index_object_fps_display
  ) {
    if (
      char_array_fps[index_object_fps_display] == '\0'
    ) {
      break;
    }

    self->objects_fps_display[
      index_object_fps_display
    ].mesh = metil_text_characters_default.meshes[
      char_array_fps[index_object_fps_display]
    ];

    position_x = position_x + self->objects_fps_display[
      index_object_fps_display
    ].mesh.size.x / self->metil->rendering_properties.camera.ratio_aspect_view;

    self->objects_fps_display[
      index_object_fps_display
    ].position.x = 1.0f - position_x;

    if (char_array_fps[index_object_fps_display] == '.') {
      self->objects_fps_display[
        index_object_fps_display
      ].position.x = self->objects_fps_display[
        index_object_fps_display
      ].position.x - 0.0035f;
      self->objects_fps_display[
        index_object_fps_display
      ].position.y = 0.9675f;
    } else {
      self->objects_fps_display[
        index_object_fps_display
      ].position.y = 0.975f;
    }

    self->objects_fps_display[
      index_object_fps_display
    ].indices = metil_text_characters_default.indices;

    self->objects_fps_display[
      index_object_fps_display
    ].buffers_vertex[
      metil_object_buffer_default_index_vertices
    ].buffer = metil_text_characters_default.vertices[
      char_array_fps[
        index_object_fps_display
      ]
    ];

    self->objects_fps_display[
      index_object_fps_display
    ].buffers_vertex[
      metil_object_buffer_default_index_vertices
    ].offset = 0;

    self->objects_fps_display[
      index_object_fps_display
    ].buffers_vertex[
      metil_object_buffer_default_index_vertices
    ].index = metil_object_buffer_default_index_data;

    self->objects_fps_display[
      index_object_fps_display
    ].textures[0] = metil_text_characters_default.textures[
      char_array_fps[index_object_fps_display]
    ];

    self->objects_fps_display[
      index_object_fps_display
    ].poll(
      &self->objects_fps_display[
        index_object_fps_display
      ],
      &self->matrix_projection_static,
      matrix_object_projection,
      matrix_player_projection,
      &self->metil->rendering_properties.camera
    );
  }

  free(char_array_fps);
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

      for (
        unsigned int index_group_renderable = 0;
        index_group_renderable < metil_group->length;
        ++index_group_renderable
      ) {
        [self
          render_renderable: metil_group->renderables[
            index_group_renderable
          ]
        ];
      }
      break;
    }
    case metil_renderable_type_object: {
      struct metil_object* metil_object = (
        metil_renderable->renderable
      );

      if (
        self->metil->rendering_properties.mode & metil_rendering_properties_mode_default
      ) {
        [self
          render_object: metil_object
        ];
      }

      if (
        self->metil->rendering_properties.mode & metil_rendering_properties_mode_wireframe
      ) {
        [self
          render_object_wireframe: metil_object
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

      for (
        unsigned char index_object = 0;
        index_object < metil_model->length_objects;
        ++index_object
      ) {
        struct metil_object* metil_object = &(
          metil_model->objects[
            index_object
          ]
        );

        if (
          self->metil->rendering_properties.mode & metil_rendering_properties_mode_default
        ) {
          [self
            render_object: metil_object
          ];
        }

        if (
          self->metil->rendering_properties.mode & metil_rendering_properties_mode_wireframe
        ) {
          [self
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
  struct metil_renderable* renderable = (
    (void*)0
  );

  for (
    unsigned int index_renderable = 0;
    index_renderable < metil_scene_controller.scene.length_renderables;
    ++index_renderable
  ) {
    renderable = &(
      metil_scene_controller.scene.renderables[
        index_renderable
      ]
    );

    [self
      render_renderable: renderable
    ];
  }
}

- (void) render_fps_display {
  for (
    unsigned char index_object_fps_display = 0;
    index_object_fps_display < metil_renderer_length_objects_fps_display;
    ++index_object_fps_display
  ) {
    [self
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
  [encoder_render
    setRenderPipelineState: self->pipelines_render[
      index_pipeline_render
    ]
  ];

  if (
    depth_disabled == 0
  ) {
    [encoder_render
      setDepthStencilState: self->depth_state
    ];
  } else {
    [encoder_render
      setDepthStencilState: self->depth_state_writes_disabled
    ];
  }

  struct metil_object_buffer* buffer_vertex = (
    (void*) 0
  );

  struct metil_object_buffer* buffer_fragment = (
    (void*) 0
  );

  [encoder_render
    setVertexBuffer: self->data_buffer_frame[
      self->index_data_buffer_frame
    ]
    offset: 0
    atIndex: metil_renderer_vertex_index_parameter_data_frame
  ];

  for (
    unsigned char index_buffer_vertex = 0;
    index_buffer_vertex < length_buffers_vertex;
    ++index_buffer_vertex
  ) {
    buffer_vertex = &(
      buffers_vertex[
        index_buffer_vertex
      ]
    );

    [encoder_render
      setVertexBuffer: buffer_vertex->buffer
      offset: buffer_vertex->offset
      atIndex: buffer_vertex->index
    ];
  }

  [encoder_render
    setFragmentBuffer: self->data_buffer_frame[
      self->index_data_buffer_frame
    ]
    offset: 0
    atIndex: metil_renderer_fragment_index_parameter_data_frame
  ];

  for (
    unsigned char index_buffer_fragment = 0;
    index_buffer_fragment < length_buffers_fragment;
    ++index_buffer_fragment
  ) {
    buffer_fragment = &(
      buffers_fragment[
        index_buffer_fragment
      ]
    );

    [encoder_render
      setFragmentBuffer: buffer_fragment->buffer
      offset: buffer_fragment->offset
      atIndex: buffer_fragment->index
    ];
  }

  for (
    unsigned char index_texture = 0;
    index_texture < length_textures;
    ++index_texture
  ) {
    [encoder_render
      setFragmentTexture: textures[
        index_texture
      ]
      atIndex: index_texture
    ];
  }

  [encoder_render
    drawIndexedPrimitives: type_primitive
    indexCount: length_indices
    indexType: type_index
    indexBuffer: indices
    indexBufferOffset: 0
  ];
}

- (void) render_object: (struct metil_object*) object {
  if (
    object->visible == 1
  ) {
    [self
      render_encode_draw: object->buffers_vertex
      length_buffers_vertex: object->length_buffers_vertex
      buffers_fragment: object->buffers_fragment
      length_buffers_fragment: object->length_buffers_fragment
      indices: object->indices
      length_indices: object->mesh.length_indices
      textures: object->textures
      length_textures: object->length_textures
      index_pipeline_render: object->index_pipeline_render
      depth_disabled: object->depth_disabled
      type_primitive: object->type_primitive
      type_index: object->type_index
    ];
  }
}

- (void) render_object_wireframe: (struct metil_object*) object {
  if (
    object->visible == 1
  ) {
    [self
      render_encode_draw: object->buffers_vertex
      length_buffers_vertex: object->length_buffers_vertex
      buffers_fragment: object->buffers_fragment
      length_buffers_fragment: object->length_buffers_fragment
      indices: object->indices
      length_indices: object->mesh.length_indices
      textures: (void*)0
      length_textures: 0
      index_pipeline_render: metil_renderer_pipelines_render_index_wireframe
      depth_disabled: object->depth_disabled
      type_primitive: MTLPrimitiveTypeLineStrip
      type_index: object->type_index
    ];
  }
}

- (void) rendering_properties_initialize {
  metil_rendering_properties_initialize(
    &self->metil->rendering_properties
  );

  self->metil->rendering_properties.brightness = (
    metil_configuration.rendering_properties.brightness
  );

  self->metil->rendering_properties.brightness_text = (
    metil_configuration.rendering_properties.brightness_text
  );

  self->metil->rendering_properties.fps_display = (
    metil_configuration.rendering_properties.fps_display
  );
}

- (void) stencils_depth_initialize {
  MTLDepthStencilDescriptor* descriptor_stencil_depth = [[MTLDepthStencilDescriptor alloc] init];
  descriptor_stencil_depth.depthCompareFunction = MTLCompareFunctionLessEqual;
  descriptor_stencil_depth.depthWriteEnabled = 1;
  self->depth_state = [self->metal_device
    newDepthStencilStateWithDescriptor: descriptor_stencil_depth
  ];

  descriptor_stencil_depth.depthWriteEnabled = 0;
  self->depth_state_writes_disabled = [self->metal_device
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
    (void*)0
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
        unsigned int index_group_renderable = 0;
        index_group_renderable < metil_group->length;
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

void* metil_renderer_thread_poll_object(
  void* data
) {
  struct metil_renderer_thread_poll_object_data* metil_renderer_thread_poll_object_data = (
    data
  );

  for (
    unsigned int index_renderable = 0;
    index_renderable < metil_renderer_thread_poll_object_data->length_renderables;
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
    (void*) 0
  );
}

void metil_renderer_after_scene_change(
  int _,
  void* _Nonnull reference
) {
  metil_renderer* renderer = (metil_renderer*) reference;

  [renderer after_scene_change];
}

void metil_renderer_on_termination(
  void* _Nonnull reference
) {
  metil_renderer* renderer = (metil_renderer*) reference;

  [renderer destroy];
}
