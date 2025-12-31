#ifndef __metil_mesh_metil_mesh_tube_h
#define __metil_mesh_metil_mesh_tube_h

#include <metil_mesh/metil_mesh.h>

#include <clic3_vector.h>

void metil_mesh_tube_initialize(
  struct metil_mesh*,
  struct clic3_vector3_float,
  struct clic3_vector2_unsigned_short_int
);

#endif
