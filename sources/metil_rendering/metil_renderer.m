#include <metil_rendering/metil_renderer.h>

#include <metil_audio/audio.h>
#include <metil_configuration/configuration.h>
#include <metil_input/controller_state.h>
#include <metil_input/map.h>
#include <metil_input/keycodes.h>
#include <metil_library.h>
#include <metil_mesh/mesh.h>
#include <metil_object.h>
#include <metil_rendering/camera/camera.h>
#include <metil_rendering/descriptors/pipeline_render.h>
#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>
#include <metil_scenes/scene.h>
#include <metil_scenes/scene_controller.h>
#include <metil_termination.h>
#include <metil_text/text_characters.h>
#include <metil_utilities/time.h>

#include <clic3.h>

#include <limits.h>
#include <simd/simd.h>

#include <MetalKit/MetalKit.h>

metil_renderer_on_initialize_function metil_renderer_on_initialize = (void*)0;
void* metil_renderer_on_initialize_data = (void*)0;

@implementation metil_renderer

- (nonnull instancetype) initWithMetalKitView: (nonnull MTKView*) metal_kit_view {
  self = [super init];

  if (
    self == (void*)0
  ) {
    return self;
  }

  [self initialize_null];

  self->metal_kit_device = metal_kit_view.device;

  [self rendering_properties_initialize];
  [self termination_functions_initialize];
  
  metil_text_characters_initialize(
    self->metal_kit_device
  );

  metil_scene_controller_after_scene_change_add(
    metil_renderer_after_scene_change,
    self
  );

  if (metil_renderer_on_initialize != (void*)0) {
    metil_renderer_on_initialize(
      self->metal_kit_device,
      &self->rendering_properties,
      metil_renderer_on_initialize_data
    );
  }

  [self command_queue_initialize];
  [self data_buffer_frames_initialize];
  [self pipelines_initialize];
  [self stencils_depth_initialize];
  [self fps_display_objects_initialize];

  return self;
}

- (void) after_scene_change {
  
}

- (void) command_queue_initialize {
  self->command_queue = [self->metal_kit_device
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
    ] = [self->metal_kit_device
      newBufferWithLength: sizeof(struct metil_renderer_data_frame)
      options:MTLResourceStorageModeShared
    ];
  }
}

- (void) destroy {
  [self->metal_kit_device release];

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
  [self->encoder_render release];

  [self->pipeline_render release];

  if (
    self->pipeline_render_fps_display != (void*)0
  ) {
    [self->pipeline_render_fps_display release];
  }
  
  for (
    unsigned char index_pipeline_render = 0;
    index_pipeline_render < self->length_pipelines_render;
    ++index_pipeline_render
  ) {
    [self->pipelines_render[index_pipeline_render] release];
  }

  free(
    self->pipelines_render
  );

  [self->depth_state release];
  [self->depth_state_writes_disable release];

  for (
    unsigned char index_object_fps_display = 0;
    index_object_fps_display < metil_renderer_length_objects_fps_display;
    ++index_object_fps_display
  ) {
    [self->objects_fps_display[index_object_fps_display].data release];
  }

  metil_rendering_properties_destory(
    &self->rendering_properties
  );
}

- (void) drawInMTKView: (nonnull MTKView*) metal_kit_view {
  const unsigned int _frame = (
    self->rendering_properties.frame++
  );

  if (_frame == 0) {
    metil_audio_data.muted = 0;
  }

  if (
    self->rendering_properties.frame + 1 >= UINT_MAX - 1
  ) {
    self->rendering_properties.frame = 1;
  }

  self->rendering_properties.count_completed_frames = (
    self->rendering_properties.count_completed_frames - 1
  );

  if (
    self->rendering_properties.count_completed_frames <= 0
  ) {
    pthread_mutex_lock(
      &self->rendering_properties.mutex_frame
    );
  }

  self->index_data_buffer_frame = (
    (self->index_data_buffer_frame + 1) % metil_count_max_frames
  );

  id<MTLCommandBuffer> command_buffer = [self->command_queue commandBuffer];

  MTLRenderPassDescriptor* descriptor_render_pass = metal_kit_view.currentRenderPassDescriptor;
  descriptor_render_pass.colorAttachments[0].clearColor = MTLClearColorMake(
    self->rendering_properties.color_clear.x,
    self->rendering_properties.color_clear.y,
    self->rendering_properties.color_clear.z,
    self->rendering_properties.color_clear.w
  );

  encoder_render = [command_buffer renderCommandEncoderWithDescriptor: descriptor_render_pass];
  self->encoder_render_encoding = 1;

  [encoder_render setRenderPipelineState: self->pipeline_render];
  [encoder_render setDepthStencilState: self->depth_state];

  [self poll: _frame];
  [self render];

  if (
    self->rendering_properties.fps_display == 1 &&
    pipeline_render_fps_display != (void*)0 &&
    self->rendering_properties.frame > 10
  ) {
    [encoder_render setRenderPipelineState: pipeline_render_fps_display];
    [encoder_render setDepthStencilState: self->depth_state_writes_disable];

    [self render_fps_display];
  }

  [encoder_render endEncoding];
  self->encoder_render_encoding = 0;

  [command_buffer addCompletedHandler:^(id<MTLCommandBuffer> buffer) {
    self->rendering_properties.count_completed_frames = (
      self->rendering_properties.count_completed_frames + 1
    );

    for (
      unsigned char index_time_frame = 0;
      index_time_frame < metil_count_time_frames - 1;
      ++index_time_frame
    ) {
      self->rendering_properties.time_frames[
        index_time_frame
      ] = self->rendering_properties.time_frames[
        index_time_frame + 1
      ];
    }

    self->rendering_properties.time_frames[
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
          self->rendering_properties.time_frames[
          index_time_frame + 1
        ] - self->rendering_properties.time_frames[
          index_time_frame
        ]) / (float) (metil_count_time_frames - 1)
      );
    }

    self->rendering_properties.fps = (
      1000.0f /
      time_difference_average
    );

    if (
      self->rendering_properties.count_completed_frames == 0 ||
      self->rendering_properties.count_completed_frames == 1
    ) {
      pthread_mutex_unlock(
        &self->rendering_properties.mutex_frame
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
  metil_camera_ratio_aspect_set(
    &self->rendering_properties.camera, (
      (float) size.width /
      (float) size.height
    )
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

    self->objects_fps_display[
      index_object_fps_display
    ].position.y = 0.0f;

    self->objects_fps_display[
      index_object_fps_display
    ].position.z = 0.0f;

    self->objects_fps_display[
      index_object_fps_display
    ].data = [self->metal_kit_device
      newBufferWithLength: sizeof(struct metil_renderer_data_object)
      options: MTLResourceStorageModeShared
    ];

    struct metil_renderer_data_object* data_object = self->objects_fps_display[
      index_object_fps_display
    ].data.contents;

    data_object->id = index_object_fps_display;
  }
}

- (void) initialize_null {
  self->metal_kit_device = (void*)0;

  self->command_queue = (void*)0;
  self->depth_state = (void*)0;
  self->depth_state_writes_disable = (void*)0;
  self->descriptor_pipeline_render = (void*)0;
  self->encoder_render = (void*)0;
  self->encoder_render_encoding = 0;
  self->index_buffer_mesh_current = (void*)0;
  self->pipeline_render = (void*)0;
  self->pipeline_render_fps_display = (void*)0;

  for (
    unsigned char index_data_buffer_frame_initializer = 0;
    index_data_buffer_frame_initializer < metil_count_max_frames;
    ++index_data_buffer_frame_initializer
  ) {
    self->data_buffer_frame[
      index_data_buffer_frame_initializer
    ] = (void*)0;
  }

  self->length_pipelines_render = 0;
  self->pipelines_render = malloc(
    sizeof(id<MTLRenderPipelineState>) *
    self->length_pipelines_render
  );
}

- (void) mtkView: (nonnull MTKView*) metal_kit_view drawableSizeWillChange: (CGSize) size {}

- (void) pipeline_add {

}

- (void) pipelines_clear {
  for (
    unsigned short int index_pipeline_render = 0;
    index_pipeline_render < self->length_pipelines_render;
    ++index_pipeline_render
  ) {
    [self->pipelines_render[index_pipeline_render] release];
  }

  self->length_pipelines_render = 0;
  self->pipelines_render = realloc(
    self->pipelines_render,
    sizeof(id<MTLRenderPipelineState>) *
    self->length_pipelines_render
  );
}

- (void) pipelines_initialize {
  if (
    self->descriptor_pipeline_render == (void*)0
  ) {
    self->descriptor_pipeline_render = [[MTLRenderPipelineDescriptor alloc] init];
    metil_rendering_descriptors_pipeline_render_initialize(
      self->descriptor_pipeline_render,
      1,
      metil_library.function_fragment,
      metil_library.function_vertex,
      MTLPixelFormatBGRA8Unorm_sRGB,
      MTLPixelFormatDepth32Float_Stencil8,
      MTLPixelFormatDepth32Float_Stencil8
    );
  }

  if (
    self->pipeline_render == (void*) 0
  ) {
    self->pipeline_render = [self->metal_kit_device
      newRenderPipelineStateWithDescriptor: self->descriptor_pipeline_render
      error: (void*)0
    ];
  }

  [self pipeline_render_fps_display_initiliaze];
}

- (void) pipeline_render_fps_display_initiliaze {
  if (
    self->pipeline_render_fps_display == (void*)0 &&
    metil_library.function_vertex_fps_display != (void*)0 &&
    metil_library.function_fragment_fps_display != (void*)0
  ) {
    self->descriptor_pipeline_render.vertexFunction = (
      metil_library.function_vertex_fps_display
    );

    self->descriptor_pipeline_render.fragmentFunction = (
      metil_library.function_fragment_fps_display
    );

    self->pipeline_render_fps_display = [self->metal_kit_device
      newRenderPipelineStateWithDescriptor: self->descriptor_pipeline_render
      error: (void*)0
    ];
  }
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
    self->rendering_properties.brightness
  );

  data_frame->brightness_text = (
    metil_scene_controller.scene.rendering_properties.brightness_text *
    self->rendering_properties.brightness_text
  );

  matrix_float4x4 matrix_player_projection = matrix_multiply(
    self->rendering_properties.camera.matrix_viewport_projection,
    (
      (matrix_float4x4) {{
        { 1, 0, 0, 0 },
        { 0, cos(metil_scene_controller.scene.player.rotation.x), -sin(metil_scene_controller.scene.player.rotation.x), 0 },
        { 0, sin(metil_scene_controller.scene.player.rotation.x), cos(metil_scene_controller.scene.player.rotation.x), 0 },
        {
          0,
          0,
          0,
          1
        }
      }}
    )
  );

  matrix_float4x4 matrix_object_projection = matrix_multiply(
    matrix_player_projection,
    (
      (matrix_float4x4) {{
        { cos(metil_scene_controller.scene.player.rotation.y), 0, -sin(metil_scene_controller.scene.player.rotation.y), 0 },
        { 0, 1, 0, 0 },
        { sin(metil_scene_controller.scene.player.rotation.y), 0, cos(metil_scene_controller.scene.player.rotation.y), 0 },
        {
          0,
          0,
          0,
          1
        }
      }}
    )
  );

  for (
    unsigned int index_object = 0;
    index_object < metil_scene_controller.scene.length_objects;
    ++index_object
  ) {
    [self
      poll_object: metil_scene_controller.scene.objects[
        index_object
      ]
      matrix_object_projection: &matrix_object_projection
      matrix_player_projection: &matrix_player_projection
    ];
  }

  [self
    poll_fps_display: &matrix_object_projection
    matrix_player_projection: &matrix_player_projection
  ];
}

- (void) poll_fps_display:
  (matrix_float4x4*) matrix_object_projection
  matrix_player_projection: (matrix_float4x4*) matrix_player_projection
{
  if (
    self->rendering_properties.frame == 0 ||
    self->rendering_properties.frame % 10 != 0
  ) {
    return;
  }

  char* char_array_fps = clic3_char_array_from_float(
    self->rendering_properties.fps
  );

  float position_x = 0.0f;

  for (
    signed char index_object_fps_display = metil_renderer_length_objects_fps_display - 1;
    index_object_fps_display >= 0;
    --index_object_fps_display
  ) {
    if (
      char_array_fps[index_object_fps_display] == '\0' ||
      char_array_fps[index_object_fps_display] == '.' &&
      index_object_fps_display == metil_renderer_length_objects_fps_display - 1
    ) {
      break;
    }

    self->objects_fps_display[
      index_object_fps_display
    ].mesh = metil_text_characters_default.meshes[
      char_array_fps[index_object_fps_display]
    ];

    position_x = position_x + 0.015f;

    self->objects_fps_display[
      index_object_fps_display
    ].position.x = 1.0f - position_x;

    if (char_array_fps[index_object_fps_display] == '.') {
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
    ].vertices = metil_text_characters_default.vertices[
      char_array_fps[index_object_fps_display]
    ];

    self->objects_fps_display[
      index_object_fps_display
    ].texture = metil_text_characters_default.textures[
      char_array_fps[index_object_fps_display]
    ];

    [self 
      poll_object: &self->objects_fps_display[
        index_object_fps_display
      ]
      matrix_object_projection: matrix_object_projection
      matrix_player_projection: matrix_player_projection
    ];
  }

  free(char_array_fps);
}

- (void) poll_object:
  (struct metil_object*) object
  matrix_object_projection: (matrix_float4x4*) matrix_object_projection 
  matrix_player_projection: (matrix_float4x4*) matrix_player_projection
{
  struct metil_renderer_data_object* data = object->data.contents;

  data->position.x = object->position.x;
  data->position.y = object->position.y;
  data->position.z = object->position.z;

  if (
    object->mesh.positioning == metil_mesh_positioning_static
  ) {
    data->view_model_matrix_projection = (matrix_float4x4) {{
      { 1, 0, 0, 0 },
      { 0, 1, 0, 0 },
      { 0, 0, 1, 0 },
      {
        object->position.x,
        object->position.y,
        object->position.z,
        1
      }
    }};
  } else {
    struct clic3_vector3_float position = {
      .x = object->position.x - metil_scene_controller.scene.player.position.x,
      .y = (
        object->position.y -
        metil_scene_controller.scene.player.position.y -
        self->rendering_properties.camera.height
      ),
      .z = object->position.z - metil_scene_controller.scene.player.position.z
    };

    matrix_float4x4* matrix_projection = (void*)0;

    if (object->mesh.positioning == metil_mesh_positioning_player) {
      matrix_projection = matrix_player_projection;
    } else {
      matrix_projection = matrix_object_projection;
    }

    matrix_float4x4 matrix_projection_object_with_rotation = matrix_multiply(
      (matrix_float4x4) {{
        { 1, 0, 0, 0 },
        { 0, 1, 0, 0 },
        { 0, 0, 1, 0 },
        {
          position.x,
          position.y,
          -position.z,
          1
        }
      }},
      (matrix_float4x4) {{
        { 1, 0, 0, 0 },
        { 0, cos(object->rotation.x), -sin(object->rotation.x), 0 },
        { 0, sin(object->rotation.x), cos(object->rotation.x), 0 },
        {
          0,
          0,
          0,
          1
        }
      }}
    );

    matrix_projection_object_with_rotation = matrix_multiply(
      matrix_projection_object_with_rotation,
      (matrix_float4x4) {{
        { cos(object->rotation.y), 0, -sin(object->rotation.y), 0 },
        { 0, 1, 0, 0 },
        { sin(object->rotation.y), 0, cos(object->rotation.y), 0 },
        {
          0,
          0,
          0,
          1
        }
      }}
    );

    matrix_projection_object_with_rotation = matrix_multiply(
      matrix_projection_object_with_rotation,
      (matrix_float4x4) {{
        { cos(object->rotation.z), -sin(object->rotation.z), 0, 0 },
        { sin(object->rotation.z), cos(object->rotation.z), 0, 0 },
        { 0, 0, 1, 0 },
        {
          0,
          0,
          0,
          1
        }
      }}
    );

    data->view_model_matrix_projection = matrix_multiply(
      *matrix_projection,
      matrix_projection_object_with_rotation
    );
  }

  data->width = object->mesh.size.x;
  data->height = object->mesh.size.y;
  data->depth = object->mesh.size.z;
}

- (void) render {
  for (
    unsigned int index_object = 0;
    index_object < metil_scene_controller.scene.length_objects;
    ++index_object
  ) {
    [self render_object: metil_scene_controller.scene.objects[index_object]];
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

- (void) render_object: (struct metil_object*) object {
  [encoder_render
    setVertexBuffer: data_buffer_frame[
      self->index_data_buffer_frame
    ]
    offset: 0
    atIndex: metil_renderer_vertex_index_parameter_data_frame
  ];

  [encoder_render
    setFragmentTexture: object->texture
    atIndex: 0
  ];

  if (
    object->texture_secondary != (void*)0
  ) {
    [encoder_render
      setFragmentTexture: object->texture_secondary
      atIndex: 1
    ];
  }

  [encoder_render
    setVertexBuffer: object->vertices
    offset: 0
    atIndex: metil_renderer_vertex_index_parameter_positions
  ];
  
  [encoder_render
    setVertexBuffer: object->data
    offset: 0
    atIndex: metil_renderer_vertex_index_parameter_data_object
  ];
  
  [encoder_render
    drawIndexedPrimitives: MTLPrimitiveTypeTriangle
    indexCount: object->mesh.length_indices
    indexType: MTLIndexTypeUInt32
    indexBuffer: object->indices
    indexBufferOffset: 0
  ];
}

- (void) rendering_properties_initialize {
  metil_rendering_properties_initialize(
    &self->rendering_properties
  );

  self->rendering_properties.brightness = (
    metil_configuration.rendering_properties.brightness
  );

  self->rendering_properties.brightness_text = (
    metil_configuration.rendering_properties.brightness_text
  );
}

- (void) stencils_depth_initialize {
  MTLDepthStencilDescriptor* descriptor_stencil_depth = [[MTLDepthStencilDescriptor alloc] init];
  descriptor_stencil_depth.depthCompareFunction = MTLCompareFunctionLessEqual;
  descriptor_stencil_depth.depthWriteEnabled = 1;
  self->depth_state = [self->metal_kit_device
    newDepthStencilStateWithDescriptor: descriptor_stencil_depth
  ];

  descriptor_stencil_depth.depthWriteEnabled = 0;
  self->depth_state_writes_disable = [self->metal_kit_device
    newDepthStencilStateWithDescriptor: descriptor_stencil_depth
  ];
}

- (void) termination_functions_initialize {
  metil_termination_on_function_add(
    metil_renderer_on_termination,
    self
  );

  metil_termination_on_function_add(
    metil_text_characters_destroy,
    (void*)0
  );
}

@end

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
