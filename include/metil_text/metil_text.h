#ifndef __metil_text_metil_text_h
#define __metil_text_metil_text_h

#include <metil_mesh/metil_mesh.h>

#include <clic3_vector.h>

#include <CoreGraphics/CoreGraphics.h>
#include <CoreText/CoreText.h>
#include <Metal/MTLDevice.h>

extern CTFontRef metil_font_reference_monospace;

struct metil_text_image {
  unsigned char* data;
  struct clic3_vector2_unsigned_int size;
};

struct metil_text_render_parameters {
  CTFontRef font;
  unsigned short int letter_spacing;
  struct clic3_vector2_unsigned_short_int padding;
  float scale;
};

extern struct metil_text_render_parameters metil_text_render_parameters_default;

void metil_text_initialize();

CGGlyph* metil_text_glyphs_encode(
  char*,
  unsigned int,
  CTFontRef
);

struct metil_text_image* metil_text_render(
  char*,
  struct metil_text_render_parameters*
);

id<MTLTexture> metil_text_texture_render(
  id<MTLDevice>,
  struct metil_text_image*
);

id<MTLTexture> metil_text_mesh_with_texture_initialize(
  id<MTLDevice>,
  struct metil_mesh*,
  char*,
  struct metil_text_render_parameters*
);

void metil_text_image_destroy(
  struct metil_text_image*
);

void metil_text_destroy();

#endif
