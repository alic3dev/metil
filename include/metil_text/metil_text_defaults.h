#ifndef __metil_text_defaults_h
#define __metil_text_defaults_h

#include <metil_configuration/metil_configuration.h>
#include <metil_text/metil_text.h>

#include <CoreGraphics/CoreGraphics.h>
#include <CoreText/CoreText.h>

struct metil_text_defaults {
  unsigned char object_text_index_pipeline_render;

  struct metil_text_render_parameters render_parameters;
};

void metil_text_defaults_initialize(
  struct metil_text_defaults* _Nonnull,
  struct metil_configuration* _Nonnull
);

#endif
