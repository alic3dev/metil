#include <metil_metal/metil_metal_data_vertex.h>

#include <metal_texture>

[[vertex]] struct data_vertex_basic_textured_coloured metil_indirect_rendering_vertex(
  unsigned int index_vertex [[
    vertex_id
  ]]
) {
  struct data_vertex_basic_textured_coloured data_vertex_basic_textured_coloured;

  switch (
    index_vertex
  ) {
    case 0x00: {
      data_vertex_basic_textured_coloured.position = (
        float4(
          -0x01,
          -0x01,
          0x00,
          0x01
        )
      );

      data_vertex_basic_textured_coloured.position_texture = (
        float2(
          0x00,
          0x01
        )
      );

      break;
    }
    case 0x01: {
      data_vertex_basic_textured_coloured.position = (
        float4(
          0x01,
          -0x01,
          0x00,
          0x01
        )
      );

      data_vertex_basic_textured_coloured.position_texture = (
        float2(
          0x01,
          0x01
        )
      );

      break;
    }
    case 0x02: {
      data_vertex_basic_textured_coloured.position = (
        float4(
          -0x01,
          0x01,
          0x00,
          0x01
        )
      );

      data_vertex_basic_textured_coloured.position_texture = (
        float2(
          0x00,
          0x00
        )
      );

      break;
    }
    case 0x03: {
      data_vertex_basic_textured_coloured.position = (
        float4(
          0x01,
          0x01,
          0x00,
          0x01
        )
      );

      data_vertex_basic_textured_coloured.position_texture = (
        float2(
          0x01,
          0x00
        )
      );

      break;
    }
  }

  return (
    data_vertex_basic_textured_coloured
  );
}

[[fragment]] float4 metil_indirect_rendering_fragment(
  data_vertex_basic_textured_coloured data_vertex_basic_textured_coloured [[
    stage_in
  ]],
  metal::texture2d<float> texture [[
    texture(
      0x00
    )
  ]]
) {
  constexpr metal::sampler sampler_texture(
    metal::filter::linear,
    metal::mip_filter::linear
  );

  return (
    texture.sample(
      sampler_texture,
      data_vertex_basic_textured_coloured.position_texture
    )
  );
}

