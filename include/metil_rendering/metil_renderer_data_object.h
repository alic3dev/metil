#ifndef __metil_rendering_metil_renderer_data_object_h
#define __metil_rendering_metil_renderer_data_object_h

#include <math_c_vector.h>

#include <simd/simd.h>

struct metil_renderer_data_object {
  matrix_float4x4 view_model_matrix_projection;
  struct math_c_vector3_float position;
  struct math_c_vector3_float size;

  struct math_c_vector4_float color;

  unsigned int noise;
};

#endif
