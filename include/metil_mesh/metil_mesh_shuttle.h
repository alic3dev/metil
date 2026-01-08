#ifndef __metil_mesh_metil_mesh_shuttle_h
#define __metil_mesh_metil_mesh_shuttle_h

#include <metil_mesh/metil_mesh.h>

#include <math_c_vector.h>

void metil_mesh_shuttle_initialize(
  struct metil_mesh*,
  struct math_c_vector3_float,
  struct math_c_vector2_unsigned_short_int
);

#endif
