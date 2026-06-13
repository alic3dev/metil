#ifndef __metil_example_audio_output_scene_h
#define __metil_example_audio_output_scene_h

#include <metil.h>
#include <metil_scenes/metil_scene.h>

#define metil_example_audio_output_scene_length_renderables 0x03

void metil_example_audio_output_scene_initialize(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void metil_example_audio_output_scene_poll(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void metil_example_audio_output_scene_destroy(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

#endif
