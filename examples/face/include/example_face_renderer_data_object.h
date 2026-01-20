#ifndef __example_face_renderer_data_object_h
#define __example_face_renderer_data_object_h

#include <math_c_vector.h>

#include <simd/simd.h>

struct example_face_renderer_data_object {
  matrix_float4x4 view_model_matrix_projection;
  struct math_c_vector3_float position;
  struct math_c_vector3_float size;

  struct math_c_vector4_float colour;

  unsigned int vertex_hovered;
  unsigned int vertex_held;

  struct math_c_vector4_float position_screen[
    33
  ];
};

#endif
