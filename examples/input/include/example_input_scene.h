#ifndef __examples_input_example_input_scene_h
#define __examples_input_example_input_scene_h

#include <metil.h>
#include <metil_animation/metil_animation.h>
#include <metil_player/metil_player.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_scenes/metil_scene.h>

enum example_input_scene_trick {
  example_input_scene_trick_none = (
    0x00
  ),
  example_input_scene_trick_kickflip = (
    0x01
  )
};
enum example_input_scene_stance {
  example_input_scene_stance_goofy = (
    0x00
  ),
  example_input_scene_stance_regular = (
    0x01
  )
};

struct example_input_scene_data {
  unsigned char stance;
  unsigned char trick;

  struct metil_animation* _Nullable animation;
};
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

void example_input_scene_animation_kickflip(
  struct metil_animation* _Nonnull,
  enum metil_renderable_type,
  void* _Nonnull,
  float
);

void example_input_scene_destroy(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

#endif
