#ifndef __metil_texture_metil_texture_image_h
#define __metil_texture_metil_texture_image_h

#include <metil_image/metil_image_offsets.h>

#include <Metal/MTLTexture.h>

void metil_texture_image_get_from_region_with_offsets(
  id<MTLTexture> _Nonnull,
  unsigned char* _Nonnull * _Nullable,
  unsigned int* _Nonnull,
  unsigned int* _Nullable,
  MTLRegion* _Nonnull,
  const struct metil_image_offsets* _Nonnull
);

void metil_texture_image_get_from_region(
  id<MTLTexture> _Nonnull,
  unsigned char* _Nonnull * _Nullable,
  unsigned int* _Nonnull,
  unsigned int* _Nullable,
  MTLRegion* _Nonnull
);

void metil_texture_image_get(
  id<MTLTexture> _Nonnull,
  unsigned char* _Nonnull * _Nullable,
  unsigned int* _Nonnull,
  unsigned int* _Nullable
);

void metil_texture_image_region_get(
  id<MTLTexture> _Nonnull,
  MTLRegion* _Nonnull
);

#endif
