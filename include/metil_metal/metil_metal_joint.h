#ifndef __metil_metal_metil_metal_joint_h
#define __metil_metal_metil_metal_joint_h

#include <math_c_vector.h>

#include <simd/simd.h>

unsigned int metil_metal_joint_id_get(
  unsigned int,
  constant unsigned int*
);

void metil_metal_joint_values_set(
  unsigned int,
  constant struct math_c_vector3_float*,
  thread float4*,
  thread math_c_vector3_float*,
  thread float4*
);

void metil_metal_joint_matrix_projection_rotation_set(
  thread matrix_float4x4*,
  thread struct math_c_vector3_float*
);

#endif
