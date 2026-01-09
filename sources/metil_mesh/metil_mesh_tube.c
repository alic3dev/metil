#include <metil_mesh/metil_mesh_tube.h>

#include <metil_mesh/metil_mesh.h>

#include <math_c_vector.h>

#include <math.h>
#include <stdlib.h>

void metil_mesh_tube_initialize(
  struct metil_mesh* metil_mesh,
  struct math_c_vector3_float size,
  struct math_c_vector2_unsigned_short_int segments
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

  unsigned char direction;

  float increment_y;

  if (
    metil_mesh->size.x > metil_mesh->size.y &&
    metil_mesh->size.x >= metil_mesh->size.z
  ) {
    increment_y = (
      size.x / (
        segments.y -
        1
      )
    );

    metil_mesh->vertices[0].x = -size_half.x;
    metil_mesh->vertices[0].y = 0.0f;
    metil_mesh->vertices[0].z = 0.0f;

    direction = 1;
  } else if (
    metil_mesh->size.z > metil_mesh->size.y &&
    metil_mesh->size.z >= metil_mesh->size.x
  ) {
    increment_y = (
      size.z / (
        segments.y -
        1
      )
    );

    metil_mesh->vertices[0].x = 0.0f;
    metil_mesh->vertices[0].y = 0.0f;
    metil_mesh->vertices[0].z = -size_half.z;

    direction = 2;
  } else {
    increment_y = (
      size.y / (
        segments.y -
        1
      )
    );

    metil_mesh->vertices[0].x = 0.0f;
    metil_mesh->vertices[0].y = -size_half.y;
    metil_mesh->vertices[0].z = 0.0f;
    
    direction = 0;
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
      case 0: {
        position_y = (
          increment_y * (
            index_segment_y
          ) -
          size_half.y
        );

        break;
      }
      case 1: {
        position_y = (
          increment_y * (
            index_segment_y
          ) -
          size_half.x
        );

        break;
      }
      case 2: {
        position_y = (
          increment_y * (
            index_segment_y
          ) -
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
        M_PI * 2.0f
      );

      switch (
        direction
      ) {
        case 0: {
          metil_mesh->vertices[
            index_vertex
          ].x = (
            sin(angle) *
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
            cos(angle) *
            size_half.z
          );

          break;
        }
        case 1: {
          metil_mesh->vertices[
            index_vertex
          ].y = (
            sin(angle) *
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
            cos(angle) *
            size_half.z
          );

          break;
        }
        case 2: {
          metil_mesh->vertices[
            index_vertex
          ].y = (
            sin(angle) *
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
            cos(angle) *
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
    case 0: {
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
    case 1: {
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
    case 2: {
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
