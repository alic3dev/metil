#ifndef __metil_object_metil_object_h
#define __metil_object_metil_object_h

#include <metil_mesh/mesh.h>
#include <metil_positioning.h>

#include <clic3_vector.h>

#include <Metal/MTLArgument.h>
#include <Metal/MTLDevice.h>
#include <Metal/MTLRenderCommandEncoder.h>

#include <simd/simd.h>

struct metil_object;

typedef void (*metil_object_poll)(
  struct metil_object* _Nonnull,
  matrix_float3x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  float* _Nonnull
);

struct metil_object {
  struct metil_mesh mesh;

  _Nonnull id<MTLBuffer> data;
  _Nonnull id<MTLBuffer> indices;
  _Nonnull id<MTLBuffer> vertices;

  MTLPrimitiveType type_primitive;
  MTLIndexType type_index;

  _Nonnull id<MTLTexture>* _Nonnull textures;
  unsigned char length_textures;

  struct clic3_vector3_float position;
  struct clic3_vector3_float rotation;

  unsigned char depth_disabled;
  unsigned char index_pipeline_render;
  unsigned char visible;

  enum metil_positioning positioning;

  metil_object_poll _Nonnull poll;
};

void metil_object_initialize(
  struct metil_object* _Nonnull
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

void metil_object_texture_add(
  struct metil_object* _Nonnull,
  _Nullable id<MTLTexture>
);

void metil_object_destroy(
  struct metil_object* _Nonnull
);

#endif
