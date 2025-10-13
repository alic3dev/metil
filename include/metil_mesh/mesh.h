#ifndef __metil_mesh_h
#define __metil_mesh_h

#include <clic3_vector.h>

enum metil_mesh_positioning {
  metil_mesh_positioning_normal = 0,
  metil_mesh_positioning_player = 1,
  metil_mesh_positioning_static = 2
};

struct metil_mesh {
  unsigned int length_indices;
  unsigned int length_vertices;

  unsigned int* indices;
  struct clic3_vector4_float* vertices;

  struct clic3_vector3_float size;

  enum metil_mesh_positioning positioning;

  void* data;
};

void metil_mesh_initialize(
  struct metil_mesh*
);

void metil_mesh_destroy(
  struct metil_mesh*
);

#endif
