#include <metil_mesh/metil_mesh_2d/metil_mesh_square.h>

#include <metil_mesh/metil_mesh.h>

#include <stdlib.h>

void metil_mesh_square_initialize(
  struct metil_mesh* metil_mesh,
  float size
) {
  metil_mesh_initialize(
    metil_mesh
  );

  metil_mesh->size.x = size;
  metil_mesh->size.y = size;
  metil_mesh->size.z = 0.0f;

  float size_half = size / 2.0f;

  metil_mesh->length_vertices = 4;
  metil_mesh->length_indices = 6;

  metil_mesh->indices = realloc(
    metil_mesh->indices,
    sizeof(unsigned int) *
    metil_mesh->length_indices
  );

  metil_mesh->vertices = realloc(
    metil_mesh->vertices,
    sizeof(struct math_c_vector4_float) *
    metil_mesh->length_vertices
  );

  metil_mesh->vertices[0].x = -size_half;
  metil_mesh->vertices[0].y = -size_half;
  metil_mesh->vertices[0].z = 0.0f;
  metil_mesh->vertices[0].w = 1.0f;

  metil_mesh->vertices[1].x = size_half;
  metil_mesh->vertices[1].y = -size_half;
  metil_mesh->vertices[1].z = 0.0f;
  metil_mesh->vertices[1].w = 1.0f;

  metil_mesh->vertices[2].x = -size_half;
  metil_mesh->vertices[2].y = size_half;
  metil_mesh->vertices[2].z = 0.0f;
  metil_mesh->vertices[2].w = 1.0f;

  metil_mesh->vertices[3].x = size_half;
  metil_mesh->vertices[3].y = size_half;
  metil_mesh->vertices[3].z = 0.0f;
  metil_mesh->vertices[3].w = 1.0f;

  metil_mesh->indices[0] = 0;
  metil_mesh->indices[1] = 1;
  metil_mesh->indices[2] = 2;

  metil_mesh->indices[3] = 2;
  metil_mesh->indices[4] = 3;
  metil_mesh->indices[5] = 1;
}
