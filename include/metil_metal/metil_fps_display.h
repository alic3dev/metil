#ifndef __metil_metal_metil_fps_display_h
#define __metil_metal_metil_fps_display_h

#include <metil_metal/metil_metal_data_vertex.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>

#include <metal_stdlib>

[[vertex]] struct data_vertex_basic_textured_coloured metil_fps_display_vertex(
  const device simd_float4*,
  constant struct metil_renderer_data_frame*,
  constant struct metil_renderer_data_object*,
  unsigned int
);

[[fragment]] float4 metil_fps_display_fragment(
  data_vertex_basic_textured_coloured,
  metal::texture2d<half>
);

#endif
