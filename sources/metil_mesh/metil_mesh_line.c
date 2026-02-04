#include <metil_mesh/metil_mesh_line.h>

#include <metil_mesh/metil_mesh.h>

#include <clic3_memory.h>

#include <math_c_vector.h>

void metil_mesh_line_initialize(
  struct metil_mesh* metil_mesh_line,
  unsigned int length_points,
  struct math_c_vector3_float* points
) {
  metil_mesh_initialize(
    metil_mesh_line
  );

  metil_mesh_line->length_indices = (
    (
      length_points -
      1
    ) *
    2
  );

  metil_mesh_line->length_vertices = (
    length_points
  );

  clic3_memory_reallocate_raw(
    &metil_mesh_line->indices,
    (
      sizeof(
        unsigned int
      ) *
      metil_mesh_line->length_indices
    )
  );

  clic3_memory_reallocate_raw(
    &metil_mesh_line->vertices,
    (
      sizeof(
        struct math_c_vector4_float
      ) *
      metil_mesh_line->length_vertices
    )
  );

  unsigned int index_index = 0;

  struct math_c_vector3_float size_minimums = {
    .x = (
      points[
        0
      ].x
    ),
    .y = (
      points[
        0
      ].y
    ),
    .z = (
      points[
        0
      ].z
    )
  };

  struct math_c_vector3_float size_maximums = {
    .x = (
      points[
        0
      ].x
    ),
    .y = (
      points[
        0
      ].y
    ),
    .z = (
      points[
        0
      ].z
    )
  };

  for (
    unsigned int index_vertex = 0;
    index_vertex < length_points;
    ++index_vertex
  ) {
    metil_mesh_line->vertices[
      index_vertex
    ].x = (
      points[
        index_vertex
      ].x
    );

    metil_mesh_line->vertices[
      index_vertex
    ].y = (
      points[
        index_vertex
      ].y
    );

    metil_mesh_line->vertices[
      index_vertex
    ].z = (
      points[
        index_vertex
      ].z
    );

    metil_mesh_line->vertices[
      index_vertex
    ].w = (
      1.0f
    );

    if (
      index_vertex > 0
    ) {
      if (
        size_minimums.x > (
          metil_mesh_line->vertices[
            index_vertex
          ].x
        )
      ) {
        size_minimums.x = (
          metil_mesh_line->vertices[
            index_vertex
          ].x
        );
      }

      if (
        size_minimums.y > (
          metil_mesh_line->vertices[
            index_vertex
          ].y
        )
      ) {
        size_minimums.y = (
          metil_mesh_line->vertices[
            index_vertex
          ].y
        );
      }

      if (
        size_minimums.z > (
          metil_mesh_line->vertices[
            index_vertex
          ].z
        )
      ) {
        size_minimums.z = (
          metil_mesh_line->vertices[
            index_vertex
          ].z
        );
      }

      if (
        size_maximums.x < (
          metil_mesh_line->vertices[
            index_vertex
          ].x
        )
      ) {
        size_maximums.x = (
          metil_mesh_line->vertices[
            index_vertex
          ].x
        );
      }

      if (
        size_maximums.y < (
          metil_mesh_line->vertices[
            index_vertex
          ].y
        )
      ) {
        size_maximums.y = (
          metil_mesh_line->vertices[
            index_vertex
          ].y
        );
      }

      if (
        size_maximums.z < (
          metil_mesh_line->vertices[
            index_vertex
          ].z
        )
      ) {
        size_maximums.z = (
          metil_mesh_line->vertices[
            index_vertex
          ].z
        );
      }

      metil_mesh_line->indices[
        index_index
      ] = (
        index_vertex -
        1
      );

      index_index = (
        index_index +
        1
      );

      metil_mesh_line->indices[
        index_index
      ] = (
        index_vertex
      );

      index_index = (
        index_index +
        1
      );
    }
  }

  metil_mesh_line->size.x = (
    size_maximums.x -
    size_minimums.x
  );

  metil_mesh_line->size.y = (
    size_maximums.y -
    size_minimums.y
  );

  metil_mesh_line->size.z = (
    size_maximums.z -
    size_minimums.z
  );
}
