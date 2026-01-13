#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>
#include <metil_rendering/metil_renderer_data_object.h>

struct data_vertex {
  float4 position [[position]];
  float point_size [[point_size]];
  float4 color;
};

[[vertex]] struct data_vertex floor_vertex(
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
  constant struct metil_renderer_data_object* data_object [[
    buffer(
      metil_renderer_vertex_index_parameter_data_object
    )
  ]],
  unsigned int id_vertex [[vertex_id]]
) {
  struct data_vertex data_vertex;

  data_vertex.position = (
    data_object->view_model_matrix_projection *
    vertices[
      id_vertex
    ]
  );

  float multiplier = (
    metal::fmin(
      metal::fmax(
        ((float) id_vertex) - 3.0f,
        0.0f
      ),
      1.0f
    )
  );

  data_vertex.color = float4(
    data_object->color.x * multiplier,
    data_object->color.y * multiplier,
    data_object->color.z * multiplier,
    data_object->color.w
  );

  return data_vertex;
}

[[fragment]] float4 floor_fragment(
  struct data_vertex data_vertex [[stage_in]]
) {
  return data_vertex.color;
}
