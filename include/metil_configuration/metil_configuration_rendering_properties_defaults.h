#ifndef __metil_configuration_metil_configuration_defaults_h
#define __metil_configuration_metil_configuration_defaults_h

#define metil_configuration_rendering_properties_default_brightness 1.0
#define metil_configuration_rendering_properties_default_brightness_text 1.0

#define metil_configuration_rendering_properties_default_fps_display 0

struct metil_configuration_rendering_properties_defaults {
  float brightness;
  float brightness_text;

  unsigned char fps_display;

  unsigned char initialized;
};

void metil_configuration_rendering_properties_defaults_initialize(
  struct metil_configuration_rendering_properties_defaults*
);

#endif
