#ifndef __metil_rendering_properties_h
#define __metil_rendering_properties_h

#include <metil_rendering/camera/camera.h>

#include <clic3_vector.h>

#include <pthread.h>

#define metil_count_max_frames 5
#define metil_length_buffers_visibility metil_count_max_frames + 1

struct metil_rendering_properties {
  struct metil_camera camera;

  unsigned int frame;
  signed char count_completed_frames;
  pthread_mutex_t mutex_frame;

  float brightness;
  float brightness_text;

  struct clic3_vector4_float color_clear;
};

void metil_rendering_properties_initialize(
  struct metil_rendering_properties*
);

void metil_rendering_properties_destory(
  struct metil_rendering_properties*
);

#endif
