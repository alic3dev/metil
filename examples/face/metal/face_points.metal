#include <example_face_renderer_data_object.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

struct data_vertex {
  float4 position [[position]];
  float point_size [[point_size]];
  float4 color;
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
  unsigned int id_vertex [[vertex_id]]
) {
  struct data_vertex data_vertex;

  data_vertex.position = (
    data_object->view_model_matrix_projection *
    vertices[id_vertex]
  );

  if (
    id_vertex + 1 == data_object->vertex_held
  ) {
    data_vertex.color = float4(
      0.0f,
      0.0f,
      1.0f,
      1.0f
    );

    data_vertex.point_size = 2.0f;
  } else if (
    id_vertex + 1 == data_object->vertex_hovered
  ) {
    data_vertex.color = float4(
      1.0f,
      0.0f,
      1.0f,
      1.0f
    );

    data_vertex.point_size = 10.0f;
  } else {
    data_vertex.color = float4(
      1.0f,
      1.0f,
      1.0f,
      1.0f
    );

    data_vertex.point_size = 5.0f;
  }

  return data_vertex;
}

[[fragment]] float4 face_points_fragment(
  struct data_vertex data_vertex [[stage_in]]
) {
  return data_vertex.color;
}
