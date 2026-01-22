#ifndef __metil_metal_basic_3d_shaders_h
#define __metil_metal_basic_3d_shaders_h

#include <metil_metal/metil_metal_data_vertex.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>

[[vertex]] struct data_vertex_basic_coloured shader_3d_vertex(
  const device simd_float4*,
  constant struct metil_renderer_data_frame*,
  constant struct metil_renderer_data_object*,
  unsigned int
)

[[fragment]] float4 shader_3d_fragment(
  struct data_vertex_basic_coloured
);

#endif
