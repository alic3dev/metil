#include <metil_shader_types.h>

struct data_rasterizer {
  float4 position [[position]];
  float4 color;
};

vertex data_rasterizer shader_vertex(
  const device simd_float4* positions [[buffer(metil_kit_vertex_input_index_positions)]],
  constant metil_kit_data_frame& data_frame [[buffer(metil_kit_vertex_input_index_frame_data)]],
  constant metil_kit_data_frame_object& data [[buffer(metil_kit_vertex_input_index_data)]],
  unsigned int id_vertex [[vertex_id]]
) {
  data_rasterizer out;

  out.position = data.view_model_matrix_projection * positions[id_vertex];
  out.color = float4(
    metal::fmod(out.position.x / 10.0f, 1.0f),
    metal::fmod(out.position.y / 10.0f, 1.0f),
    metal::fmod(out.position.z / 10.0f, 1.0f),
    1
  );

  return out;
}

fragment float4 shader_fragment(data_rasterizer in [[stage_in]]) {
  return in.color;
}
