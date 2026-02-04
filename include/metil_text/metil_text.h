#ifndef __metil_text_metil_text_h
#define __metil_text_metil_text_h

#include <metil_configuration/metil_configuration.h>
#include <metil_mesh/metil_mesh.h>
#include <metil_text/metil_text_render_parameters.h>

#include <math_c_vector.h>

#include <CoreGraphics/CoreGraphics.h>
#include <CoreText/CoreText.h>
#include <Metal/MTLDevice.h>

struct metil_text_image {
  unsigned char* _Nonnull data;
  struct math_c_vector2_float size;
};

CGGlyph* _Nullable metil_text_glyphs_encode(
  char* _Nonnull,
  unsigned int,
  CTFontRef _Nonnull,
  struct metil_configuration* _Nonnull
);

struct metil_text_image* _Nullable metil_text_render(
  char* _Nonnull,
  struct metil_text_render_parameters* _Nonnull,
  struct metil_configuration* _Nonnull
);

id<MTLTexture> _Nullable metil_text_texture_render(
  id<MTLDevice> _Nonnull,
  struct metil_text_image* _Nonnull,
  struct metil_configuration* _Nonnull
);

id<MTLTexture> _Nullable metil_text_mesh_with_texture_initialize(
  id<MTLDevice> _Nonnull,
  struct metil_mesh* _Nonnull,
  char* _Nonnull,
  struct metil_text_render_parameters* _Nonnull,
  struct metil_configuration* _Nonnull
);

void metil_text_image_destroy(
  struct metil_text_image* _Nonnull
);

void metil_text_destroy(
  struct metil_text_render_parameters* _Nonnull
);

#endif
