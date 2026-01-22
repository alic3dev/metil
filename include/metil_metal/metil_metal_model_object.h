#ifndef __metil_metal_metil_metal_model_object_h
#define __metil_metal_metil_metal_model_object_h

#include <math_c_vector.h>

#include <simd/simd.h>

void metil_model_object_vertex_transform(
  thread float4*,
  const device float4*,
  thread float4*,
  thread float4*,
  thread float4*,
  thread matrix_float4x4*
);

float4 metil_model_object_position_calcluate(
  unsigned int,
  const device float4*,
  constant struct math_c_vector3_float*,
  constant unsigned int*,
  constant struct math_c_vector3_float*
);

#endif
