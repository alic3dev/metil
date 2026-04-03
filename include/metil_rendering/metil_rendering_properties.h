#ifndef __metil_rendering_metil_rendering_properties_h
#define __metil_rendering_metil_rendering_properties_h

#include <metil_configuration/metil_configuration_rendering_properties.h>
#include <metil_rendering/metil_camera/metil_camera.h>

#include <math_c_vector.h>

#include <pthread.h>

#define metil_count_max_frames 1

#define metil_count_time_frames 60

#define metil_rendering_properties_mode_default 0b1
#define metil_rendering_properties_mode_wireframe 0b10

struct metil_rendering_properties {
  struct metil_camera camera;

  unsigned int frame;
  signed char count_completed_frames;
  pthread_mutex_t mutex_frame;

  float brightness;
  float brightness_text;

  struct math_c_vector4_float colour_clear;

  unsigned char fps_display;
  struct math_c_vector4_float colour_fps_display;
  float fps;

  unsigned char mode;

  unsigned long int time_frames[
    metil_count_time_frames
  ];
};

void metil_rendering_properties_initialize(
  struct metil_rendering_properties*,
  struct metil_configuration_rendering_properties*
);

void metil_rendering_properties_destory(
  struct metil_rendering_properties*
);

#endif
