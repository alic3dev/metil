#include <metil_texture/metil_texture_image.h>

#include <metil_image/metil_image_offsets.h>
#include <metil_image/metil_image_type.h>
#include <metil_image/metil_image_type_bridge.h>

#include <clic3_memory.h>

#include <Metal/MTLTexture.h>

void metil_texture_image_get_from_region_with_offsets(
  id<MTLTexture> texture,
  void** pixel_bytes,
  unsigned int* length_pixel_bytes,
  unsigned int* length_pixel_bytes_row,
  MTLRegion* mtl_region,
  const struct metil_image_offsets* metil_image_offsets
) {
  unsigned int value_length_pixel_bytes_row = (
    mtl_region->size.width *
    metil_image_offsets->bytes
  );

  if (
    length_pixel_bytes_row != 0
  ) {
    *length_pixel_bytes_row = (
      value_length_pixel_bytes_row
    );
  }

  *length_pixel_bytes = (
    value_length_pixel_bytes_row *
    mtl_region->size.height
  );

  clic3_memory_allocate(
    pixel_bytes,
    *length_pixel_bytes
  );

  [
    texture
    getBytes: *pixel_bytes
    bytesPerRow: value_length_pixel_bytes_row
    fromRegion: *mtl_region
    mipmapLevel: 0x00
  ];
}

void metil_texture_image_get_from_region(
  id<MTLTexture> texture,
  void** pixel_bytes,
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
  void** pixel_bytes,
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
