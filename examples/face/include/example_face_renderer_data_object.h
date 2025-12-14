#ifndef __example_face_renderer_data_object_h
#define __example_face_renderer_data_object_h

#include <clic3_vector.h>

#include <simd/simd.h>

struct example_face_renderer_data_object {
  matrix_float4x4 view_model_matrix_projection;
  struct clic3_vector3_float position;
  struct clic3_vector3_float size;

  struct clic3_vector4_float color;

  unsigned int vertex_hovered;
  unsigned int vertex_held;
};

#endif
