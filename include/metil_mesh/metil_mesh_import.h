#ifndef __metil_metil_mesh_metil_mesh_import_h
#define __metil_metil_mesh_metil_mesh_import_h

#include <metil_mesh/metil_mesh.h>
#include <metil_status.h>

metil_status
metil_mesh_import(
  struct metil_mesh*,
  char*
);

metil_status metil_mesh_import_parse(
  struct metil_mesh*,
  unsigned char*,
  unsigned int
);
#endif

