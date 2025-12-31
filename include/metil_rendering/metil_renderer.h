#ifndef __metil_rendering_metil_renderer_h
#define __metil_rendering_metil_renderer_h

#include <metil.h>
#include <metil_object/metil_object.h>
#include <metil_object/metil_object_buffer.h>
#include <metil_rendering/metil_renderer_interface.h>
#include <metil_rendering/metil_renderer_thread_poll_object_data.h>
#include <metil_rendering/metil_rendering_properties.h>
#include <metil_termination/metil_termination.h>

#include <Metal/MTLBuffer.h>
#include <Metal/MTLCommandQueue.h>
#include <Metal/MTLDepthStencil.h>
#include <Metal/MTLDevice.h>
#include <Metal/MTLLibrary.h>
#include <Metal/MTLRenderCommandEncoder.h>
#include <Metal/MTLRenderPipeline.h>
#include <MetalKit/MTKView.h>

#include <simd/simd.h>
#include <pthread.h>

#define metil_renderer_length_objects_fps_display 5

typedef void (*metil_renderer_on_initialize_function)(
  struct metil* _Nonnull,
  void* _Nullable
);

extern _Nullable metil_renderer_on_initialize_function metil_renderer_on_initialize;
extern void* _Nullable metil_renderer_on_initialize_data;

#define metil_renderer_pipelines_render_index_library 0
#define metil_renderer_pipelines_render_index_fps_display 1
#define metil_renderer_pipelines_render_index_wireframe 2

@interface metil_renderer : NSObject<MTKViewDelegate> {
  struct metil* metil;

  id<MTLCommandQueue> command_queue;

  id<MTLBuffer> data_buffer_frame[metil_count_max_frames];
  unsigned char index_data_buffer_frame;

  id<MTLDepthStencilState> depth_state;
  id<MTLDepthStencilState> depth_state_writes_disabled;
  unsigned char depth_state_disabled;

  MTLRenderPipelineDescriptor* descriptor_pipeline_render;

  id<MTLRenderCommandEncoder> encoder_render;
  unsigned char encoder_render_encoding;

  id<MTLBuffer> index_buffer_mesh_current;

  id<MTLDevice> metal_device;

  struct metil_object objects_fps_display[
    metil_renderer_length_objects_fps_display
  ];

  id<MTLRenderPipelineState>* pipelines_render;
  unsigned short int length_pipelines_render;
  unsigned short int index_pipelines_render_current;

  pthread_t* threads;
  struct metil_renderer_thread_poll_object_data* threads_data;
  unsigned int length_threads;

  matrix_float3x4 matrix_projection_static;
}

- (nonnull instancetype) metil_renderer_initialize:
  (nonnull MTKView*) metal_kit_view
  metil: (nonnull struct metil*) parameter_metil;

- (void) after_scene_change;

- (void) command_queue_initialize;

- (void) data_buffer_frames_initialize;

- (void) descriptor_pipeline_render_initialize;

- (void) destroy;

- (void) drawInMTKView: (nonnull MTKView*) metal_kit_view;
- (void) drawableSizeWillChange: (CGSize) size;

- (void) fps_display_objects_initialize;

- (void) initialize_null;

- (unsigned short int) pipeline_add: (nonnull id<MTLFunction>) function_fragment
  function_vertex: (nonnull id<MTLFunction>) function_vertex;
- (void) pipelines_clear;
- (void) pipelines_initialize;
- (void) pipeline_render_initialize:
  (unsigned short int) index_pipeline_render
  function_fragment: (nonnull id<MTLFunction>) function_fragment
  function_vertex: (nonnull id<MTLFunction>) function_vertex;
- (void) pipeline_render_fps_display_initiliaze;
- (void) pipeline_render_library_initiliaze;
- (void) pipeline_render_wireframe_initialize;

- (void) mtkView: (nonnull MTKView*) metal_kit_view drawableSizeWillChange: (CGSize) size;

- (void) poll: (unsigned int) _frame;
- (void) poll_fps_display: (nonnull matrix_float4x4*) matrix_object_projection
  matrix_player_projection: (nonnull matrix_float4x4*) matrix_player_projection;

- (void) render;
- (void) render_renderable: (nonnull struct metil_renderable*) metil_renderable;
- (void) render_fps_display;
- (void) render_object: (nonnull struct metil_object*) object;
- (void) render_object_wireframe: (nonnull struct metil_object*) object;
- (void) render_encode_draw:
  (nonnull struct metil_object_buffer*) buffers_vertex
  length_buffers_vertex: (unsigned int) length_buffers_vertex
  buffers_fragment: (nonnull struct metil_object_buffer*) buffers_fragment
  length_buffers_fragment: (unsigned int) length_buffers_fragment
  indices: (nonnull id<MTLBuffer>) indices
  length_indices: (unsigned int) length_indices
  textures: (_Nonnull id<MTLTexture>* _Nullable) textures
  length_textures: (unsigned char) length_textures
  index_pipeline_render: (unsigned short int) index_pipeline_render
  depth_disabled: (unsigned char) depth_disabled
  type_primitive: (MTLPrimitiveType) type_primitive
  type_index: (MTLIndexType) type_index;

- (void) stencils_depth_initialize;

- (void) termination_functions_initialize;

@end

void metil_renderer_poll_object(
  struct metil_renderer_thread_poll_object_data* _Nonnull,
  struct metil_renderable* _Nonnull
);

void* _Nullable metil_renderer_thread_poll_object(
  void* _Nonnull
);

void metil_renderer_after_scene_change(
  struct metil* _Nonnull,
  int,
  void* _Nonnull
);

void metil_renderer_on_termination(
  void* _Nonnull
);

#endif
