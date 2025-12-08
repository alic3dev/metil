#include <metil_rendering/rendering_properties.h>

#include <metil_configuration/configuration_rendering_properties.h>
#include <metil_rendering/camera/camera.h>

#include <pthread.h>

void metil_rendering_properties_initialize(
  struct metil_rendering_properties* metil_rendering_properties
) {
  metil_rendering_properties->mode = (
    metil_rendering_properties_mode_default
  );

  pthread_mutex_init(
    &metil_rendering_properties->mutex_frame,
    (void*)0
  );

  metil_rendering_properties->count_completed_frames = (
    metil_count_max_frames
  );

  metil_camera_initialize(
    &metil_rendering_properties->camera
  );

  metil_rendering_properties->brightness = (
    metil_configuration_default_rendering_properties_brightness
  );

  metil_rendering_properties->brightness_text = (
    metil_configuration_default_rendering_properties_brightness_text
  );

  metil_rendering_properties->color_clear.x = 0.0f;
  metil_rendering_properties->color_clear.y = 0.0f;
  metil_rendering_properties->color_clear.z = 0.0f;
  metil_rendering_properties->color_clear.w = 1.0f;

  metil_rendering_properties->fps_display = (
    metil_configuration_default_rendering_properties_fps_display
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
