#ifndef __metil_renderer_h
#define __metil_renderer_h

#include <metil_object.h>
#include <metil_rendering/rendering_properties.h>
#include <metil_scenes/scene.h>

#include <MetalKit/MetalKit.h>

@interface metil_renderer : NSObject<MTKViewDelegate> {
  struct metil_rendering_properties rendering_properties;

  struct metil_scene scene;

  id<MTLDevice> metal_kit_device;
  
  id<MTLBuffer> data_buffer_frame[metil_count_max_frames];
  id<MTLBuffer> index_buffer_mesh_current;

  id<MTLCommandQueue> command_queue;

  id<MTLRenderCommandEncoder> encoder_render;

  id<MTLRenderPipelineState> state_pipeline;
  id<MTLRenderPipelineState> state_pipeline_no_render;

  id<MTLDepthStencilState> depth_state;
  id<MTLDepthStencilState> depth_state_writes_disable;

  unsigned char index_data_buffer_frame;
}

- (nonnull instancetype) initWithMetalKitView: (nonnull MTKView*) metal_kit_view;

- (void) on_scene_change: (enum metil_scene_id) scene_id;

- (void) drawInMTKView: (nonnull MTKView*) metal_kit_view;

- (void) mtkView: (nonnull MTKView*) metal_kit_view drawableSizeWillChange: (CGSize) size;
- (void) drawableSizeWillChange: (CGSize) size;

- (void) poll: (unsigned int) _frame;
- (void) poll_object: (nonnull struct metil_object*) object;

- (void) render;
- (void) render_object: (nonnull struct metil_object*) object;

- (void) destroy;

@end

void metil_renderer_on_scene_change(
  enum metil_scene_id,
  void* _Nonnull
);
void metil_renderer_on_termination(void* _Nonnull);

#endif
