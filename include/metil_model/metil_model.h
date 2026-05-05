#ifndef __metil_model_metil_model_h
#define __metil_model_metil_model_h

#include <metil_joint/metil_joint.h>
#include <metil_mesh/metil_mesh.h>
#include <metil_object/metil_object.h>
#include <metil_object/metil_object_buffer.h>
#include <metil_positioning.h>
#include <metil_rendering/metil_camera/metil_camera.h>

#include <math_c_vector.h>

#include <Metal/MTLBuffer.h>
#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

#include <simd/simd.h>

struct metil_model;

typedef void (*metil_model_poll_function)(
  struct metil* _Nonnull,
  struct metil_model* _Nonnull,
  matrix_float3x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  struct metil_camera* _Nonnull
);

typedef void (*metil_model_destroy_function)(
  struct metil* _Nonnull,
  struct metil_model* _Nonnull
);

struct metil_model {
  struct metil_object* _Nonnull objects;
  unsigned int* _Nullable * _Nonnull vertex_joint_maps;
  unsigned char length_objects;

  struct metil_joint* _Nonnull joints;
  unsigned char length_joints;

  _Nonnull id<MTLBuffer> buffer_joints;

  _Nonnull id<MTLTexture>* _Nonnull textures;
  unsigned char length_textures;

  struct math_c_vector3_float position;
  struct math_c_vector3_float rotation;

  unsigned char visible;

  enum metil_positioning positioning;

  _Nonnull metil_model_destroy_function destroy;
  _Nonnull metil_model_poll_function poll;

  void* _Nullable data;
};

void metil_model_initialize(
  struct metil_model* _Nonnull
);

void metil_model_object_add(
  struct metil_model* _Nonnull
);

void metil_model_objects_add_length(
  struct metil_model* _Nonnull,
  unsigned char
);

void metil_model_joints_add(
  struct metil_model* _Nonnull
);

void metil_model_joints_add_length(
  struct metil_model* _Nonnull,
  unsigned char
);

void metil_model_vertex_joint_maps_initialize(
  struct metil_model* _Nonnull
);

void metil_model_vertex_joint_attach(
  struct metil_model* _Nonnull,
  unsigned char,
  unsigned int,
  unsigned char
);

void metil_model_buffers_initialize(
  struct metil* _Nonnull,
  struct metil_model* _Nonnull,
  _Nonnull id<MTLDevice>
);

void metil_model_buffer_add(
  struct metil_model* _Nonnull,
  _Nonnull id<MTLDevice>,
  _Nullable id<MTLBuffer>,
  enum metil_object_buffer_type
);

void metil_model_texture_add(
  struct metil_model* _Nonnull,
  _Nullable id<MTLTexture>
);

void metil_model_poll(
  struct metil* _Nonnull,
  struct metil_model* _Nonnull,
  matrix_float3x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  struct metil_camera* _Nonnull
);

void metil_model_buffer_joints_poll(
  struct metil* _Nonnull,
  struct metil_model* _Nonnull
);

void metil_model_object_poll(
  struct metil* _Nonnull,
  struct metil_object* _Nonnull,
  matrix_float3x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  struct metil_camera* _Nonnull
);

void metil_model_destroy(
  struct metil* _Nonnull,
  struct metil_model* _Nonnull
);

void metil_model_destroy_nullify_buffers(
  struct metil* _Nonnull,
  struct metil_model* _Nonnull
);

void metil_model_destroy_with_textures(
  struct metil* _Nonnull,
  struct metil_model* _Nonnull
);

void metil_model_destroy_nullify_buffers_with_textures(
  struct metil* _Nonnull,
  struct metil_model* _Nonnull
);

#endif
