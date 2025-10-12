#ifndef __metil_renderer_data_object_h
#define __metil_renderer_data_object_h

#include <clic3_vector.h>

#include <simd/simd.h>

struct metil_renderer_data_object {
  unsigned int id;

  matrix_float4x4 view_model_matrix_projection;
  struct clic3_vector3_float position;
  
  float width;
  float height;
  float depth;

  struct clic3_vector4_float color;
  int mode_texture;

  unsigned int noise;
};

#endif
