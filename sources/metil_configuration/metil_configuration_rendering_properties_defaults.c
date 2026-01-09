#include <metil_configuration/metil_configuration_rendering_properties_defaults.h>

void metil_configuration_rendering_properties_defaults_initialize(
  struct metil_configuration_rendering_properties_defaults* metil_configuration_rendering_properties_defaults
) {
  metil_configuration_rendering_properties_defaults->brightness = (
    metil_configuration_rendering_properties_default_brightness
  );

  metil_configuration_rendering_properties_defaults->brightness_text = (
    metil_configuration_rendering_properties_default_brightness_text
  );

  metil_configuration_rendering_properties_defaults->fps_display = (
    metil_configuration_rendering_properties_default_fps_display
  );

  metil_configuration_rendering_properties_defaults->color_fps_display.x = (
    metil_configuration_rendering_properties_default_color_fps_display_x
  );

  metil_configuration_rendering_properties_defaults->color_fps_display.y = (
    metil_configuration_rendering_properties_default_color_fps_display_y
  );

  metil_configuration_rendering_properties_defaults->color_fps_display.z = (
    metil_configuration_rendering_properties_default_color_fps_display_z
  );

  metil_configuration_rendering_properties_defaults->color_fps_display.w = (
    metil_configuration_rendering_properties_default_color_fps_display_w
  );

  metil_configuration_rendering_properties_defaults->initialized = (
    1
  );
}
