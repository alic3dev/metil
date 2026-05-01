#ifndef __metil_metal_metil_metal_data_vertex_h
#define __metil_metal_metil_metal_data_vertex_h

struct data_vertex_basic {
  float4 position [[position]];
};

struct data_vertex_basic_coloured {
  float4 position [[position]];
  float4 colour;
  float brightness;
};

struct data_vertex_basic_textured_coloured {
  float4 position [[position]];
  float2 position_texture;
  float4 colour;
  float brightness;
};

struct data_vertex_basic_multiple_textured_coloured {
  float4 position [[position]];
  float2 position_texture;
  float4 colour;
  float brightness;
  unsigned char index_texture;
};

#endif
