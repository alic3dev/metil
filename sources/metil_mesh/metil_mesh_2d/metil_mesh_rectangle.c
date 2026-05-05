#include <metil_mesh/metil_mesh_2d/metil_mesh_rectangle.h>

#include <metil_mesh/metil_mesh.h>

#include <clic3_memory.h>

#include <math_c_vector.h>

void metil_mesh_rectangle_initialize(
  struct metil_mesh* metil_mesh,
  struct math_c_vector2_float size
) {
  metil_mesh_initialize_with_lengths(
    metil_mesh,
    0x04,
    0x06
  );

  metil_mesh->size.x = (
    size.x
  );

  metil_mesh->size.y = (
    size.y
  );

  metil_mesh->size.z = (
    0x00
  );

  struct math_c_vector2_float size_half = {
    .x = (
      metil_mesh->size.x /
      0x02
    ),
    .y = (
      metil_mesh->size.y /
      0x02
    )
  };

  metil_mesh->vertices[0].x = -size_half.x;
  metil_mesh->vertices[0].y = -size_half.y;
  metil_mesh->vertices[0].z = 0.0f;
  metil_mesh->vertices[0].w = 1.0f;

  metil_mesh->vertices[1].x = size_half.x;
  metil_mesh->vertices[1].y = -size_half.y;
  metil_mesh->vertices[1].z = 0.0f;
  metil_mesh->vertices[1].w = 1.0f;

  metil_mesh->vertices[2].x = -size_half.x;
  metil_mesh->vertices[2].y = size_half.y;
  metil_mesh->vertices[2].z = 0.0f;
  metil_mesh->vertices[2].w = 1.0f;

  metil_mesh->vertices[3].x = size_half.x;
  metil_mesh->vertices[3].y = size_half.y;
  metil_mesh->vertices[3].z = 0.0f;
  metil_mesh->vertices[3].w = 1.0f;

  metil_mesh->indices[0] = 0;
  metil_mesh->indices[1] = 1;
  metil_mesh->indices[2] = 2;

  metil_mesh->indices[3] = 2;
  metil_mesh->indices[4] = 3;
  metil_mesh->indices[5] = 1;
}
