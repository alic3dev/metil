#include <metil_texture/metil_texture_brightness.h>

#include <metil_image/metil_image.h>
#include <metil_image/metil_image_brightness.h>
#include <metil_image/metil_image_texture.h>
#include <metil_texture/metil_texture_image.h>

#include <Metal/MTLTexture.h>

void metil_texture_brightness_linear(
  id<MTLTexture> mtl_texture,
  float brightness
) {
  struct metil_image metil_image;

  MTLRegion mtl_region;

  metil_image_with_region_from_texture(
    &metil_image,
    &mtl_region,
    mtl_texture
  );

  metil_image_brightness_linear(
    &metil_image,
    brightness
  );

  [
    mtl_texture
    replaceRegion: mtl_region
    mipmapLevel: 0x00
    withBytes: metil_image.data
    bytesPerRow: metil_image.length_row
  ];

  metil_image_destroy(
    &metil_image
  );
}
