#ifndef __metil_model_metil_model_segment_h
#define __metil_model_metil_model_segment_h

#include <metil_mesh/mesh.h>
#include <metil_object/metil_object_buffer.h>

#include <Metal/MTLArgument.h>
#include <Metal/MTLRenderCommandEncoder.h>

#include <simd/simd.h>

struct metil_model_segment {
  struct metil_mesh mesh;

  struct metil_object_buffer* _Nonnull buffers_fragment;
  struct metil_object_buffer* _Nonnull buffers_vertex;

  unsigned char length_buffers_vertex;
  unsigned char length_buffers_fragment;

  _Nonnull id<MTLBuffer> indices;

  MTLPrimitiveType type_primitive;
  MTLIndexType type_index;

  _Nonnull id<MTLTexture>* _Nonnull textures;
  unsigned char length_textures;

  unsigned char depth_disabled;
  unsigned char index_pipeline_render;
  unsigned char visible;
};

void metil_model_segment_initialize(
  struct metil_model_segment* _Nonnull
);

#endif
