#include <metil_rendering/metil_rendering_properties.h>

#include <metil_configuration/metil_configuration_rendering_properties_defaults.h>
#include <metil_configuration/metil_configuration_rendering_properties.h>
#include <metil_rendering/metil_camera/metil_camera.h>

#include <pthread.h>

void metil_rendering_properties_initialize(
  struct metil_rendering_properties* metil_rendering_properties,
  struct metil_configuration_rendering_properties* metil_configuration_rendering_properties
) {
  metil_rendering_properties->mode = (
    metil_rendering_properties_mode_default
  );

  pthread_mutex_init(
    &metil_rendering_properties->mutex_frame,
    0
  );

  metil_rendering_properties->count_completed_frames = (
    metil_count_max_frames
  );

  metil_camera_initialize(
    &metil_rendering_properties->camera
  );

  metil_rendering_properties->brightness = (
    metil_configuration_rendering_properties->brightness
  );

  metil_rendering_properties->brightness_text = (
    metil_configuration_rendering_properties->brightness_text
  );

  metil_rendering_properties->colour_clear.x = 0.0f;
  metil_rendering_properties->colour_clear.y = 0.0f;
  metil_rendering_properties->colour_clear.z = 0.0f;
  metil_rendering_properties->colour_clear.w = 1.0f;

  metil_rendering_properties->fps_display = (
    metil_configuration_rendering_properties->fps_display
  );

  metil_rendering_properties->colour_fps_display.x = (
    metil_configuration_rendering_properties->colour_fps_display.x
  );

  metil_rendering_properties->colour_fps_display.y = (
    metil_configuration_rendering_properties->colour_fps_display.y
  );

  metil_rendering_properties->colour_fps_display.z = (
    metil_configuration_rendering_properties->colour_fps_display.z
  );

  metil_rendering_properties->colour_fps_display.w = (
    metil_configuration_rendering_properties->colour_fps_display.w
  );

  metil_rendering_properties->fps = 0.0f;

  for (
    unsigned char index_time_frame = 0;
    index_time_frame < metil_count_time_frames;
    ++index_time_frame
  ) {
    metil_rendering_properties->time_frames[
      index_time_frame
    ] = 0;
  }
}

void metil_rendering_properties_destory(
  struct metil_rendering_properties* metil_rendering_properties
) {
  pthread_mutex_destroy(
    &metil_rendering_properties->mutex_frame
  );
}
