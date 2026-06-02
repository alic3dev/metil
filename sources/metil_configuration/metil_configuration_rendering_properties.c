#include <metil_configuration/metil_configuration_rendering_properties.h>

void metil_configuration_rendering_properties_initialize(
  struct metil_configuration_rendering_properties* metil_configuration_rendering_properties
) {
  if (
    metil_configuration_rendering_properties->defaults.initialized !=
    0x01
  ) {
    metil_configuration_rendering_properties_defaults_initialize(
      &metil_configuration_rendering_properties->defaults
    );
  }

  metil_configuration_rendering_properties->brightness = (
    metil_configuration_rendering_properties->defaults.brightness
  );

  metil_configuration_rendering_properties->brightness_text = (
    metil_configuration_rendering_properties->defaults.brightness_text
  );

  metil_configuration_rendering_properties->fps_display = (
    metil_configuration_rendering_properties->defaults.fps_display
  );

  metil_configuration_rendering_properties->colour_fps_display.x = (
    metil_configuration_rendering_properties->defaults.colour_fps_display.x
  );

  metil_configuration_rendering_properties->colour_fps_display.y = (
    metil_configuration_rendering_properties->defaults.colour_fps_display.y
  );

  metil_configuration_rendering_properties->colour_fps_display.z = (
    metil_configuration_rendering_properties->defaults.colour_fps_display.z
  );

  metil_configuration_rendering_properties->colour_fps_display.w = (
    metil_configuration_rendering_properties->defaults.colour_fps_display.w
  );
  
  metil_configuration_rendering_properties->display_sync = (
    metil_configuration_rendering_properties->defaults.display_sync
  );
}
