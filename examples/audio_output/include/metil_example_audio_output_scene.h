#ifndef __metil_example_audio_output_scene_h
#define __metil_example_audio_output_scene_h

#include <metil.h>
#include <metil_scenes/metil_scene.h>

#define metil_example_audio_output_scene_length_renderables 0x03

enum metil_example_audio_output_scene_index_renderable {
  metil_example_audio_output_scene_index_renderable_floor    = 0x00,
  metil_example_audio_output_scene_index_renderable_flower   = 0x01,
  metil_example_audio_output_scene_index_renderable_floaties = 0x02
};

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
