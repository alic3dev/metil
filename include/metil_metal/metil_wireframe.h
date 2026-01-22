#ifndef __metil_metal_metil_wireframe_h
#define __metil_metal_metil_wireframe_h

#include <metil_metal/metil_metal_data_vertex.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>

[[vertex]] struct data_vertex_basic metil_wireframe_vertex(
  const device simd_float4*,
  constant struct metil_renderer_data_frame* ,
  constant struct metil_renderer_data_object*,
  unsigned int
);

[[fragment]] float4 metil_wireframe_fragment();

#endif
