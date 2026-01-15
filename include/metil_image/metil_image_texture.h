#ifndef __metil_image_metil_image_texture_h
#define __metil_image_metil_image_texture_h

#include <metil_image/metil_image.h>

#include <Metal/MTLTexture.h>
#include <Metal/MTLTypes.h>

void metil_image_from_texture(
  struct metil_image* _Nonnull,
  id<MTLTexture> _Nonnull
);

void metil_image_with_region_from_texture(
  struct metil_image* _Nonnull,
  MTLRegion* _Nonnull,
  id<MTLTexture> _Nonnull
);

void metil_image_from_texture_with_region(
  struct metil_image* _Nonnull,
  id<MTLTexture> _Nonnull,
  MTLRegion* _Nonnull
);

#endif
