#ifndef __metil_object_metil_object_h
#define __metil_object_metil_object_h

#include <metil.h>
#include <metil_mesh/metil_mesh.h>
#include <metil_object/metil_object_buffer.h>
#include <metil_positioning.h>
#include <metil_rendering/metil_camera/metil_camera.h>

#include <math_c_vector.h>

#include <Metal/MTLArgument.h>
#include <Metal/MTLDevice.h>
#include <Metal/MTLRenderCommandEncoder.h>

#include <simd/simd.h>

struct metil_object;

typedef void (*metil_object_poll_function)(
  struct metil* _Nonnull,
  struct metil_object* _Nonnull,
  matrix_float3x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  struct metil_camera* _Nonnull
);

typedef void (*metil_object_destroy_function)(
  struct metil* _Nonnull,
  struct metil_object* _Nonnull
);

struct metil_object {
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

  struct math_c_vector3_float position;
  struct math_c_vector3_float rotation;

  unsigned char depth_disabled;
  unsigned char index_pipeline_render;
  unsigned char visible;

  enum metil_positioning positioning;

  metil_object_poll_function _Nonnull poll;
  metil_object_destroy_function _Nonnull destroy;

  void* _Nullable data;
};

void metil_object_initialize(
  struct metil_object* _Nonnull
);

void metil_object_indices_initialize(
  struct metil_object* _Nonnull,
  _Nonnull id<MTLDevice>
);

void metil_object_buffers_initialize_with_data_size(
  struct metil_object* _Nonnull,
  _Nonnull id<MTLDevice>,
  unsigned long int
);

void metil_object_buffers_initialize(
  struct metil_object* _Nonnull,
  _Nonnull id<MTLDevice>
);

void metil_object_buffers_add(
  struct metil_object* _Nonnull,
  _Nonnull id<MTLDevice>,
  enum metil_object_buffer_type
);

void metil_object_texture_add(
  struct metil_object* _Nonnull,
  _Nullable id<MTLTexture>
);

void metil_object_poll(
  struct metil* _Nonnull,
  struct metil_object* _Nonnull,
  matrix_float3x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  struct metil_camera* _Nonnull
);

void metil_object_destroy(
  struct metil* _Nonnull,
  struct metil_object* _Nonnull
);

void metil_object_destroy_with_textures(
  struct metil* _Nonnull,
  struct metil_object* _Nonnull
);

#endif
