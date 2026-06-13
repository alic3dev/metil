#ifndef __metil_metil_rendering_metil_descriptors_metil_render_pass_h
#define __metil_metil_rendering_metil_descriptors_metil_render_pass_h

#include <Metal/MTLDevice.h>
#include <Metal/MTLRenderPass.h>

void metil_descriptor_render_pass_initialize(
  MTLRenderPassDescriptor* _Nonnull,
  id<MTLDevice> _Nonnull
);

#endif
