#include <metil_image/metil_image_type_bridge.h>

#include <metil_image/metil_image_type.h>

enum metil_image_type metil_image_type_bridge_mtl_pixel_format(
  MTLPixelFormat mtl_pixel_format
) {
  switch (
    mtl_pixel_format
  ) {
    case MTLPixelFormatBGRA8Unorm: {
      return (
        metil_image_type_bgra_8
      );
    }
    case MTLPixelFormatRGBA8Unorm: {
      return (
        metil_image_type_rgba_8
      );
    }
    default: {
      return (
        metil_image_type_unknown
      );
    }
  }
}

MTLPixelFormat metil_image_type_bridge_reverse_mtl_pixel_format(
  enum metil_image_type metil_image_type
) {
  switch (
    metil_image_type
  ) {
    case metil_image_type_bgra_8: {
      return MTLPixelFormatBGRA8Unorm;
    }
    case metil_image_type_rgba_8: {
      return MTLPixelFormatRGBA8Unorm;
    }
    default: {
      return MTLPixelFormatInvalid;
    }
  }
}
