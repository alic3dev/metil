#include <example_face_renderer_data_object.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

struct data_vertex {
  float4 position [[
    position
  ]];
  float point_size [[
    point_size
  ]];
  float4 colour;
};

[[vertex]] struct data_vertex face_points_vertex(
  const device simd_float4* vertices [[
    buffer(
      metil_renderer_vertex_index_parameter_vertices
    )
  ]],
  constant struct metil_renderer_data_frame* data_frame [[
    buffer(
      metil_renderer_vertex_index_parameter_data_frame
    )
  ]],
  constant struct example_face_renderer_data_object* data_object [[
    buffer(
      metil_renderer_vertex_index_parameter_data_object
    )
  ]],
  unsigned int index_vertex [[
    vertex_id
  ]]
) {
  struct data_vertex data_vertex;

  data_vertex.position = (
    (
      data_object->view_model_matrix_projection +
      (metal::float4x4) {{
        { 0x00, 0x00, 0x00, 0x00 },
        { 0x00, 0x00, 0x00, 0x00 },
        { 0x00, 0x00, 0x00, 0x00 },
        { 0x00, 0x00, 0.5f, 0x00 }
      }}
    ) *
    vertices[
      index_vertex
    ]
  );

  if (
    (
      index_vertex +
      0x01
    ) ==
    data_object->vertex_held
  ) {
    data_vertex.colour = float4(
      0x00,
      0x00,
      0x01,
      0x01
    );

    data_vertex.point_size = (
      0x02
    );
  } else if (
    (
      index_vertex +
      0x01
    ) ==
    data_object->vertex_hovered
  ) {
    data_vertex.colour = float4(
      0x01,
      0x00,
      0x01,
      0x01
    );

    data_vertex.point_size = (
      0x0a
    );
  } else {
    data_vertex.colour = float4(
      0x01,
      0x01,
      0x01,
      0x01
    );

    data_vertex.point_size = (
      0x05
    );
  }

  return (
    data_vertex
  );
}

[[fragment]] float4 face_points_fragment(
  struct data_vertex data_vertex [[
    stage_in
  ]]
) {
  return (
    data_vertex.colour
  );
}
