#ifndef __metil_object_h
#define __metil_object_h

#include <metil_mesh/mesh.h>

#include <clic3_vector.h>

#include <MetalKit/MetalKit.h>

struct metil_object {
  struct metil_mesh mesh;

  _Nonnull id<MTLBuffer> data;
  _Nonnull id<MTLBuffer> indices;
  _Nonnull id<MTLBuffer> vertices;

  _Nonnull id<MTLTexture> texture;
  _Nullable id<MTLTexture> texture_secondary;

  struct clic3_vector3_float position;
  struct clic3_vector3_float rotation;

  unsigned char index_pipeline_render;

  unsigned char depth_disabled;
};

void metil_object_initialize(
  struct metil_object* _Nonnull
);

void metil_object_buffers_initialize(
  struct metil_object* _Nonnull,
  _Nonnull id<MTLDevice>
);

void metil_object_destroy(
  struct metil_object* _Nonnull
);

#endif
