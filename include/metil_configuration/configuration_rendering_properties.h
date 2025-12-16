#ifndef __metil_configuration_rendering_properties_h
#define __metil_configuration_rendering_properties_h

extern float metil_configuration_default_rendering_properties_brightness;
extern float metil_configuration_default_rendering_properties_brightness_text;

extern unsigned char metil_configuration_default_rendering_properties_fps_display;

struct metil_configuration_rendering_properties {
  float brightness;
  float brightness_text;

  unsigned char fps_display;
};

#endif
