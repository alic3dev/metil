#ifndef __metil_example_audio_output_metal_h
#define __metil_example_audio_output_metal_h

#include <metil_metal/basic_3d_shaders.h>
#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>

[[vertex]] struct data_vertex_basic_coloured metil_example_audio_output_vertex(
  const device float4*,
  constant struct metil_renderer_data_frame*,
  constant struct metil_renderer_data_object*,
  unsigned int
);

[[fragment]] float4 metil_example_audio_output_fragment(
  struct data_vertex_basic_coloured
);

#endif
