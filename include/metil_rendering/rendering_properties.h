#ifndef __metil_rendering_properties_h
#define __metil_rendering_properties_h

#include <metil_rendering/camera/camera.h>

#include <pthread.h>

static const unsigned int metil_count_max_frames = 5;
static const unsigned int metil_length_buffers_visibility = (
  metil_count_max_frames + 1
);

struct metil_rendering_properties {
  struct metil_camera camera;

  unsigned int frame;
  signed char count_completed_frames;
  pthread_mutex_t mutex_frame;

  float brightness;
  float brightness_text;
};

void metil_rendering_properties_initialize(
  struct metil_rendering_properties*
);

void metil_rendering_properties_destory(
  struct metil_rendering_properties*
);

#endif
