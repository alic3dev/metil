#ifndef __metil_rendering_metil_renderer_interface_h
#define __metil_rendering_metil_renderer_interface_h

#include <metil_rendering/metil_rendering_properties.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLLibrary.h>

@class metil_renderer;

struct metil_renderer_interface {
  _Nonnull id<MTLDevice> metal_device;

  metil_renderer* _Nonnull renderer;

  struct metil_rendering_properties* _Nonnull rendering_properties;

  struct math_c_vector2_float size;
};

#endif
