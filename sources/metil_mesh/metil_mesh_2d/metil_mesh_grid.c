#include <metil_mesh/metil_mesh_2d/metil_mesh_grid.h>

#include <metil_mesh/metil_mesh.h>

#include <clic3_memory.h>

#include <math_c_vector.h>

void metil_mesh_celled_grid_initialize(
  struct metil_mesh* metil_mesh,
  struct math_c_vector2_float size,
  struct math_c_vector2_unsigned_long_int cells
) {
  metil_mesh_initialize(
    metil_mesh
  );

  metil_mesh->size.x = size.x;
  metil_mesh->size.y = size.y;
  metil_mesh->size.z = 0.0f;

  struct math_c_vector2_float size_cell = {
    .x = metil_mesh->size.x / cells.x,
    .y = metil_mesh->size.y / cells.y
  };

  metil_mesh->length_vertices = (
    (
      cells.x +
      1
    ) *
    (
      cells.y +
      1
    )
  );

  metil_mesh->length_indices = (
    metil_mesh->length_vertices
  );

  clic3_memory_reallocate_raw(
    &metil_mesh->indices,
    (
      sizeof(
        unsigned int
      ) *
      metil_mesh->length_indices
    )
  );

  clic3_memory_reallocate_raw(
    &metil_mesh->vertices,
    (
      sizeof(
        struct math_c_vector4_float
      ) *
      metil_mesh->length_vertices
    )
  );

  unsigned long int index_index = (
    0
  );

  unsigned long int index_vertex = (
    0
  );

  for (
    unsigned int index_x = 0;
    index_x <= cells.x;
    ++index_x
  ) {
    for (
      unsigned int index_y = 0;
      index_y <= cells.x;
      ++index_y
    ) {
      metil_mesh->vertices[index_vertex].x = size_cell.x * index_x;
      metil_mesh->vertices[index_vertex].y = size_cell.y * index_y;
      metil_mesh->vertices[index_vertex].z = 0.0f;
      metil_mesh->vertices[index_vertex].w = 1.0f;

      metil_mesh->indices[index_index] = index_vertex;

      index_index = (
        index_index +
        1
      );

      index_vertex = (
        index_vertex +
        1
      );
    }
  }
}
