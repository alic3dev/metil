#include <metil_mesh/metil_mesh_import.h>

#include <metil_file.h>
#include <metil_mesh/metil_mesh.h>
#include <metil_status.h>

#include <clic3_bytes.h>
#include <clic3_memory.h>

#include <stdio.h>

metil_status metil_mesh_import(
  struct metil_mesh* metil_mesh,
  char* path_file_import
) {
  FILE* file_import = (
    fopen(
      path_file_import,
      "rb"
    )
  );
  
  if (
    file_import ==
    0x00
  ) {
    return (
      metil_status_error
    );
  }
  
  fseek(
    file_import,
    0x00,
    SEEK_END
  );

  unsigned int length_buffer = (
    ftell(
      file_import
    )
  );
  
  rewind(
    file_import
  );
  
  unsigned char* buffer = (
    clic3_memory_allocate_raw(
      length_buffer
    )
  );
  
  fread(
    buffer,
    length_buffer,
    0x01,
    file_import
  );

  metil_status metil_status_import = (
    metil_mesh_import_parse(
      metil_mesh,
      buffer,
      length_buffer
    )
  );
  
  clic3_memory_free_raw(
    buffer
  );
  
  return (
    metil_status_import
  );
}

metil_status metil_mesh_import_parse(
  struct metil_mesh* metil_mesh,
  unsigned char* buffer,
  unsigned int length_buffer
) {
  if (
    length_buffer <
    (
      0x01 +
      (
        sizeof(
          unsigned int
        ) *
        0x02
      ) +
      sizeof(
        struct math_c_vector3_float
      )  
    )
  ) {
    return (
      metil_status_error
    );
  }

  unsigned int index_buffer = (
    0x00
  );
  
  if (
    buffer[
      index_buffer
    ] !=
    metil_file_type_mesh
  ) {
    return (
      metil_status_error
    );
  }
  
  index_buffer = (
    index_buffer +
    0x01
  );
  
  unsigned int length_indices = (
    0x00
  );
  
  unsigned int length_vertices = (
    0x00
  );
  
  clic3_bytes_copy(
    &length_indices,
    (
      buffer +
      index_buffer
    ),
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
    &length_vertices,
    (
      buffer +
      index_buffer
    ),
    sizeof(
      unsigned int
    )
  );
  
  if (
    length_buffer <
    (
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
    )
  ) {
    return (
      metil_status_error
    );
  }
  
  metil_mesh->length_indices = (
    length_indices
  );
  
  metil_mesh->length_vertices = (
    length_vertices
  );
  
  metil_mesh->indices = (
    clic3_memory_allocate_raw(      sizeof(        unsigned int
      ) *
      metil_mesh->length_indices
    )
  );
  
  metil_mesh->vertices = (
    clic3_memory_allocate_raw(
      sizeof(
        struct math_c_vector4_float
      ) *
      metil_mesh->length_vertices
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
      &metil_mesh->indices[
        index_index
      ],
      (
        buffer +
        index_buffer
      ),
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
      &metil_mesh->vertices[
        index_vertex
      ],
      (
        buffer +
        index_vertex
      ),
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
    &metil_mesh->size,
    (
      buffer +
      index_buffer
    ),
    sizeof(
      struct math_c_vector3_float
    )
  );

  return (
    metil_status_success
  );
}
