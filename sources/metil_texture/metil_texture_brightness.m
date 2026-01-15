#include <metil_texture/metil_texture_brightness.h>

#include <metil_image/metil_image_brightness.h>
#include <metil_image/metil_image_offsets.h>
#include <metil_image/metil_image_type.h>
#include <metil_image/metil_image_type_bridge.h>
#include <metil_texture/metil_texture_image.h>

#include <Metal/MTLTexture.h>

#include <stdlib.h>

void metil_texture_brightness(
  id<MTLTexture> texture,
  float brightness
) {
  enum metil_image_type metil_image_type = (
    metil_image_type_bridge_mtl_pixel_format(
      texture.pixelFormat
    )
  );

  const struct metil_image_offsets* metil_image_offsets = (
    metil_image_offsets_get_by_type(
      metil_image_type
    )
  );

  unsigned char* pixel_bytes = (
    (void*) 0
  );

  unsigned int length_pixel_bytes_row;
  unsigned int length_pixel_bytes;

  MTLRegion mtl_region;

  metil_texture_image_region_get(
    texture,
    &mtl_region
  );

  metil_texture_image_get_from_region_with_offsets(
    texture,
    &pixel_bytes,
    &length_pixel_bytes,
    &length_pixel_bytes_row,
    &mtl_region,
    metil_image_offsets
  );

  metil_image_brightness_linear_with_offsets(
    pixel_bytes,
    length_pixel_bytes,
    metil_image_type,
    metil_image_offsets,
    brightness
  );

  [
    texture
    replaceRegion: mtl_region
    mipmapLevel: 0x00
    withBytes: pixel_bytes
    bytesPerRow: length_pixel_bytes_row
  ];

  free(
    pixel_bytes
  );
}
