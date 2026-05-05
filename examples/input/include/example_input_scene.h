#ifndef __examples_input_example_input_scene_h
#define __examples_input_example_input_scene_h

#include <metil.h>
#include <metil_player/metil_player.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_scenes/metil_scene.h>

void example_input_scene_initialize(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void example_input_scene_player_poll_input(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull,
  unsigned long int,
  unsigned long int
);

void example_input_scene_poll(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void example_input_scene_destroy(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

#endif
