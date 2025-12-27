#include <example_face_renderer_data_object.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

struct data_vertex {
  float4 position [[position]];
  float4 color;
};

[[vertex]] struct data_vertex face_vertex(
  const device simd_float4* positions [[
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
    positions[id_vertex]
  );

  float brightness = 1.0f - ((
    positions[id_vertex].z +
    0.2
  ) / 0.5f);

  data_vertex.color = float4(
    1.0f * brightness,
    0.98f * brightness,
    0.9f * brightness,
    1.0f
  );

  return data_vertex;
}

[[fragment]] float4 face_fragment(
  struct data_vertex data_vertex [[stage_in]]
) {
  return data_vertex.color;
}
