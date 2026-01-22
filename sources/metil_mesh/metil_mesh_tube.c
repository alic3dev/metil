#include <metil_mesh/metil_mesh_tube.h>

#include <metil_direction.h>
#include <metil_mesh/metil_mesh.h>

#include <clic3_memory.h>

#include <math_c_pi.h>
#include <math_c_sine.h>
#include <math_c_vector.h>

void metil_mesh_tube_initialize(
  struct metil_mesh* metil_mesh,
  struct math_c_vector3_float size,
  struct math_c_vector2_unsigned_short_int segments,
  enum metil_direction direction
) {
  metil_mesh_initialize(
    metil_mesh
  );

  metil_mesh->size.x = size.x;
  metil_mesh->size.y = size.y;
  metil_mesh->size.z = size.z;

  struct math_c_vector3_float size_half = {
    .x = (
      size.x /
      2.0f
    ),
    .y = (
      size.y /
      2.0f
    ),
    .z = (
      size.z /
      2.0f
    )
  };

  metil_mesh->length_vertices = (
    segments.x *
    segments.y +
    2
  );

  metil_mesh->length_indices = (
    6 * (
      segments.x
    ) + (
      segments.x * (
        segments.y -
        1
      ) *
      6
    )
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

  unsigned int index_index = (
    0
  );

  for (
    unsigned int index_segment_x = 0;
    index_segment_x < segments.x;
    ++index_segment_x
  ) {
    metil_mesh->indices[
      index_index
    ] = (
      0
    );

    index_index = (
      index_index +
      1
    );

    metil_mesh->indices[
      index_index
    ] = (
      index_segment_x +
      1
    );

    index_index = (
      index_index +
      1
    );

    metil_mesh->indices[
      index_index
    ] = (
      (
        index_segment_x +
        1
      ) %
      segments.x +
      1
    );

    index_index = (
      index_index +
      1
    );
  }

  float increment_y;

  switch (
    direction
  ) {
    case metil_direction_up: {
      increment_y = (
        size.y / (
          segments.y -
          1
        )
      );

      metil_mesh->vertices[0].x = 0.0f;
      metil_mesh->vertices[0].y = -size_half.y;
      metil_mesh->vertices[0].z = 0.0f;

      break;
    }
    case metil_direction_down: {
      increment_y = -(
        size.y / (
          segments.y -
          1
        )
      );

      metil_mesh->vertices[0].x = 0.0f;
      metil_mesh->vertices[0].y = size_half.y;
      metil_mesh->vertices[0].z = 0.0f;

      break;
    }
    case metil_direction_left: {
      increment_y = -(
        size.x / (
          segments.y -
          1
        )
      );

      metil_mesh->vertices[0].x = size_half.x;
      metil_mesh->vertices[0].y = 0.0f;
      metil_mesh->vertices[0].z = 0.0f;

      break;
    }
    case metil_direction_right: {
      increment_y = (
        size.x / (
          segments.y -
          1
        )
      );

      metil_mesh->vertices[0].x = -size_half.x;
      metil_mesh->vertices[0].y = 0.0f;
      metil_mesh->vertices[0].z = 0.0f;

      break;
    }
    case metil_direction_forwards: {
      increment_y = (
        size.z / (
          segments.y -
          1
        )
      );

      metil_mesh->vertices[0].x = 0.0f;
      metil_mesh->vertices[0].y = 0.0f;
      metil_mesh->vertices[0].z = -size_half.z;

      break;
    }
    case metil_direction_backwards: {
      increment_y = -(
        size.z / (
          segments.y -
          1
        )
      );

      metil_mesh->vertices[0].x = 0.0f;
      metil_mesh->vertices[0].y = 0.0f;
      metil_mesh->vertices[0].z = size_half.z;

      break;
    }
  }

  metil_mesh->vertices[0].w = 1.0f;

  for (
    unsigned int index_segment_y = 0;
    index_segment_y < segments.y;
    ++index_segment_y
  ) {
    unsigned int index_vertex_offset_y = (
      index_segment_y *
      segments.x
    );

    float position_y;

    switch (
      direction
    ) {
      case metil_direction_up: {
        position_y = (
          increment_y * (
            index_segment_y
          ) -
          size_half.y
        );

        break;
      }
      case metil_direction_down: {
        position_y = (
          increment_y * (
            index_segment_y
          ) +
          size_half.y
        );

        break;
      }
      case metil_direction_left: {
        position_y = (
          increment_y * (
            index_segment_y
          ) +
          size_half.x
        );

        break;
      }
      case metil_direction_right: {
        position_y = (
          increment_y * (
            index_segment_y
          ) -
          size_half.x
        );

        break;
      }
      case metil_direction_forwards: {
        position_y = (
          increment_y * (
            index_segment_y
          ) -
          size_half.z
        );

        break;
      }
      case metil_direction_backwards: {
        position_y = (
          increment_y * (
            index_segment_y
          ) +
          size_half.z
        );

        break;
      }
    }

    for (
      unsigned int index_segment_x = 0;
      index_segment_x < segments.x;
      ++index_segment_x
    ) {
      unsigned int index_vertex = (
        index_vertex_offset_y +
        index_segment_x +
        1
      );

      float angle = (
        (float) index_segment_x /
        (float) segments.x *
        math_c_pi_doubled
      );

      switch (
        direction
      ) {
        case metil_direction_up: {
          metil_mesh->vertices[
            index_vertex
          ].x = (
            math_c_sine(
              angle,
              math_c_pi
            ) *
            size_half.x
          );

          metil_mesh->vertices[
            index_vertex
          ].y = (
            position_y
          );

          metil_mesh->vertices[
            index_vertex
          ].z = (
            math_c_cosine(
              angle,
              math_c_pi
            ) *
            size_half.z
          );

          break;
        }
        case metil_direction_down: {
          metil_mesh->vertices[
            index_vertex
          ].x = (
            math_c_cosine(
              angle,
              math_c_pi
            ) *
            size_half.x
          );

          metil_mesh->vertices[
            index_vertex
          ].y = (
            position_y
          );

          metil_mesh->vertices[
            index_vertex
          ].z = (
            math_c_sine(
              angle,
              math_c_pi
            ) *
            size_half.z
          );

          break;
        }
        case metil_direction_left: {
          metil_mesh->vertices[
            index_vertex
          ].y = (
            math_c_sine(
              angle,
              math_c_pi
            ) *
            size_half.y
          );

          metil_mesh->vertices[
            index_vertex
          ].x = (
            position_y
          );

          metil_mesh->vertices[
            index_vertex
          ].z = (
            math_c_cosine(
              angle,
              math_c_pi
            ) *
            size_half.z
          );

          break;
        }
        case metil_direction_right: {
          metil_mesh->vertices[
            index_vertex
          ].y = (
            math_c_cosine(
              angle,
              math_c_pi
            ) *
            size_half.y
          );

          metil_mesh->vertices[
            index_vertex
          ].x = (
            position_y
          );

          metil_mesh->vertices[
            index_vertex
          ].z = (
            math_c_sine(
              angle,
              math_c_pi
            ) *
            size_half.z
          );

          break;
        }
        case metil_direction_forwards: {
          metil_mesh->vertices[
            index_vertex
          ].y = (
            math_c_cosine(
              angle,
              math_c_pi
            ) *
            size_half.y
          );

          metil_mesh->vertices[
            index_vertex
          ].z = (
            position_y
          );

          metil_mesh->vertices[
            index_vertex
          ].x = (
            math_c_sine(
              angle,
              math_c_pi
            ) *
            size_half.x
          );

          break;
        }
        case metil_direction_backwards: {
          metil_mesh->vertices[
            index_vertex
          ].y = (
            math_c_sine(
              angle,
              math_c_pi
            ) *
            size_half.y
          );

          metil_mesh->vertices[
            index_vertex
          ].z = (
            position_y
          );

          metil_mesh->vertices[
            index_vertex
          ].x = (
            math_c_cosine(
              angle,
              math_c_pi
            ) *
            size_half.x
          );

          break;
        }
      }

      metil_mesh->vertices[
        index_vertex
      ].w = (
        1.0f
      );

      if (
        index_segment_y == (
          segments.y -
          1
        )
      ) {
        continue;
      }

      metil_mesh->indices[
        index_index
      ] = (
        index_vertex
      );

      index_index = (
        index_index +
        1
      );

      if (
        index_segment_x == (
          segments.x -
          1
        )
      ) {
        metil_mesh->indices[
          index_index
        ] = (
          index_vertex_offset_y +
          1
        );
      } else {
        metil_mesh->indices[
          index_index
        ] = (
          index_vertex +
          1
        );
      }

      index_index = (
        index_index +
        1
      );

      metil_mesh->indices[
        index_index
      ] = (
        index_vertex +
        segments.x
      );

      index_index = (
        index_index +
        1
      );

      metil_mesh->indices[
        index_index 
      ] = (
        index_vertex +
        segments.x
      );

      index_index = (
        index_index +
        1
      );

      if (
        index_segment_x == (
          segments.x -
          1
        )
      ) {
        metil_mesh->indices[
          index_index
        ] = (
          index_vertex_offset_y +
          1
        );

        index_index = (
          index_index +
          1
        );

        metil_mesh->indices[
          index_index
        ] = (
          index_vertex_offset_y +
          segments.x +
          1
        );

        index_index = (
          index_index +
          1
        );
      } else {
        metil_mesh->indices[
          index_index
        ] = (
          index_vertex +
          1
        );

        index_index = (
          index_index +
          1
        );

        metil_mesh->indices[
          index_index
        ] = (
          index_vertex +
          segments.x +
          1
        );

        index_index = (
          index_index +
          1
        );
      }
    }
  }

  unsigned int index_vertex_last = (
    metil_mesh->length_vertices -
    1
  );

  switch (
    direction
  ) {
    case metil_direction_up: {
      metil_mesh->vertices[
        index_vertex_last
      ].x = 0.0f;

      metil_mesh->vertices[
        index_vertex_last
      ].y = size_half.y;

      metil_mesh->vertices[
        index_vertex_last
      ].z = 0.0f;

      break;
    }
    case metil_direction_down: {
      metil_mesh->vertices[
        index_vertex_last
      ].x = 0.0f;

      metil_mesh->vertices[
        index_vertex_last
      ].y = -size_half.y;

      metil_mesh->vertices[
        index_vertex_last
      ].z = 0.0f;

      break;
    }
    case metil_direction_left: {
      metil_mesh->vertices[
        index_vertex_last
      ].x = -size_half.x;

      metil_mesh->vertices[
        index_vertex_last
      ].y = 0.0f;

      metil_mesh->vertices[
        index_vertex_last
      ].z = 0.0f;

      break;
    }
    case metil_direction_right: {
      metil_mesh->vertices[
        index_vertex_last
      ].x = size_half.x;

      metil_mesh->vertices[
        index_vertex_last
      ].y = 0.0f;

      metil_mesh->vertices[
        index_vertex_last
      ].z = 0.0f;

      break;
    }
    case metil_direction_forwards: {
      metil_mesh->vertices[
        index_vertex_last
      ].x = 0.0f;

      metil_mesh->vertices[
        index_vertex_last
      ].y = 0.0f;

      metil_mesh->vertices[
        index_vertex_last
      ].z = size_half.z;

      break;
    }
    case metil_direction_backwards: {
      metil_mesh->vertices[
        index_vertex_last
      ].x = 0.0f;

      metil_mesh->vertices[
        index_vertex_last
      ].y = 0.0f;

      metil_mesh->vertices[
        index_vertex_last
      ].z = -size_half.z;

      break;
    }
  }

  metil_mesh->vertices[
    index_vertex_last
  ].w = 1.0f;

  for (
    unsigned int index_segment_x = 0;
    index_segment_x < segments.x;
    ++index_segment_x
  ) {
    metil_mesh->indices[
      index_index
    ] = (
      index_vertex_last
    );

    index_index = (
      index_index +
      1
    );

    metil_mesh->indices[
      index_index
    ] = (
      index_vertex_last -
      index_segment_x -
      1
    );

    index_index = (
      index_index +
      1
    );

    if (
      index_segment_x == (
        segments.x -
        1
      )
    ) {
      metil_mesh->indices[
        index_index
      ] = (
        index_vertex_last -
        1
      );
    } else {
      metil_mesh->indices[
        index_index
      ] = (
        index_vertex_last -
        index_segment_x -
        2
      );
    }

    index_index = (
      index_index +
      1
    );
  }
}
