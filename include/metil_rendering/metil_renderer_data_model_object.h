#ifndef __metil_renderer_data_model_object_h
#define __metil_renderer_data_model_object_h

#include <clic3_vector.h>

#include <simd/simd.h>

struct metil_renderer_data_model_object {
  matrix_float4x4 view_model_matrix_projection;
  matrix_float4x4 matrix_projection_object_offset_with_rotation;
  matrix_float4x4 matrix_projection_object_with_rotation;

  struct clic3_vector3_float position;
  struct clic3_vector3_float size;

  struct clic3_vector4_float color;

  unsigned int noise;
};

#endif
