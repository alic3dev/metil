#ifndef __metil_rendering_metil_descriptors_metil_pipeline_render_h
#define __metil_rendering_metil_descriptors_metil_pipeline_render_h

#include <Metal/MTLRenderPipeline.h>

void metil_rendering_descriptors_pipeline_render_initialize(
  MTLRenderPipelineDescriptor* descriptor_pipeline_render,
  unsigned long,
  id<MTLFunction>,
  id<MTLFunction>,
  MTLPixelFormat,
  MTLPixelFormat,
  MTLPixelFormat
);

#endif
