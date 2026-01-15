#include <metil_mesh/metil_mesh_2d/metil_mesh_triangle.h>

#include <metil_mesh/metil_mesh.h>

#include <clic3_memory.h>

#include <math_c_vector.h>

void metil_mesh_triangle_initialize(
  struct metil_mesh* metil_mesh,
  struct math_c_vector2_float size
) {
  metil_mesh_initialize(
    metil_mesh
  );

  metil_mesh->size.x = size.x;
  metil_mesh->size.y = size.y;
  metil_mesh->size.z = 0.0f;

  struct math_c_vector2_float size_half = {
    .x = metil_mesh->size.x / 2.0f,
    .y = metil_mesh->size.y / 2.0f
  };

  metil_mesh->length_vertices = 3;
  metil_mesh->length_indices = 3;

  clic3_memory_allocate(
    &metil_mesh->indices,
    (
      sizeof(
        unsigned int
      ) *
      metil_mesh->length_indices
    )
  );

  clic3_memory_allocate(
    &metil_mesh->vertices,
    (
      sizeof(
        struct math_c_vector4_float
      ) *
      metil_mesh->length_vertices
    )
  );

  metil_mesh->vertices[0].x = -size_half.x;
  metil_mesh->vertices[0].y = -size_half.y;
  metil_mesh->vertices[0].z = 0.0f;
  metil_mesh->vertices[0].w = 1.0f;

  metil_mesh->vertices[1].x = size_half.x;
  metil_mesh->vertices[1].y = -size_half.y;
  metil_mesh->vertices[1].z = 0.0f;
  metil_mesh->vertices[1].w = 1.0f;

  metil_mesh->vertices[2].x = 0.0f;
  metil_mesh->vertices[2].y = size_half.y;
  metil_mesh->vertices[2].z = 0.0f;
  metil_mesh->vertices[2].w = 1.0f;

  metil_mesh->indices[0] = 0;
  metil_mesh->indices[1] = 1;
  metil_mesh->indices[2] = 2;
}
