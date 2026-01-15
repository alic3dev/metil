#include <metil_image/metil_image_texture.h>

#include <metil_image/metil_image.h>
#include <metil_image/metil_image_type_bridge.h>
#include <metil_texture/metil_texture_image.h>

#include <Metal/MTLTexture.h>
#include <Metal/MTLTypes.h>

void metil_image_from_texture(
  struct metil_image* metil_image,
  id<MTLTexture> mtl_texture
) {
  MTLRegion mtl_region;

  metil_image_with_region_from_texture(
    metil_image,
    &mtl_region,
    mtl_texture
  );
}

void metil_image_with_region_from_texture(
  struct metil_image* metil_image,
  MTLRegion* mtl_region,
  id<MTLTexture> mtl_texture
) {
  metil_image->type = (
    metil_image_type_bridge_mtl_pixel_format(
      mtl_texture.pixelFormat
    )
  );

  metil_image->offsets = (
    metil_image_offsets_get_by_type(
      metil_image->type
    )
  );

  metil_image->data = (
    (void*) 0
  );

  metil_texture_image_region_get(
    mtl_texture,
    mtl_region
  );

  metil_image->size.x = (
    mtl_region->size.width
  );

  metil_image->size.y = (
    mtl_region->size.height
  );

  metil_image->type = (
    metil_image_type_bridge_mtl_pixel_format(
      mtl_texture.pixelFormat
    )
  );

  metil_image->offsets = (
    metil_image_offsets_get_by_type(
      metil_image->type
    )
  );

  metil_image_from_texture_with_region(
    metil_image,
    mtl_texture,
    mtl_region
  );
}

void metil_image_from_texture_with_region(
  struct metil_image* metil_image,
  id<MTLTexture> mtl_texture,
  MTLRegion* mtl_region
) {
  metil_texture_image_get_from_region_with_offsets(
    mtl_texture,
    &metil_image->data,
    &metil_image->length,
    &metil_image->length_row,
    mtl_region,
    metil_image->offsets
  );
}
