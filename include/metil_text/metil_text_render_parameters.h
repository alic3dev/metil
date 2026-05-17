#ifndef __metil_metil_text_metil_text_render_parameters_h
#define __metil_metil_text_metil_text_render_parameters_h

#include <math_c_vector.h>

#include <CoreText/CTFont.h>

enum metil_text_render_parameters_letter_width_style {
  metil_text_render_parameters_letter_width_style_default = 0x00,
  metil_text_render_parameters_letter_width_style_fixed   = 0x80,
  metil_text_render_parameters_letter_width_style_maximum = 0xff
};

struct metil_text_render_parameters {
  CTFontRef _Nonnull font;

  enum metil_text_render_parameters_letter_width_style letter_width_style;

  float letter_width;
  float letter_spacing;

  struct math_c_vector2_float padding;
  float scale;
};

void metil_text_render_parameters_initialize(
  struct metil_text_render_parameters* _Nonnull,
  char* _Nonnull,
  float
);

void metil_text_render_parameters_destroy(
  struct metil_text_render_parameters* _Nonnull
);

#endif
