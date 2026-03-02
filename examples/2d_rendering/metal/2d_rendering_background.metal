#include <metil_metal/metil_fps_display.h>

#include <metil_metal/metil_metal_data_vertex.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_stdlib>

[[vertex]] struct data_vertex_basic_textured_coloured metil_example_2d_rendering_background_vertex(
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
  struct data_vertex_basic_textured_coloured data_vertex_basic_textured_coloured;

  data_vertex_basic_textured_coloured.position_texture.x = (
    (
      id_vertex %
      2
    ) +
    data_frame->position_player.x /
    10.01f
  );

  data_vertex_basic_textured_coloured.position_texture.y = (
    id_vertex /
    2 -
    data_frame->position_player.y /
    10.01f
  );

  data_vertex_basic_textured_coloured.position = (
    data_object->view_model_matrix_projection *
    vertices[
      id_vertex
    ]
  );

  data_vertex_basic_textured_coloured.colour = (
    float4(
      data_object->colour.x,
      data_object->colour.y,
      data_object->colour.z,
      data_object->colour.w
    )
  );

  return (
    data_vertex_basic_textured_coloured
  );
}

[[fragment]] float4 metil_example_2d_rendering_background_fragment(
  data_vertex_basic_textured_coloured data_vertex_basic_textured_coloured [[stage_in]],
  metal::texture2d<half> texture [[texture(0)]]
) {
  constexpr metal::sampler sampler_texture(
    metal::address::repeat
  );

  float4 colour_texture = float4(
    texture.sample(
      sampler_texture,
      data_vertex_basic_textured_coloured.position_texture
    )
  );

  return float4(
    colour_texture[0] * data_vertex_basic_textured_coloured.colour.r,
    colour_texture[1] * data_vertex_basic_textured_coloured.colour.g,
    colour_texture[2] * data_vertex_basic_textured_coloured.colour.b,
    colour_texture[3] * data_vertex_basic_textured_coloured.colour.a
  );
}
