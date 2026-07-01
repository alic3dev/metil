#ifndef __metil_rendering_metil_rendering_properties_h
#define __metil_rendering_metil_rendering_properties_h

#include <metil_configuration/metil_configuration_rendering_properties.h>
#include <metil_rendering/metil_camera/metil_camera.h>

#include <math_c_vector.h>

#include <pthread.h>

#define metil_count_max_frames 0x01

#define metil_count_time_frames 0x3c

enum metil_rendering_properties_mode {
  metil_rendering_properties_mode_default            = 0b00000001,
  metil_rendering_properties_mode_wireframe          = 0b00000010,
  metil_rendering_properties_mode_wireframe_full     = 0b00000100,
  metil_rendering_properties_mode_indirect_rendering = 0b00001000,
  metil_rendering_properties_mode_filters            = 0b00010000
};

enum metil_rendering_properties_disables {
  metil_rendering_properties_disables_none      = 0b00000000,
  metil_rendering_properties_disables_polling   = 0b00000001,
  metil_rendering_properties_disables_rendering = 0b00000010
};

struct metil_rendering_properties {
  struct metil_camera camera;

  unsigned int frame;
  unsigned int count_completed_frames;
  pthread_mutex_t mutex_frame;

  float brightness;
  float brightness_text;

  struct math_c_vector4_float colour_clear;

  unsigned char fps_display;
  struct math_c_vector4_float colour_fps_display;
  float fps;

  enum metil_rendering_properties_mode mode;

  unsigned long int time_frames[
    metil_count_time_frames
  ];

  enum metil_rendering_properties_disables disables;
};

void metil_rendering_properties_initialize(
  struct metil_rendering_properties*,
  struct metil_configuration_rendering_properties*
);

void metil_rendering_properties_destory(
  struct metil_rendering_properties*
);

#endif
