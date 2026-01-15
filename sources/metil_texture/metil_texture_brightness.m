#include <metil_texture/metil_texture_brightness.h>

#include <metil_image/metil_image_brightness.h>
#include <metil_image/metil_image_offsets.h>
#include <metil_image/metil_image_type.h>
#include <metil_image/metil_image_type_bridge.h>

#include <Metal/MTLTexture.h>

#include <stdlib.h>

void metil_texture_brightness(
  id<MTLTexture> texture,
  float brightness
) {
  MTLRegion region = {
    {
      .x = (
        0x00
      ),
      .y = (
        0x00
      ),
      .z = (
        0x00
      )
    },
    {
      .width = (
        texture.width
      ),
      .height = (
        texture.height
      ),
      .depth = (
        0x01
      )
    }
  };

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

  unsigned int length_pixel_bytes_row = (
    texture.width *
    metil_image_offsets->bytes
  );

  unsigned int length_pixel_bytes = (
    length_pixel_bytes_row *
    texture.height
  );

  pixel_bytes = (
    malloc(
      sizeof(
        unsigned char
      ) *
      length_pixel_bytes
    )
  );

  [
    texture
    getBytes: pixel_bytes
    bytesPerRow: length_pixel_bytes_row
    fromRegion: region
    mipmapLevel: 0x00
  ];

  metil_image_brightness_linear_with_offsets(
    pixel_bytes,
    length_pixel_bytes,
    metil_image_type,
    metil_image_offsets,
    brightness
  );

  [
    texture
    replaceRegion: region
    mipmapLevel: 0x00
    withBytes: pixel_bytes
    bytesPerRow: length_pixel_bytes_row
  ];

  free(
    pixel_bytes
  );
}
