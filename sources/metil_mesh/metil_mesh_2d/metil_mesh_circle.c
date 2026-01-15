#include <metil_mesh/metil_mesh_2d/metil_mesh_circle.h>

#include <metil_mesh/metil_mesh.h>

#include <clic3_memory.h>

#include <math.h>

void metil_mesh_circle_initialize(
  struct metil_mesh* metil_mesh,
  float radius,
  unsigned short int segments
) {
  metil_mesh_initialize(
    metil_mesh
  );

  float diameter = radius * 2.0f;

  metil_mesh->size.x = diameter;
  metil_mesh->size.y = diameter;
  metil_mesh->size.z = diameter;

  metil_mesh->length_vertices = segments + 1;
  metil_mesh->length_indices = segments * 3;

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

  metil_mesh->vertices[0].x = 0.0f;
  metil_mesh->vertices[0].y = 0.0f;
  metil_mesh->vertices[0].z = 0.0f;
  metil_mesh->vertices[0].w = 1.0f;

  for (
    unsigned short int index_segment = 0;
    index_segment < segments;
    ++index_segment
  ) {
    unsigned short int index_vertex = index_segment + 1;
    unsigned short int index_index = index_segment * 3;

    float angle = (
      ((float) index_segment / (float) segments) *
      M_PI * 2.0f
    );

    metil_mesh->vertices[
      index_vertex
    ].x = sin(angle) * radius;

    metil_mesh->vertices[
      index_vertex
    ].y = cos(angle) * radius;

    metil_mesh->vertices[
      index_vertex
    ].z = 0.0f;

    metil_mesh->vertices[
      index_vertex
    ].w = 1.0f;

    metil_mesh->indices[
      index_index
    ] = 0;

    metil_mesh->indices[
      index_index + 1
    ] = index_vertex;

    metil_mesh->indices[
      index_index + 2
    ] = (
      index_vertex == segments
      ? 1
      : index_vertex + 1
    );
  }
}
