#include <metil_metal/basic_3d_shaders.h>

#include <metil_metal/metil_metal_data_vertex.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_texture>

[[vertex]] struct data_vertex_basic_textured_coloured example_3d_rendering_ground_vertex(
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
  struct data_vertex_basic_textured_coloured data_vertex_basic_coloured;

  data_vertex_basic_coloured.position = (
    data_object->view_model_matrix_projection *
    vertices[
      index_vertex
    ]
  );

  float colour_max = (
    0.5f *
    (float)
    (
      index_vertex %
      0x0a
    ) /
    0x09 +
    0.05f +
    (float)
    (
      index_vertex %
      0x0f
    ) /
    0x0e *
    0.05f
  );

  colour_max = (
    colour_max *
    0.75f
  );

  data_vertex_basic_coloured.colour = (
    float4(
      (
        data_frame->brightness *
        colour_max *
        data_object->colour.x *
        0.25f
      ),
      (
        data_frame->brightness *
        colour_max *
        data_object->colour.y *
        0.5f
      ),
      (
        data_frame->brightness *
        colour_max *
        data_object->colour.z *
        0.3f
      ),
      data_object->colour.w
    )
  );

  data_vertex_basic_coloured.position_texture.x = (
    vertices[
      index_vertex
    ].x
  );

  data_vertex_basic_coloured.position_texture.y = (
    vertices[
      index_vertex
    ].y
  );

  return data_vertex_basic_coloured;
}

[[fragment]] float4 example_3d_rendering_ground_fragment(
  struct data_vertex_basic_textured_coloured data_vertex_basic_coloured [[stage_in]],
  metal::texture2d<float> texture [[texture(0)]]
) {
  constexpr metal::sampler sampler_texture(
    metal::t_address::repeat,
    metal::r_address::repeat,
    metal::s_address::repeat
);

  return (
    data_vertex_basic_coloured.colour *
    texture.sample(
      sampler_texture,
      (
        data_vertex_basic_coloured.position_texture /
        1000.0f
      )
    )
  );
}
