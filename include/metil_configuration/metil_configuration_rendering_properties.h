#ifndef __metil_configuration_metil_configuration_rendering_properties_h
#define __metil_configuration_metil_configuration_rendering_properties_h

#include <metil_configuration/metil_configuration_rendering_properties_defaults.h>

#include <math_c_vector.h>

struct metil_configuration_rendering_properties {
  float brightness;
  float brightness_text;

  unsigned char fps_display;
  struct math_c_vector4_float colour_fps_display;

  struct metil_configuration_rendering_properties_defaults defaults;
};

void metil_configuration_rendering_properties_initialize(
  struct metil_configuration_rendering_properties*
);

#endif
