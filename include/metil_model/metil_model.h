#ifndef __metil_model_metil_model_h
#define __metil_model_metil_model_h

#include <metil_joint.h>
#include <metil_model/metil_model_segment.h>
#include <metil_mesh/mesh.h>
#include <metil_object.h>
#include <metil_positioning.h>
#include <metil_rendering/camera/camera.h>

#include <clic3_vector.h>

#include <Metal/MTLBuffer.h>
#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>
#include <Metal/MTLRenderCommandEncoder.h>

#include <simd/simd.h>

struct metil_model;

typedef void (*metil_model_poll_function)(
  struct metil_model* _Nonnull,
  matrix_float3x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  struct metil_camera* _Nonnull
);

typedef void (*metil_model_destroy_function)(
  struct metil_model* _Nonnull
);

struct metil_model {
  struct metil_object* _Nonnull objects;
  unsigned char length_objects;

  struct metil_joint* _Nonnull joints;
  unsigned char length_joints;
  
  _Nonnull id<MTLTexture>* _Nonnull textures;
  unsigned char length_textures;

  struct clic3_vector3_float position;
  struct clic3_vector3_float rotation;

  unsigned char visible;

  enum metil_positioning positioning;

  _Nonnull metil_model_destroy_function destroy;
  _Nonnull metil_model_poll_function poll;

  void* _Nullable data;
};

void metil_model_initialize(
  struct metil_model* _Nonnull
);

void metil_model_objects_add(
  struct metil_model* _Nonnull
);

void metil_model_objects_add_length(
  struct metil_model* _Nonnull,
  unsigned char
);

void metil_model_joints_add(
  struct metil_model* _Nonnull
);

void metil_model_buffers_initialize(
  struct metil_model* _Nonnull,
  _Nonnull id<MTLDevice>
);

void metil_model_texture_add(
  struct metil_model* _Nonnull,
  _Nullable id<MTLTexture>
);

void metil_model_poll(
  struct metil_model* _Nonnull,
  matrix_float3x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  struct metil_camera* _Nonnull
);

void metil_model_object_poll(
  struct metil_object* _Nonnull,
  matrix_float3x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  struct metil_camera* _Nonnull
);

void metil_model_destroy(
  struct metil_model* _Nonnull
);

void metil_model_destroy_with_textures(
  struct metil_model* _Nonnull
);

#endif
