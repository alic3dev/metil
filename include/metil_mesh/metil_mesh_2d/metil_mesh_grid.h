#ifndef __metil_mesh_metil_mesh_2d_metil_mesh_grid_h
#define __metil_mesh_metil_mesh_2d_metil_mesh_grid_h

#include <metil_mesh/metil_mesh.h>

#include <math_c_vector.h>

void metil_mesh_celled_grid_initialize(
  struct metil_mesh*,
  struct math_c_vector2_float,
  struct math_c_vector2_unsigned_long_int
);

#endif
