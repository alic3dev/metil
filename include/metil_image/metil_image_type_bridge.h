#ifndef __metil_image_metil_image_type_bridge_h
#define __metil_image_metil_image_type_bridge_h

#include <metil_image/metil_image_type.h>

#include <Metal/MTLPixelFormat.h>

enum metil_image_type metil_image_type_bridge_mtl_pixel_format(
  MTLPixelFormat
);

MTLPixelFormat metil_image_type_bridge_reverse_mtl_pixel_format(
  enum metil_image_type
);

#endif
