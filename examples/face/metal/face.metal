#include <example_face_renderer_data_object.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

struct data_vertex {
  float4 position [[
    position
  ]];
  float4 colour;
};

[[vertex]] struct data_vertex face_vertex(
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

  float brightness = (
    0x01 -
    (
      (
        vertices[
          index_vertex
        ].z +
        0.2f
      ) /
      0.5f
    )
  );

  data_vertex.colour = float4(
    (
      0x01 *
      brightness
    ),
    (
      0.98f *
      brightness
    ),
    (
      0.9f *
      brightness
    ),
    0x01
  );

  return (
    data_vertex
  );
}

[[fragment]] float4 face_fragment(
  struct data_vertex data_vertex [[stage_in]]
) {
  return (
    data_vertex.colour
  );
}
