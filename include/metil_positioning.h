#ifndef __metil_positioning_h
#define __metil_positioning_h

#include <metil_rendering/metil_camera/metil_camera.h>

#include <clic3_vector.h>

#include <simd/simd.h>

enum metil_positioning {
  metil_positioning_normal = 0,
  metil_positioning_player = 1,
  metil_positioning_static = 2,
  metil_positioning_absolute = 3,
};

void metil_positioning_view_model_matrix_projection_set(
  enum metil_positioning,
  matrix_float4x4* _Nonnull,
  matrix_float3x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  struct clic3_vector3_float* _Nonnull,
  struct clic3_vector3_float* _Nonnull,
  struct metil_camera* _Nonnull
);

void metil_positioning_view_model_matrix_projection_with_offsets_set(
  enum metil_positioning,
  matrix_float4x4* _Nonnull,
  matrix_float3x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  struct clic3_vector3_float* _Nonnull,
  struct clic3_vector3_float* _Nonnull,
  struct clic3_vector3_float* _Nullable,
  struct clic3_vector3_float* _Nullable,
  struct metil_camera* _Nonnull
);

#endif
