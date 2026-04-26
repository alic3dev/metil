#include <metil_mesh/metil_mesh.h>

#include <clic3_memory.h>

#include <math_c_vector.h>

void metil_mesh_initialize(
  struct metil_mesh* metil_mesh
) {
  metil_mesh_initialize_with_lengths(
    metil_mesh,
    0x00,
    0x00
  );
}

void metil_mesh_initialize_with_lengths(
  struct metil_mesh* metil_mesh,
  unsigned int length_vertices,
  unsigned int length_indices
) {
  metil_mesh->length_indices = (
    length_indices
  );

  metil_mesh->length_vertices = (
    length_vertices
  );

  metil_mesh->size.x = (
    0x00
  );

  metil_mesh->size.y = (
    0x00
  );

  metil_mesh->size.z = (
    0x00
  );

  metil_mesh->indices = (
    clic3_memory_allocate_raw(
      sizeof(
        unsigned int
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

  metil_mesh->data = (
    0x00
  );
}

void metil_mesh_clone(
  struct metil_mesh* mesh_source,
  struct metil_mesh* mesh_clone
) {
  mesh_clone->length_indices = (
    mesh_source->length_indices
  );

  mesh_clone->length_vertices = (
    mesh_source->length_vertices
  );

  mesh_clone->size.x = (
    mesh_source->size.x
  );

  mesh_clone->size.y = (
    mesh_source->size.y
  );

  mesh_clone->size.z = (
    mesh_source->size.z
  );

  mesh_clone->indices = (
    clic3_memory_allocate_raw(
      sizeof(
        unsigned int
      ) *
      mesh_clone->length_indices
    )
  );

  mesh_clone->vertices = (
    clic3_memory_allocate_raw(
      sizeof(
        struct math_c_vector4_float
      ) *
      mesh_clone->length_vertices
    )
  );

  for (
    unsigned int index_index = (
      0x00
    );
    (
      index_index <
      mesh_clone->length_indices
    );
    ++index_index
  ) {
    mesh_clone->indices[
      index_index
    ] = (
      mesh_source->indices[
        index_index
      ]
    );
  }

  for (
    unsigned int index_vertex = (
      0x00
    );
    (
      index_vertex <
      mesh_clone->length_vertices
    );
    ++index_vertex
  ) {
    mesh_clone->vertices[
      index_vertex
    ].x = (
      mesh_source->vertices[
        index_vertex
      ].x
    );

    mesh_clone->vertices[
      index_vertex
    ].y = (
      mesh_source->vertices[
        index_vertex
      ].y
    );

    mesh_clone->vertices[
      index_vertex
    ].z = (
      mesh_source->vertices[
        index_vertex
      ].z
    );

    mesh_clone->vertices[
      index_vertex
    ].w = (
      mesh_source->vertices[
        index_vertex
      ].w
    );
  }

  mesh_clone->data = (
    0x00
  );
}

void metil_mesh_destroy(
  struct metil_mesh* metil_mesh
) {
  clic3_memory_free(
    metil_mesh->indices
  );

  clic3_memory_free(
    metil_mesh->vertices
  );
}
