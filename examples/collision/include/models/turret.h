#ifndef __models_turret_h
#define __models_turret_h

#include <metil.h>
#include <metil_model/metil_model.h>
#include <metil_rendering/metil_camera/metil_camera.h>

#include <simd/simd.h>

enum model_turret_index_object {
  model_turret_index_object_leg_one = 0,
  model_turret_index_object_leg_two = 1,
  model_turret_index_object_leg_three = 2,
  model_turret_index_object_leg_four = 3,
  model_turret_index_object_box = 4,
  model_turret_index_object_barrel = 5,
  model_turret_index_object_sight = 6
};

void model_turret_initialize(
  struct metil* _Nonnull,
  struct metil_model* _Nonnull
);

void model_turret_poll(
  struct metil* _Nonnull,
  struct metil_model* _Nonnull,
  matrix_float3x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  matrix_float4x4* _Nonnull,
  struct metil_camera* _Nonnull
);

#endif
