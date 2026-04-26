#include <metil_mesh/metil_mesh.h>

#include <clic3_memory.h>

#include <math_c_pi.h>
#include <math_c_sine.h>
#include <math_c_vector.h>

void metil_mesh_ring_initialize(
  struct metil_mesh* metil_mesh_ring,
  struct math_c_vector3_float size_outer,
  struct math_c_vector3_float size_inner,
  struct math_c_vector2_unsigned_short_int segments
) {
  metil_mesh_initialize_with_lengths(
    metil_mesh_ring,
    (
      segments.x *
      segments.y
    ),
    (
      segments.x *
      segments.y *
      0x06
    )
  );

  if (
    size_outer.x <
    size_inner.x
  ) {
    float size_x_hold = (
      size_outer.x
    );

    size_outer.x = (
      size_inner.x
    );

    size_inner.x = (
      size_x_hold
    );
  }

  if (
    size_outer.z <
    size_inner.z
  ) {
    float size_z_hold = (
      size_outer.z
    );

    size_outer.z = (
      size_inner.z
    );

    size_inner.z = (
      size_z_hold
    );
  }

  metil_mesh_ring->size.x = (
    size_outer.x
  );

  metil_mesh_ring->size.y = (
    size_outer.y
  );

  metil_mesh_ring->size.z = (
    size_outer.z
  );

  struct math_c_vector3_float size_outer_halved = {
    .x = (
      size_outer.x /
      2.0f
    ),
    .y = (
      size_outer.y /
      2.0f
    ),
    .z = (
      size_outer.z /
      2.0f
    )
  };

  struct math_c_vector3_float size_inner_halved = {
    .x = (
      size_inner.x /
      2.0f
    ),
    .y = (
      size_inner.y /
      2.0f
    ),
    .z = (
      size_inner.z /
      2.0f
    )
  };

  struct math_c_vector3_float size_difference_halved = {
    .x = (
      (
        size_outer_halved.x -
        size_inner_halved.x
      ) /
      2.0f
    ),
    .y = (
      (
        size_outer_halved.y -
        size_inner_halved.y
      ) /
      2.0f
    ),
    .z = (
      (
        size_outer_halved.z -
        size_inner_halved.z
      ) /
      2.0f
    )
  };

  struct math_c_vector3_float size_midpoint = {
    .x = (
      size_difference_halved.x +
      size_inner_halved.x
    ),
    .y = (
      size_difference_halved.y +
      size_inner_halved.y
    ),
    .z = (
      size_difference_halved.z +
      size_inner_halved.z
    ),
  };

  unsigned int index_vertex = (
    0x00
  );
  
  unsigned int index_index = (
    0x00
  );

  for (
    unsigned short int index_segment_x = 0;
    index_segment_x < segments.x;
    ++index_segment_x
  ) {
    float angle = (
      (float) index_segment_x /
      (float) segments.x *
      math_c_pi_doubled
    );

    float rotation = (
      math_c_sine(
        angle,
        math_c_pi
      )
    );

    float rotation_negation;

    if (
      rotation < 0.0f
    ) {
      rotation_negation = (
        -1.0f -
        rotation
      );
    } else {
      rotation_negation = (
        1.0f -
        rotation
      );
    }

    struct math_c_vector2_float angles = {
      .x = (
        math_c_sine(
          angle,
          math_c_pi
        )
      ),
      .y = (
        math_c_cosine(
          angle,
          math_c_pi
        )
      )
    };

    struct math_c_vector2_float position_segment = {
      .x = (
        angles.x *
        size_midpoint.x
      ),
      .y = (
        angles.y *
        size_midpoint.z
      )
    };

    for (
      unsigned short int index_segment_y = 0;
      index_segment_y < segments.y;
      ++index_segment_y
    ) {
      float angle_y = (
        (float) index_segment_y /
        (float) segments.y *
        math_c_pi_doubled
      );

      float value = (
        math_c_sine(
          angle_y,
          math_c_pi
        )
      );

      metil_mesh_ring->vertices[
        index_vertex
      ].x = (
        position_segment.x +
        value *
        angles.x *
        size_difference_halved.x
      );

      metil_mesh_ring->vertices[
        index_vertex
      ].y = (
        math_c_cosine(
          angle_y,
          math_c_pi
        ) *
        size_outer_halved.y
      );

      metil_mesh_ring->vertices[
        index_vertex
      ].z = (
        position_segment.y +
        value *
        angles.y *
        size_difference_halved.z
      );

      metil_mesh_ring->vertices[
        index_vertex
      ].w = (
        1.0f
      );

      index_vertex = (
        index_vertex +
        1
      );
    }
  }

  for (
    unsigned int index_segment = 0;
    index_segment < segments.x;
    ++index_segment
  ) {
    unsigned int offset_vertex = (
      index_segment *
      segments.y
    );

    unsigned int offset_vertex_next = (
      index_segment +
      1
    );

    if (
      index_segment == (
        segments.x -
        1
      )
    ) {
      offset_vertex_next = 0;
    } else {
      offset_vertex_next = (
        offset_vertex_next *
        segments.y
      );
    }

    for (
      unsigned int index_segment_y = 0;
      index_segment_y < segments.y;
      ++index_segment_y
    ) {
      metil_mesh_ring->indices[
        index_index
      ] = (
        offset_vertex +
        index_segment_y
      );

      if (
        index_segment_y == (
          segments.y -
          1
        )
      ) {
        metil_mesh_ring->indices[
          index_index +
          1
        ] = (
          offset_vertex
        );

        metil_mesh_ring->indices[
          index_index +
          4
        ] = (
          offset_vertex_next
        );
      } else {
        metil_mesh_ring->indices[
          index_index +
          1
        ] = (
          offset_vertex +
          index_segment_y +
          1
        );

        metil_mesh_ring->indices[
          index_index +
          4
        ] = (
          offset_vertex_next +
          index_segment_y +
          1
        );
      }

      metil_mesh_ring->indices[
        index_index +
        2
      ] = (
        offset_vertex_next +
        index_segment_y
      );

      metil_mesh_ring->indices[
        index_index +
        3
      ] = (
        metil_mesh_ring->indices[
          index_index +
          1
        ]
      );

      metil_mesh_ring->indices[
        index_index +
        5
      ] = (
        metil_mesh_ring->indices[
          index_index +
          2
        ]
      );

      index_index = (
        index_index +
        6
      );
    }
  }
}
