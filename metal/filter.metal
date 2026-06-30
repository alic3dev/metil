#include <metil_metal/metil_metal_data_vertex.h>

#include <metal_texture>

kernel void filter_compute(
  metal::texture2d<float, metal::access::read_write> texture [[
    texture(
      0x00
    )
  ]],
  unsigned int index[[
    thread_position_in_grid
  ]]
) {
  ushort2 l = (
    ushort2(
      index %
      texture.get_width()
    , index / texture.get_height())
  );

    texture.write(
      (
        texture.read(
          l
        ) *
        float4(0,1,1,1)
      ),
     l,
    0
  );
}

[[vertex]] struct data_vertex_basic_textured_coloured filter_vertex(
  unsigned int id_vertex [[vertex_id]]
) {
  struct data_vertex_basic_textured_coloured d;

  switch (
    id_vertex
  ) {
    case 0x00: {
      d.position = (
        float4(
          -1, -1, 0, 1
        )
      );
      
      d.position_texture = (
        float2(
          0,
          1
        )
      );
      
      break;
    }
    
    case 0x01: {
      d.position = (
        float4(
          1, -1, 0, 1
        )
      );
      
      d.position_texture = (
        float2(
          1,
          1
        )
      );
      
      break;
    }
    
    case 0x02: {
      d.position = (
        float4(
          -1, 1, 0, 1
        )
      );
      
      d.position_texture = (
        float2(
          0,
          0
        )
      );
      
      break;
    }
    
    case 0x03: {
      d.position = (
        float4(
          1, 1, 0, 1
        )
      );
      
      d.position_texture = (
        float2(
          1,
          0
        )
      );
      
      break;
    }
  }
  
  return d;
    
}


[[fragment]] float4 filter_fragment(
  data_vertex_basic_textured_coloured data_vertex_basic_textured_coloured [[stage_in]],
  metal::texture2d<float> texture [[texture(0)]]
) {
  constexpr metal::sampler sampler_texture(
    metal::filter::linear,
    metal::mip_filter::linear
  );

  float4 colour_texture = float4(
    texture.sample(
      sampler_texture,
      data_vertex_basic_textured_coloured.position_texture
    )
  );

  return float4(
    colour_texture[0],
    colour_texture[1],
    colour_texture[2],
    colour_texture[3]
  );
}

