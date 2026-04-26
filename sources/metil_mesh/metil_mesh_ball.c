#include <metil_mesh/metil_mesh_ball.h>

#include <metil_mesh/metil_mesh.h>

#include <clic3_memory.h>

#include <math_c_pi.h>
#include <math_c_sine.h>
#include <math_c_vector.h>

void metil_mesh_ball_initialize(
  struct metil_mesh* metil_mesh,
  float diameter,
  struct math_c_vector2_unsigned_short_int segments
) {
  metil_mesh_initialize_with_lengths(
    metil_mesh,
    (
      segments.x *
      segments.y +
      0x02
    ),
    (
      0x06 *
      segments.x +
      (
        segments.x *
        (
          segments.y -
          0x01
        ) *
        0x06
      )
    )
  );

  metil_mesh->size.x = (
    diameter
  );

  metil_mesh->size.y = (
    diameter
  );

  metil_mesh->size.z = (
    diameter
  );

  float radius = (
    diameter /
    2.0f
  );

  metil_mesh->vertices[0].x = 0.0f;
  metil_mesh->vertices[0].y = radius;
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
    math_c_pi_doubled
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
      math_c_sine(
        percentage_radius *
        math_c_pi,
        math_c_pi
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
        math_c_pi
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
        math_c_pi_doubled
      );

      float radius_segment = (
        math_c_sine(
          angle.y,
          math_c_pi
        ) *
        radius
      );

      unsigned int index_vertex = (
        index_vertex_offset_y +
        index_segment_x +
        1
      );

      metil_mesh->vertices[
        index_vertex
      ].x = (
        math_c_cosine(
          angle.x,
          math_c_pi
        ) *
        radius_segment
      );

      metil_mesh->vertices[
        index_vertex
      ].y = (
        math_c_cosine(
          angle.y,
          math_c_pi
        ) *
        radius
      );

      metil_mesh->vertices[
        index_vertex
      ].z = (
        math_c_sine(
          angle.x,
          math_c_pi
        ) *
        radius_segment
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
  ].y = -radius;

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
