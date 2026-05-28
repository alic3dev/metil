#ifndef __metil_metil_mesh_metil_mesh_export_h
#define __metil_metil_mesh_metil_mesh_export_h

#include <metil_mesh/metil_mesh.h>
#include <metil_status.h>

#include <math_c_vector.h>

metil_status metil_mesh_export(
  struct metil_mesh*,
  char* path_file_export
);

metil_status metil_mesh_export_raw(
  unsigned int,
  unsigned int,
  unsigned int*,
  struct math_c_vector4_float*,
  struct math_c_vector3_float*,
  char*
);

#endif
