#include <metil_rendering/metil_renderer.h>

#include <metil_audio/audio.h>
#include <metil_configuration/configuration.h>
#include <metil_input/controller.h>
#include <metil_input/map.h>
#include <metil_input/keycodes.h>
#include <metil_library.h>
#include <metil_mesh/mesh.h>
#include <metil_object.h>
#include <metil_rendering/camera/camera.h>
#include <metil_scenes/scene.h>
#include <metil_scenes/scene_controller.h>
#include <metil_shader_types.h>
#include <metil_termination.h>
#include <metil_utilities/time.h>

#include <clic3.h>

#include <limits.h>

#include <MetalKit/MetalKit.h>

metil_renderer_on_initialize_function metil_renderer_on_initialize = (void*)0;

@implementation metil_renderer

- (nonnull instancetype) initWithMetalKitView: (nonnull MTKView*) metal_kit_view {
  self = [super init];

  if (!self) {
    return self;
  }

  metal_kit_device = metal_kit_view.device;

  metil_rendering_properties_initialize(
    &self->rendering_properties
  );

  self->rendering_properties.brightness = (
    metil_configuration.rendering_properties.brightness
  );
  self->rendering_properties.brightness_text = (
    metil_configuration.rendering_properties.brightness_text
  );

  metal_kit_view.depthStencilPixelFormat = MTLPixelFormatDepth32Float_Stencil8;
  metal_kit_view.colorPixelFormat = MTLPixelFormatBGRA8Unorm_sRGB;
  metal_kit_view.sampleCount = 1;

  metil_termination_on_function_add(
    metil_renderer_on_termination,
    self
  );

  if (metil_renderer_on_initialize != (void*)0) {
    metil_renderer_on_initialize(
      metal_kit_device,
      &self->rendering_properties
    );
  }

  MTLRenderPipelineDescriptor* descriptor_state_pipeline = [[MTLRenderPipelineDescriptor alloc] init];
  descriptor_state_pipeline.rasterSampleCount = metal_kit_view.sampleCount;
  descriptor_state_pipeline.vertexFunction = metil_library.function_vertex;
  descriptor_state_pipeline.fragmentFunction = metil_library.function_fragment;
  descriptor_state_pipeline.colorAttachments[0].pixelFormat = metal_kit_view.colorPixelFormat;
  descriptor_state_pipeline.colorAttachments[0].blendingEnabled = 1;
  descriptor_state_pipeline.colorAttachments[0].rgbBlendOperation = MTLBlendOperationAdd;
  descriptor_state_pipeline.colorAttachments[0].alphaBlendOperation = MTLBlendOperationAdd;
  descriptor_state_pipeline.colorAttachments[0].sourceRGBBlendFactor = MTLBlendFactorSourceAlpha;
  descriptor_state_pipeline.colorAttachments[0].sourceAlphaBlendFactor = MTLBlendFactorSourceAlpha;
  descriptor_state_pipeline.colorAttachments[0].destinationRGBBlendFactor = MTLBlendFactorOneMinusSourceAlpha;
  descriptor_state_pipeline.colorAttachments[0].destinationAlphaBlendFactor = MTLBlendFactorOneMinusSourceAlpha;

  descriptor_state_pipeline.depthAttachmentPixelFormat = metal_kit_view.depthStencilPixelFormat;
  descriptor_state_pipeline.stencilAttachmentPixelFormat = metal_kit_view.depthStencilPixelFormat;

  state_pipeline = [metal_kit_device
    newRenderPipelineStateWithDescriptor: descriptor_state_pipeline
    error: (void*)0
  ];
  descriptor_state_pipeline.fragmentFunction = (void*)0;

  state_pipeline_no_render = [metal_kit_device
    newRenderPipelineStateWithDescriptor: descriptor_state_pipeline
    error: (void*)0
  ];

  MTLDepthStencilDescriptor* descriptor_state_depth = [[MTLDepthStencilDescriptor alloc] init];
  descriptor_state_depth.depthCompareFunction = MTLCompareFunctionLessEqual;
  descriptor_state_depth.depthWriteEnabled = 1;
  depth_state = [metal_kit_device newDepthStencilStateWithDescriptor:descriptor_state_depth];

  descriptor_state_depth.depthWriteEnabled = 0;
  depth_state_writes_disable = [metal_kit_device newDepthStencilStateWithDescriptor: descriptor_state_depth];

  for (
    unsigned int index_buffer = 0;
    index_buffer < metil_count_max_frames;
    ++index_buffer
  ) {
    data_buffer_frame[
      index_buffer
    ] = [metal_kit_device
      newBufferWithLength: sizeof(metil_kit_data_frame)
      options:MTLResourceStorageModeShared
    ];
  }

  command_queue = [metal_kit_device newCommandQueue];

  return self;
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

  index_data_buffer_frame = (index_data_buffer_frame + 1) % metil_count_max_frames;

  id<MTLCommandBuffer> command_buffer = [command_queue commandBuffer];

  MTLRenderPassDescriptor* descriptor_render_pass = metal_kit_view.currentRenderPassDescriptor;
  descriptor_render_pass.colorAttachments[0].clearColor = MTLClearColorMake(
    self->rendering_properties.color_clear.x,
    self->rendering_properties.color_clear.y,
    self->rendering_properties.color_clear.z,
    self->rendering_properties.color_clear.w
  );

  encoder_render = [command_buffer renderCommandEncoderWithDescriptor: descriptor_render_pass];

  [encoder_render setRenderPipelineState: state_pipeline];
  [encoder_render setDepthStencilState: depth_state];

  [self poll: _frame];
  [self render];

  [encoder_render endEncoding];

  [command_buffer addCompletedHandler:^(id<MTLCommandBuffer> buffer) {
    self->rendering_properties.count_completed_frames = (
      self->rendering_properties.count_completed_frames + 1
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

- (void) poll_object: (struct metil_object*) object {
  metil_kit_data_frame_object* data = object->data.contents;

  data->position.x = object->position.x;
  data->position.y = object->position.y;
  data->position.z = object->position.z;

  if (
    object->mesh.positioning == metil_mesh_positioning_normal ||
    object->mesh.positioning == metil_mesh_positioning_player
  ) {
    struct clic3_vector3_float position = {
      .x = object->position.x - metil_scene_controller.scene.player.position.x,
      .y = object->position.y - metil_scene_controller.scene.player.position.y,
      .z = object->position.z - metil_scene_controller.scene.player.position.z
    };

    data->view_model_matrix_projection = matrix_multiply(
      self->rendering_properties.camera.matrix_viewport_projection,
      (
        (matrix_float4x4) {{
          { 1, 0, 0, 0 },
          { 0, cos(metil_scene_controller.scene.player.rotation.x), sin(metil_scene_controller.scene.player.rotation.x), 0 },
          { 0, -sin(metil_scene_controller.scene.player.rotation.x), cos(metil_scene_controller.scene.player.rotation.x), 0 },
          {
            1,
            1,
            1,
            1
          }
        }}
      )
    );

    if (object->mesh.positioning != metil_mesh_positioning_player) {
      data->view_model_matrix_projection = matrix_multiply(
        data->view_model_matrix_projection,
        (
          (matrix_float4x4) {{
            { cos(metil_scene_controller.scene.player.rotation.y), 0, -sin(metil_scene_controller.scene.player.rotation.y), 0 },
            { 0, 1, 0, 0 },
            { sin(metil_scene_controller.scene.player.rotation.y), 0, cos(metil_scene_controller.scene.player.rotation.y), 0 },
            {
              1,
              1,
              1,
              1
            }
          }}
        )
      );
    }

    data->view_model_matrix_projection = matrix_multiply(
      data->view_model_matrix_projection,
      (matrix_float4x4) {{
        { 1, 0, 0, 0 },
        { 0, 1, 0, 0 },
        { 0, 0, 1, 0 },
        {
          position.x,
          position.y,
          position.z,
          1
        }
      }}
    );
  } else {
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
  }

  data->width = object->mesh.size.x;
  data->height = object->mesh.size.y;
  data->depth = object->mesh.size.z;
}

- (void) poll: (unsigned int) _frame {
  metil_controller_poll();

  unsigned long int time = metil_time_milliseconds_get();

  metil_scene_poll_input(
    &metil_scene_controller.scene,
    time
  );
  
  metil_scene_poll(
    &metil_scene_controller.scene,
    time
  );

  metil_kit_data_frame* data_frame = (
    data_buffer_frame[index_data_buffer_frame]
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

  for (
    unsigned short int index_object = 0;
    index_object < metil_scene_controller.scene.length_objects;
    ++index_object
  ) {
    [self poll_object: metil_scene_controller.scene.objects[index_object]];
  }
}

- (void) render_object: (struct metil_object*) object {
  [encoder_render
    setVertexBuffer: data_buffer_frame[index_data_buffer_frame]
    offset: 0
    atIndex: metil_kit_vertex_input_index_frame_data
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
    atIndex: metil_kit_vertex_input_index_positions
  ];
  
  [encoder_render
    setVertexBuffer: object->data
    offset: 0
    atIndex: metil_kit_vertex_input_index_data
  ];
  
  [encoder_render
    drawIndexedPrimitives: MTLPrimitiveTypeTriangle
    indexCount: object->mesh.length_indices
    indexType: MTLIndexTypeUInt32
    indexBuffer: object->indices
    indexBufferOffset: 0
  ];
}

- (void) render {
  for (
    unsigned short int index_object = 0;
    index_object < metil_scene_controller.scene.length_objects;
    ++index_object
  ) {
    [self render_object: metil_scene_controller.scene.objects[index_object]];
  }
}

- (void) mtkView: (nonnull MTKView*) metal_kit_view drawableSizeWillChange: (CGSize) size {}

- (void) drawableSizeWillChange: (CGSize) size {
  metil_camera_ratio_aspect_set(
    &self->rendering_properties.camera, (
      (float) size.width /
      (float) size.height
    )
  );
}

- (void) destroy {
  metil_rendering_properties_destory(
    &self->rendering_properties
  );
}

@end

void metil_renderer_on_termination(
  void* _Nonnull reference
) {
  metil_renderer* renderer = (metil_renderer*) reference;

  [renderer destroy];
}
