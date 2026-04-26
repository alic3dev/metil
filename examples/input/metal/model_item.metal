#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>
#include <metil_rendering/metil_renderer_data_object.h>

struct data_vertex {
  float4 position [[position]];
  float point_size [[point_size]];
  float4 colour;
};

[[vertex]] struct data_vertex model_item_vertex(
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
    vertices[id_vertex]
  );

  float offset = (
    (float) id_vertex /
    10.0f
  );

  data_vertex.colour = float4(
    metal::fmod(data_object->colour.x + offset * 4, 1.0f),
    metal::fmod(data_object->colour.y + offset * 2, 1.0f),
    metal::fmod(data_object->colour.z + offset, 1.0f),
    data_object->colour.w
  );

  return data_vertex;
}

[[fragment]] float4 model_item_fragment(
  struct data_vertex data_vertex [[stage_in]]
) {
  return data_vertex.colour;
}
