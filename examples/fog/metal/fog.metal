#include <example_fog_values.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

struct data_vertex {
  float4 position [[position]];
  float4 color;
  float brightness;
};

[[vertex]] struct data_vertex fog_vertex(
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

  data_vertex.color = float4(
    data_object->color.x,
    data_object->color.y,
    data_object->color.z,
    data_object->color.w
  );

  data_vertex.brightness = data_frame->brightness;

  return data_vertex;
}

[[fragment]] float4 fog_fragment(
  struct data_vertex data_vertex [[stage_in]]
) {
  return float4(
    data_vertex.color.r * data_vertex.brightness,
    data_vertex.color.g * data_vertex.brightness,
    data_vertex.color.b * data_vertex.brightness,
    data_vertex.color.a
  );
}
