#include <metil_mesh/metil_mesh_2d/metil_mesh_grid.h>

#include <metil_mesh/metil_mesh.h>

#include <clic3_memory.h>

#include <math_c_vector.h>

void metil_mesh_celled_grid_initialize(
  struct metil_mesh* metil_mesh,
  struct math_c_vector2_float size,
  struct math_c_vector2_unsigned_long_int cells
) {
  struct math_c_vector2_float size_cell = {
    .x = (
      size.x /
      cells.x
    ),
    .y = (
      size.y /
      cells.y
    )
  };

  struct math_c_vector2_float size_half = {
    .x = (
      size.x /
      2.0f
    ),
    .y = (
      size.y /
      2.0f
    )
  };

  unsigned long int total_cells = (
    cells.x *
    cells.y
  );

  metil_mesh_initialize_with_lengths(
    metil_mesh,
    (
      (
        cells.x +
        0x01
      ) *
      (
        cells.y +
        0x01
      )
    ),
    (
      total_cells *
      0x04 +
      cells.y *
      0x02 +
      cells.x *
      0x02
    )
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

  unsigned long int index_index = (
    0x00
  );

  unsigned long int index_vertex = (
    0x00
  );

  for (
    unsigned int index_y = 0;
    index_y <= cells.y;
    ++index_y
  ) {
    for (
      unsigned int index_x = 0;
      index_x <= cells.x;
      ++index_x
    ) {
      metil_mesh->vertices[
        index_vertex
      ].x = (
        size_cell.x *
        index_x -
        size_half.x
      );

      metil_mesh->vertices[
        index_vertex
      ].y = (
        size_half.y -
        size_cell.y *
        index_y
      );

      metil_mesh->vertices[
        index_vertex
      ].z = (
        0.0f
      );

      metil_mesh->vertices[
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
    unsigned int index_y = 0;
    index_y < cells.y;
    ++index_y
  ) {
    for (
      unsigned int index_x = 0;
      index_x < cells.x;
      ++index_x
    ) {
      unsigned int index_vertex = (
        index_y *
        (
          cells.x +
          1
        ) +
        index_x
      );

      metil_mesh->indices[
        index_index
      ] = (
        index_vertex
      );

      metil_mesh->indices[
        index_index +
        1
      ] = (
        index_vertex +
        1
      );

      metil_mesh->indices[
        index_index +
        2
      ] = (
        index_vertex
      );

      metil_mesh->indices[
        index_index +
        3
      ] = (
        index_vertex +
        cells.x +
        1
      );

      index_index = (
        index_index +
        4
      );

      if (
        index_x ==
        (
          cells.x -
          1
        )
      ) {
        metil_mesh->indices[
          index_index
        ] = (
          index_vertex +
          1
        );

        metil_mesh->indices[
          index_index +
          1
        ] = (
          index_vertex +
          cells.x +
          2
        );

        index_index = (
          index_index +
          2
        );
      }
    }

    if (
      index_y ==
      (
        cells.y -
        1
      )
    ) {
      for (
        unsigned int index_x = 0;
        index_x < cells.x;
        ++index_x
      ) {
        unsigned int index_vertex = (
          index_y *
          (
            cells.x +
            1
          ) +
          (
            cells.x +
            1
          ) +
          index_x
        );

        metil_mesh->indices[
          index_index
        ] = (
          index_vertex
        );

        metil_mesh->indices[
          index_index +
          1
        ] = (
          index_vertex +
          1
        );

        index_index = (
          index_index +
          2
        );
      }
    }
  }
}

void metil_mesh_celled_triangles_grid_initialize(
  struct metil_mesh* metil_mesh,
  struct math_c_vector2_float size,
  struct math_c_vector2_unsigned_long_int cells
) {
  struct math_c_vector2_float size_cell = {
    .x = (
      size.x /
      cells.x
    ),
    .y = (
      size.y /
      cells.y
    )
  };

  struct math_c_vector2_float size_half = {
    .x = (
      size.x /
      2.0f
    ),
    .y = (
      size.y /
      2.0f
    )
  };

  metil_mesh_initialize_with_lengths(
    metil_mesh,
    (
      (
        cells.x +
        0x01
      ) *
      (
        cells.y +
        0x01
      )
    ),
    (      cells.x *
      cells.y *
      0x06
    )
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

  unsigned long int index_index = (
    0x00
  );

  unsigned long int index_vertex = (
    0x00
  );

  for (
    unsigned int index_y = 0;
    index_y <= cells.y;
    ++index_y
  ) {
    for (
      unsigned int index_x = 0;
      index_x <= cells.x;
      ++index_x
    ) {
      metil_mesh->vertices[
        index_vertex
      ].x = (
        size_cell.x *
        index_x -
        size_half.x
      );

      metil_mesh->vertices[
        index_vertex
      ].y = (
        size_half.y -
        size_cell.y *
        index_y
      );

      metil_mesh->vertices[
        index_vertex
      ].z = (
        0.0f
      );

      metil_mesh->vertices[
        index_vertex
      ].w = (
        1.0f
      );

      if (
        index_x <
        cells.x &&
        index_y <
        cells.y
      ) {
        metil_mesh->indices[
          index_index
        ] = (
          index_vertex
        );

        metil_mesh->indices[
          index_index +
          1
        ] = (
          index_vertex +
          1
        );

        metil_mesh->indices[
          index_index +
          2
        ] = (
          index_vertex +
          cells.x +
          1
        );

        metil_mesh->indices[
          index_index +
          3
        ] = (
          index_vertex +
          cells.x +
          1
        );

        metil_mesh->indices[
          index_index +
          4
        ] = (
          index_vertex +
          cells.x +
          2
        );

        metil_mesh->indices[
          index_index +
          5
        ] = (
          index_vertex +
          1
        );

        index_index = (
          index_index +
          6
        );
      }

      index_vertex = (
        index_vertex +
        1
      );
    }
  }
}

void metil_mesh_celled_triangles_quadruple_grid_initialize(
  struct metil_mesh* metil_mesh,
  struct math_c_vector2_float size,
  struct math_c_vector2_unsigned_long_int cells
) {
  struct math_c_vector2_float size_cell = {
    .x = (
      size.x /
      (float)
      cells.x
    ),
    .y = (
      size.y /
      (float)
      cells.y
    )
  };

  struct math_c_vector2_float size_half = {
    .x = (
      size.x /
      0x02
    ),
    .y = (
      size.y /
      0x02
    )
  };

  struct math_c_vector2_float size_cell_half = {
    .x = (
      size_cell.x /
      0x02
    ),
    .y = (
      size_cell.y /
      0x02
    )
  };

  metil_mesh_initialize_with_lengths(
    metil_mesh,
    (
      (
        cells.x +
        0x01
      ) *
      (
        cells.y +
        0x01
      ) +
      (
        cells.x *
        cells.y
      )
    ),
    (      cells.x *
      cells.y *
      0x0c
    )
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

  unsigned long int index_index = (
    0x00
  );

  unsigned long int index_vertex = (
    0x00
  );

  for (
    unsigned long int index_y = 0;
    index_y <= cells.y;
    ++index_y
  ) {
    for (
      unsigned long int index_x = 0;
      index_x <= cells.x;
      ++index_x
    ) {
      metil_mesh->vertices[
        index_vertex
      ].x = (
        size_cell.x *
        index_x -
        size_half.x
      );

      metil_mesh->vertices[
        index_vertex
      ].y = (
        size_half.y -
        size_cell.y *
        index_y
      );

      metil_mesh->vertices[
        index_vertex
      ].z = (
        0.0f
      );

      metil_mesh->vertices[
        index_vertex
      ].w = (
        1.0f
      );

      if (
        index_x <
        cells.x &&
        index_y <
        cells.y
      ) {
        metil_mesh->vertices[
          index_vertex +
          1
        ].x = (
          size_cell.x *
          index_x -
          size_half.x +
          size_cell_half.x
        );

        metil_mesh->vertices[
          index_vertex +
          1
        ].y = (
          size_half.y -
          size_cell.y *
          index_y -
          size_cell_half.y
        );

        metil_mesh->vertices[
          index_vertex +
          1
        ].z = (
          0.0f
        );

        metil_mesh->vertices[
          index_vertex +
          1
        ].w = (
          1.0f
        );

        metil_mesh->indices[
          index_index
        ] = (
          index_vertex
        );

        metil_mesh->indices[
          index_index +
          1
        ] = (
          index_vertex +
          1
        );

        metil_mesh->indices[
          index_index +
          2
        ] = (
          index_vertex +
          2
        );

        metil_mesh->indices[
          index_index +
          3
        ] = (
          index_vertex +
          2
        );

        metil_mesh->indices[
          index_index +
          4
        ] = (
          index_vertex +
          1
        );

        if (
          index_y <
          (
            cells.y -
            1
          )
        ) {
          metil_mesh->indices[
            index_index +
            5
          ] = (
            index_vertex +
            (
              cells.x *
              2
            ) +
            3
          );

          metil_mesh->indices[
            index_index +
            6
          ] = (
            index_vertex +
            (
              cells.x *
              2
            ) +
            3
          );

          metil_mesh->indices[
            index_index +
            7
          ] = (
            index_vertex +
            1
          );

          metil_mesh->indices[
            index_index +
            8
          ] = (
            index_vertex +
            (
              cells.x *
              2
            ) +
            1
          );

          metil_mesh->indices[
            index_index +
            9
          ] = (
            index_vertex +
            (
              cells.x *
              2
            ) +
            1
          );

          metil_mesh->indices[
            index_index +
            10
          ] = (
            index_vertex +
            1
          );

          metil_mesh->indices[
            index_index +
            11
          ] = (
            index_vertex
          );
        } else {
           metil_mesh->indices[
            index_index +
            5
          ] = (
            metil_mesh->length_vertices -
            cells.x +
            index_x
          );

          metil_mesh->indices[
            index_index +
            6
          ] = (
            metil_mesh->length_vertices -
            cells.x +
            index_x
          );

          metil_mesh->indices[
            index_index +
            7
          ] = (
            index_vertex +
            1
          );

          metil_mesh->indices[
            index_index +
            8
          ] = (
            metil_mesh->length_vertices -
            cells.x +
            index_x -
            1
          );

          metil_mesh->indices[
            index_index +
            9
          ] = (
            metil_mesh->length_vertices -
            cells.x +
            index_x -
            1
          );

          metil_mesh->indices[
            index_index +
            10
          ] = (
            index_vertex +
            1
          );

          metil_mesh->indices[
            index_index +
            11
          ] = (
            index_vertex
          );
        }

        index_index = (
          index_index +
          12
        );

        index_vertex = (
          index_vertex +
          2
        );
      } else {
        index_vertex = (
          index_vertex +
          1
        );
      }
    }
  }
}

void metil_mesh_celled_individual_triangles_grid_initialize(
  struct metil_mesh* metil_mesh,
  struct math_c_vector2_float size,
  struct math_c_vector2_unsigned_long_int cells
) {
  struct math_c_vector2_float size_cell = {
    .x = (
      size.x /
      cells.x
    ),
    .y = (
      size.y /
      cells.y
    )
  };

  struct math_c_vector2_float size_half = {
    .x = (
      size.x /
      0x02
    ),
    .y = (
      size.y /
      0x02
    )
  };

  unsigned long int total_cells = (
    cells.x *
    cells.y
  );

  metil_mesh_initialize_with_lengths(
    metil_mesh,
    (
      total_cells *
      0x04
    ),
    (
      total_cells *
      0x06
    )
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
  unsigned long int index_index = (
    0x00
  );

  unsigned long int index_vertex = (
    0x00
  );

  for (
    unsigned int index_y = 0;
    index_y < cells.y;
    ++index_y
  ) {
    for (
      unsigned int index_x = 0;
      index_x < cells.x;
      ++index_x
    ) {
      metil_mesh->vertices[
        index_vertex
      ].x = (
        size_cell.x *
        index_x -
        size_half.x
      );

      metil_mesh->vertices[
        index_vertex
      ].y = (
        size_half.y -
        size_cell.y *
        index_y
      );

      metil_mesh->vertices[
        index_vertex
      ].z = (
        0.0f
      );

      metil_mesh->vertices[
        index_vertex
      ].w = (
        1.0f
      );

      metil_mesh->vertices[
        index_vertex +
        1
      ].x = (
        size_cell.x *
        (
          index_x +
          1
        ) -
        size_half.x
      );

      metil_mesh->vertices[
        index_vertex +
        1
      ].y = (
        size_half.y -
        size_cell.y *
        index_y
      );

      metil_mesh->vertices[
        index_vertex +
        1
      ].z = (
        0.0f
      );

      metil_mesh->vertices[
        index_vertex +
        1
      ].w = (
        1.0f
      );

      metil_mesh->vertices[
        index_vertex +
        2
      ].x = (
        size_cell.x *
        index_x -
        size_half.x
      );

      metil_mesh->vertices[
        index_vertex +
        2
      ].y = (
        size_half.y -
        size_cell.y *
        (
          index_y +
          1
        )
      );

      metil_mesh->vertices[
        index_vertex +
        2
      ].z = (
        0.0f
      );

      metil_mesh->vertices[
        index_vertex +
        2
      ].w = (
        1.0f
      );

      metil_mesh->vertices[
        index_vertex +
        3
      ].x = (
        size_cell.x *
        (
          index_x +
          1
        ) -
        size_half.x
      );

      metil_mesh->vertices[
        index_vertex +
        3
      ].y = (
        size_half.y -
        size_cell.y *
        (
          index_y +
          1
        )
      );

      metil_mesh->vertices[
        index_vertex +
        3
      ].z = (
        0.0f
      );

      metil_mesh->vertices[
        index_vertex +
        3
      ].w = (
        1.0f
      );

      index_vertex = (
        index_vertex +
        4
      );
    }
  }

  for (
    unsigned int index_cell = 0;
    index_cell < total_cells;
    ++index_cell
  ) {
    unsigned int index_vertex = (
      index_cell *
      4
    );

    metil_mesh->indices[
      index_index
    ] = (
      index_vertex
    );

    metil_mesh->indices[
      index_index +
      1
    ] = (
      index_vertex +
      1
    );

    metil_mesh->indices[
      index_index +
      2
    ] = (
      index_vertex +
      2
    );

    metil_mesh->indices[
      index_index +
      3
    ] = (
      index_vertex +
      2
    );

    metil_mesh->indices[
      index_index +
      4
    ] = (
      index_vertex +
      1
    );

    metil_mesh->indices[
      index_index +
      5
    ] = (
      index_vertex +
      3
    );

    index_index = (
      index_index +
      6
    );
  }
}
