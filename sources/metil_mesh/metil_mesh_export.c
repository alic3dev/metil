#include <metil_mesh/metil_mesh_export.h>

#include <metil_file.h>
#include <metil_mesh/metil_mesh.h>
#include <metil_status.h>

#include <clic3_bytes.h>
#include <clic3_memory.h>

#include <math_c_vector.h>

#include <stdio.h>

metil_status metil_mesh_export(
  struct metil_mesh* metil_mesh,
  char* path_file_export
) {
  return (
    metil_mesh_export_raw(
      metil_mesh->length_indices,
      metil_mesh->length_vertices,
      metil_mesh->indices,
      metil_mesh->vertices,
      &metil_mesh->size,
      path_file_export
    )
  );
}

metil_status metil_mesh_export_raw(
  unsigned int length_indices,
  unsigned int length_vertices,
  unsigned int* indices,
  struct math_c_vector4_float* vertices,
  struct math_c_vector3_float* size,
  char* path_file_export
) {
  FILE* file_export = (
    fopen(
      path_file_export,
      "wb"
    )
  );
  
  if (
    file_export ==
    0x00
  ) {
    return (
      metil_status_error
    );
  }
    
  unsigned char metil_file_type = (
    metil_file_type_mesh
  );
  
  unsigned int length_buffer = (
    0x01 +
    sizeof(
      unsigned int
    ) *
    (
      0x02 +
      length_indices
    ) +
    sizeof(
      struct math_c_vector4_float
    ) *
    length_vertices +
    sizeof(
      struct math_c_vector3_float
    )
  );
  
  unsigned char* buffer = (
    clic3_memory_allocate_raw(
      length_buffer
    )
  );
  
  unsigned int index_buffer = (
    0x00
  );
  
  buffer[
    index_buffer
  ] = (
    metil_file_type
  );
  
  index_buffer = (
    index_buffer +
    0x01
  );
  
  clic3_bytes_copy(
    (
      buffer +
      index_buffer
    ),
    &length_indices,
    sizeof(
      unsigned int
    )
  );
  
  index_buffer = (
    index_buffer +
    sizeof(
      unsigned int
    )
  );
  
  clic3_bytes_copy(
    (
      buffer +
      index_buffer
    ),
    &length_vertices,
    sizeof(
      unsigned int
    )
  );
  
  index_buffer = (
    index_buffer +
    sizeof(
      unsigned int
    )
  );
  
  for (
    unsigned int index_index = (
      0x00
    );
    (
      index_index <
      length_indices
    );
    ++index_index
  ) {
    clic3_bytes_copy(
      (
        buffer +
        index_buffer
      ),
      &indices[
        index_index
      ],
      sizeof(
        unsigned int
      )
    );
    
    index_buffer = (
      index_buffer +
      sizeof(
        unsigned int
      )
    );
  }
  
  for (
    unsigned int index_vertex = (
      0x00
    );
    (
      index_vertex <
      length_vertices
    );
    ++index_vertex
  ) {
    clic3_bytes_copy(
      (
        buffer +
        index_buffer
      ),
      &vertices[
        index_vertex
      ],
      sizeof(
        struct math_c_vector4_float
      )
    );
    
    index_buffer = (
      index_buffer +
      sizeof(
        struct math_c_vector4_float
      )
    );
  }
  
  clic3_bytes_copy(
    (
      buffer +
      index_buffer
    ),
    size,
    sizeof(
      struct math_c_vector3_float
    )
  );
  
  index_buffer = (
    index_buffer +
    sizeof(
      struct math_c_vector3_float
    )
  );
  
  fwrite(
    buffer,
    length_buffer,
    0x01,
    file_export
  );
  
  clic3_memory_free_raw(
    buffer
  );
    
  fclose(
    file_export
  );  

  return (
    metil_status_success
  );
}
