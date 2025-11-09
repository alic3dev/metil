#ifndef __metil_object_h
#define __metil_object_h

#include <metil_mesh/mesh.h>

#include <clic3_vector.h>

#include <Metal/MTLArgument.h>
#include <Metal/MTLDevice.h>
#include <Metal/MTLRenderCommandEncoder.h>

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
};

void metil_object_initialize(
  struct metil_object* _Nonnull
);

void metil_object_buffers_initialize_with_data_size(
  struct metil_object* _Nonnull,
  _Nonnull id<MTLDevice>,
  unsigned int
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
