#include <metil_mesh/metil_mesh_parse.h>

#include <metil_mesh/metil_mesh.h>
#include <metil_status.h>

// struct math_c_vector3_float size;

// unsigned int* indices;
// struct math_c_vector4_float* vertices;

// void* data;

metil_status metil_mesh_parse(
  struct metil_mesh* metil_mesh,
  char* mesh_import
) {
  metil_mesh_initialize(
    metil_mesh
  );

  metil_status status_valid_mesh = (
    metil_status_error
  );

  unsigned int index_mesh_import = 0;

  char character_mesh_import = mesh_import[
    index_mesh_import
  ];

  while (
    character_mesh_import != '\0'
  ) {
    
  }

  return (
    status_valid_mesh
  );
}
