#ifndef __metil_mesh_metil_mesh_h
#define __metil_mesh_metil_mesh_h

#include <math_c_vector.h>

struct metil_mesh {
  unsigned int length_indices;
  unsigned int length_vertices;

  unsigned int* indices;
  struct math_c_vector4_float* vertices;

  struct math_c_vector3_float size;

  void* data;
};

void metil_mesh_initialize(
  struct metil_mesh*
);

void metil_mesh_initialize_with_lengths(
  struct metil_mesh*,
  unsigned int,
  unsigned int
);

void metil_mesh_clone(
  struct metil_mesh*,
  struct metil_mesh*
);

void metil_mesh_destroy(
  struct metil_mesh*
);

#endif
