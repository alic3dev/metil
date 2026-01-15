#include <metil_mesh/metil_mesh_box.h>

#include <metil_mesh/metil_mesh.h>

#include <clic3_memory.h>

void metil_mesh_box_initialize(
  struct metil_mesh* metil_mesh,
  struct math_c_vector3_float size
) {
  metil_mesh_initialize(
    metil_mesh
  );

  metil_mesh->size.x = size.x;
  metil_mesh->size.y = size.y;
  metil_mesh->size.z = size.z;

  struct math_c_vector3_float size_half = {
    .x = metil_mesh->size.x / 2.0f,
    .y = metil_mesh->size.y / 2.0f,
    .z = metil_mesh->size.z / 2.0f
  };

  metil_mesh->length_vertices = 8;
  metil_mesh->length_indices = 36;

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

  metil_mesh->vertices[0].x = -size_half.x;
  metil_mesh->vertices[0].y = -size_half.y;
  metil_mesh->vertices[0].z = -size_half.z;
  metil_mesh->vertices[0].w = 1.0f;

  metil_mesh->vertices[1].x = size_half.x;
  metil_mesh->vertices[1].y = -size_half.y;
  metil_mesh->vertices[1].z = -size_half.z;
  metil_mesh->vertices[1].w = 1.0f;

  metil_mesh->vertices[2].x = -size_half.x;
  metil_mesh->vertices[2].y = -size_half.y;
  metil_mesh->vertices[2].z = size_half.z;
  metil_mesh->vertices[2].w = 1.0f;

  metil_mesh->vertices[3].x = size_half.x;
  metil_mesh->vertices[3].y = -size_half.y;
  metil_mesh->vertices[3].z = size_half.z;
  metil_mesh->vertices[3].w = 1.0f;

  metil_mesh->vertices[4].x = -size_half.x;
  metil_mesh->vertices[4].y = size_half.y;
  metil_mesh->vertices[4].z = -size_half.z;
  metil_mesh->vertices[4].w = 1.0f;

  metil_mesh->vertices[5].x = size_half.x;
  metil_mesh->vertices[5].y = size_half.y;
  metil_mesh->vertices[5].z = -size_half.z;
  metil_mesh->vertices[5].w = 1.0f;

  metil_mesh->vertices[6].x = -size_half.x;
  metil_mesh->vertices[6].y = size_half.y;
  metil_mesh->vertices[6].z = size_half.z;
  metil_mesh->vertices[6].w = 1.0f;

  metil_mesh->vertices[7].x = size_half.x;
  metil_mesh->vertices[7].y = size_half.y;
  metil_mesh->vertices[7].z = size_half.z;
  metil_mesh->vertices[7].w = 1.0f;

  metil_mesh->indices[0] = 0;
  metil_mesh->indices[1] = 1;
  metil_mesh->indices[2] = 2;

  metil_mesh->indices[3] = 2;
  metil_mesh->indices[4] = 3;
  metil_mesh->indices[5] = 1;

  metil_mesh->indices[6] = 1;
  metil_mesh->indices[7] = 0;
  metil_mesh->indices[8] = 4;

  metil_mesh->indices[9] = 4;
  metil_mesh->indices[10] = 5;
  metil_mesh->indices[11] = 1;

  metil_mesh->indices[12] = 1;
  metil_mesh->indices[13] = 3;
  metil_mesh->indices[14] = 5;

  metil_mesh->indices[15] = 5;
  metil_mesh->indices[16] = 7;
  metil_mesh->indices[17] = 3;

  metil_mesh->indices[18] = 3;
  metil_mesh->indices[19] = 2;
  metil_mesh->indices[20] = 7;

  metil_mesh->indices[21] = 7;
  metil_mesh->indices[22] = 6;
  metil_mesh->indices[23] = 2;

  metil_mesh->indices[24] = 2;
  metil_mesh->indices[25] = 0;
  metil_mesh->indices[26] = 4;

  metil_mesh->indices[27] = 4;
  metil_mesh->indices[28] = 2;
  metil_mesh->indices[29] = 6;

  metil_mesh->indices[30] = 6;
  metil_mesh->indices[31] = 4;
  metil_mesh->indices[32] = 5;

  metil_mesh->indices[33] = 5;
  metil_mesh->indices[34] = 6;
  metil_mesh->indices[35] = 7;
}
