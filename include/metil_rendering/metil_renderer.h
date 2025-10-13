#ifndef __metil_renderer_h
#define __metil_renderer_h

#include <metil_object.h>
#include <metil_rendering/rendering_properties.h>

#include <MetalKit/MetalKit.h>

#define metil_renderer_length_objects_fps_display 5

typedef void (*metil_renderer_on_initialize_function)(
  _Nonnull id<MTLDevice>,
  struct metil_rendering_properties* _Nonnull,
  void* _Nullable
);

extern _Nullable metil_renderer_on_initialize_function metil_renderer_on_initialize;
extern void* _Nullable metil_renderer_on_initialize_data;

@interface metil_renderer : NSObject<MTKViewDelegate> {
  struct metil_rendering_properties rendering_properties;

  id<MTLDevice> metal_kit_device;
  
  id<MTLBuffer> data_buffer_frame[metil_count_max_frames];
  id<MTLBuffer> index_buffer_mesh_current;

  id<MTLCommandQueue> command_queue;

  MTLRenderPipelineDescriptor* descriptor_pipeline_render;

  id<MTLRenderCommandEncoder> encoder_render;

  id<MTLRenderPipelineState> pipeline_render;
  id<MTLRenderPipelineState> pipeline_render_fps_display;
  
  id<MTLRenderPipelineState>* pipelines_render;
  unsigned short int length_pipelines_render;

  id<MTLDepthStencilState> depth_state;
  id<MTLDepthStencilState> depth_state_writes_disable;

  unsigned char index_data_buffer_frame;

  struct metil_object objects_fps_display[
    metil_renderer_length_objects_fps_display
  ];
}

- (nonnull instancetype) initWithMetalKitView: (nonnull MTKView*) metal_kit_view;

- (void) after_scene_change;

- (void) command_queue_initialize;
- (void) data_buffer_frames_initialize;
- (void) fps_display_objects_initialize;
- (void) initialize_null;
- (void) initialize_rendering_properties;
- (void) initialize_termination_functions;

- (void) pipeline_add;
- (void) pipelines_clear;
- (void) pipelines_initialize;
- (void) pipeline_render_fps_display_initiliaze;
- (void) stencils_depth_initialize;

- (void) drawInMTKView: (nonnull MTKView*) metal_kit_view;
- (void) drawableSizeWillChange: (CGSize) size;

- (void) mtkView: (nonnull MTKView*) metal_kit_view drawableSizeWillChange: (CGSize) size;

- (void) poll: (unsigned int) _frame;
- (void) poll_fps_display: (nonnull matrix_float4x4*) matrix_object_projection 
  matrix_player_projection: (nonnull matrix_float4x4*) matrix_player_projection;
- (void) poll_object: (nonnull struct metil_object*) object
  matrix_object_projection: (nonnull matrix_float4x4*) matrix_object_projection
  matrix_player_projection: (nonnull matrix_float4x4*) matrix_player_projection;

- (void) render;
- (void) render_fps_display;
- (void) render_object: (nonnull struct metil_object*) object;

- (void) destroy;

@end

void metil_renderer_after_scene_change(int, void* _Nonnull);
void metil_renderer_on_termination(void* _Nonnull);

#endif
