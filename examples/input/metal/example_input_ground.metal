#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>
#include <metil_rendering/metil_renderer_data_object.h>

struct data_vertex {
  float4 position [[position]];
  float4 colour;
};

[[vertex]] struct data_vertex example_input_ground_vertex(
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
  unsigned int index_vertex [[vertex_id]]
) {
  struct data_vertex data_vertex;

  data_vertex.position = (
    data_object->view_model_matrix_projection *
    vertices[
      index_vertex
    ]
  );

  float offset = (
    (float)
    index_vertex /
    10.0f
  );

  data_vertex.colour = float4(
    metal::fmod(
      (
        data_object->colour.x +
        offset *
        0x04
      ),
      0x01
    ),
    metal::fmod(
      (
        data_object->colour.y +
        offset *
        0x02
      ),
      0x01
    ),
    metal::fmod(
      (
        data_object->colour.z +
        offset
      ),
      0x01
    ),
    data_object->colour.w
  );

  return (
    data_vertex
  );
}

[[fragment]] float4 example_input_ground_fragment(
  struct data_vertex data_vertex [[stage_in]]
) {
  return (
    data_vertex.colour
  );
}
