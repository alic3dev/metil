#include <metil_mesh/metil_mesh_ball.h>

#include <metil_mesh/metil_mesh.h>

#include <math_c_vector.h>

#include <math.h>
#include <stdio.h>
#include <stdlib.h>

void metil_mesh_ball_initialize(
  struct metil_mesh* metil_mesh,
  float size,
  struct math_c_vector2_unsigned_short_int segments
) {
  metil_mesh_initialize(
    metil_mesh
  );

  metil_mesh->size.x = size;
  metil_mesh->size.y = size;
  metil_mesh->size.z = size;

  float size_half = (
    size /
    2.0f
  );

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

  metil_mesh->vertices[0].x = 0.0f;
  metil_mesh->vertices[0].y = size_half;
  metil_mesh->vertices[0].z = 0.0f;
  metil_mesh->vertices[0].w = 1.0f;

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
      ((
        index_segment_x +
        1
      ) %
      segments.x) +
      1
    );

    index_index = (
      index_index +
      1
    );
  }

  float offset_y = (
    1.0f /
    (float) (
      segments.y +
      1
    ) *
    M_PI *
    2.0f
  );

  for (
    unsigned int index_segment_y = 0;
    index_segment_y < segments.y;
    ++index_segment_y
  ) {
    unsigned int index_vertex_offset_y = (
      index_segment_y *
      segments.x
    );

    float percentage_radius = 0.0f;

    if (
      segments.y % 2 == 0
    ) {
      if (
        index_segment_y == segments.y / 2 ||
        index_segment_y + 1 == segments.y / 2
      ) {
        percentage_radius = 0.5f;
      } else if (
        index_segment_y > segments.y / 2
      ) {
        percentage_radius = (
          (float) index_segment_y /
          (float) segments.y
        );
      } else {
        percentage_radius = (
          (float) index_segment_y /
          (float) (
            segments.y -
            1
          )
        );
      }
    } else {
      percentage_radius = (
        (float) index_segment_y /
        (float) (
          segments.y -
          1
        )
      );
    }

    percentage_radius = (
      (float) index_segment_y /
      (float) (
        segments.y -
        1
      )
    );

    percentage_radius = (
      sin(
        percentage_radius *
        M_PI
      )
    );

    struct math_c_vector2_float angle = {
      .x = (
        0.0f
      ),
      .y = (
        (float) (
          index_segment_y +
          1
        ) /
        (float) (
          segments.y +
          1
        ) *
        M_PI
      )
    };

    for (
      unsigned int index_segment_x = 0;
      index_segment_x < segments.x;
      ++index_segment_x
    ) {
      angle.x = (
        (float) index_segment_x /
        (float) segments.x *
        M_PI *
        2.0f
      );

      float radius = (
        sin(
          angle.y
        ) *
        size_half
      );

      unsigned int index_vertex = (
        index_vertex_offset_y +
        index_segment_x +
        1
      );

      metil_mesh->vertices[
        index_vertex
      ].x = (
        cos(angle.x) *
        radius
      );

      metil_mesh->vertices[
        index_vertex
      ].y = (
        cos(angle.y) *
        size_half 
      //   + (
      //     cos(
      //   (float) (
          
      //     1
      //   ) /
      //   (float) (
      //     segments.y +
      //     2
      //   ) *
      //   M_PI *
      //   2.0f
      // ) * size_half
      //   )
      );

      metil_mesh->vertices[
        index_vertex
      ].z = (
        sin(angle.x) *
        radius
      );

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


      ////

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

  metil_mesh->vertices[
    index_vertex_last
  ].x = 0.0f;

  metil_mesh->vertices[
    index_vertex_last
  ].y = -size_half;

  metil_mesh->vertices[
    index_vertex_last
  ].z = 0.0f;

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
