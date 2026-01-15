#include <metil_texture/metil_texture_image.h>

#include <metil_image/metil_image_offsets.h>
#include <metil_image/metil_image_type.h>
#include <metil_image/metil_image_type_bridge.h>

#include <Metal/MTLTexture.h>

#include <stdlib.h>

void metil_texture_image_get_from_region_with_offsets(
  id<MTLTexture> texture,
  unsigned char** pixel_bytes,
  unsigned int* length_pixel_bytes,
  unsigned int* length_pixel_bytes_row,
  MTLRegion* mtl_region,
  const struct metil_image_offsets* metil_image_offsets
) {
  *length_pixel_bytes_row = (
    mtl_region->size.width *
    metil_image_offsets->bytes
  );

  *length_pixel_bytes = (
    *length_pixel_bytes_row *
    mtl_region->size.height
  );

  if (
    *pixel_bytes == (void*) 0
  ) {
    *pixel_bytes = (
      malloc(
        sizeof(
          unsigned char
        ) *
        *length_pixel_bytes
      )
    );
  } else {
    *pixel_bytes = (
      realloc(
        *pixel_bytes,
        sizeof(
          unsigned char
        ) *
        *length_pixel_bytes
      )
    );
  }

  [
    texture
    getBytes: *pixel_bytes
    bytesPerRow: *length_pixel_bytes_row
    fromRegion: *mtl_region
    mipmapLevel: 0x00
  ];
}

void metil_texture_image_get_from_region(
  id<MTLTexture> texture,
  unsigned char** pixel_bytes,
  unsigned int* length_pixel_bytes,
  unsigned int* length_pixel_bytes_row,
  MTLRegion* mtl_region
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

  metil_texture_image_get_from_region_with_offsets(
    texture,
    pixel_bytes,
    length_pixel_bytes,
    length_pixel_bytes_row,
    mtl_region,
    metil_image_offsets
  );
}

void metil_texture_image_get(
  id<MTLTexture> texture,
  unsigned char** pixel_bytes,
  unsigned int* length_pixel_bytes,
  unsigned int* length_pixel_bytes_row
) {
  MTLRegion mtl_region;

  metil_texture_image_region_get(
    texture,
    &mtl_region
  );

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

  metil_texture_image_get_from_region_with_offsets(
    texture,
    pixel_bytes,
    length_pixel_bytes,
    length_pixel_bytes_row,
    &mtl_region,
    metil_image_offsets
  );
}

void metil_texture_image_region_get(
  id<MTLTexture> texture,
  MTLRegion* mtl_region
) {
  mtl_region->origin.x = (
    0x00
  );

  mtl_region->origin.y = (
    0x00
  );

  mtl_region->origin.z = (
    0x00
  );

  mtl_region->size.width = (
    texture.width
  );

  mtl_region->size.height = (
    texture.height
  );

  mtl_region->size.depth = (
    0x01
  );
}
