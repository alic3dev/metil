#include <metil_shader_types.h>

#include <metal_stdlib>

struct output_vertex {
  float4 position [[position]];
  float2 position_texture;
  float4 color;
};

[[vertex]] struct output_vertex metil_fps_display_vertex(
  const device simd_float4* positions [[buffer(metil_kit_vertex_input_index_positions)]],
  constant metil_kit_data_frame& data_frame [[buffer(metil_kit_vertex_input_index_frame_data)]],
  constant metil_kit_data_frame_object& data [[buffer(metil_kit_vertex_input_index_data)]],
  unsigned int id_vertex [[vertex_id]]
) {
  struct output_vertex output_vertex;

  output_vertex.position_texture.x = (
    id_vertex == 0 || id_vertex == 3
    ? 0
    : 1
  );

  output_vertex.position_texture.y = (
    id_vertex == 0 || id_vertex == 1
    ? 1
    : 0
  );

  output_vertex.position = data.view_model_matrix_projection * positions[id_vertex];
  output_vertex.color = float4(
    1.0f,
    1.0f,
    1.0f,
    1.0f
  );

  return output_vertex;
}

[[fragment]] float4 metil_fps_display_fragment(
  output_vertex in [[stage_in]],
  metal::texture2d<half> texture [[ texture(0) ]]
) {
  constexpr metal::sampler sampler_texture(
    metal::filter::linear,
    metal::mip_filter::linear
  );

  float4 color_texture = float4(
    texture.sample(
      sampler_texture,
      in.position_texture
    )
  );
  
  return float4(
    color_texture[0] * in.color.r,
    color_texture[1] * in.color.g,
    color_texture[2] * in.color.b,
    color_texture[3]
  );
}
