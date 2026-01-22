#include <metil_metal/metil_wireframe.h>

#include <metil_metal/metil_metal_data_vertex.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

[[vertex]] struct data_vertex_basic metil_wireframe_vertex(
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
  struct data_vertex_basic data_vertex_basic;

  data_vertex_basic.position = (
    data_object->view_model_matrix_projection *
    vertices[
      id_vertex
    ]
  );

  return (
    data_vertex_basic
  );
}

[[fragment]] float4 metil_wireframe_fragment() {
  return (
    float4(
      1.0f,
      1.0f,
      1.0f,
      1.0f
    )
  );
}
