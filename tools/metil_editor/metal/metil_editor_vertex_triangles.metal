#include <metil_metal/basic_3d_shaders.h>

#include <metil_metal/metil_metal_colours.h>
#include <metil_metal/metil_metal_data_vertex.h>
#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

[[vertex]] struct data_vertex_basic_coloured metil_editor_vertex_triangles_vertex(
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
  unsigned int index_vertex [[
    vertex_id
  ]]
) {
  struct data_vertex_basic_coloured data_vertex_basic_coloured;

  data_vertex_basic_coloured.position = (
    data_object->view_model_matrix_projection *
    vertices[
      index_vertex
    ]
  );

  data_vertex_basic_coloured.colour = (
    float4(
      data_object->colour.x,
      data_object->colour.y,
      data_object->colour.z,
      data_object->colour.w
    )
  );

  data_vertex_basic_coloured.brightness = (
    data_frame->brightness
  );

  return (
    data_vertex_basic_coloured
  );
}

[[fragment]] float4 metil_editor_vertex_triangles_fragment(
  struct data_vertex_basic_coloured data_vertex_basic_coloured [[
    stage_in
  ]]
) {
  metil_metal_colours_float4_brightness_apply(
    &data_vertex_basic_coloured.colour,
    data_vertex_basic_coloured.brightness
  );

  return (
    data_vertex_basic_coloured.colour
  );
}
