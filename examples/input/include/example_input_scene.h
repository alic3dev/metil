#ifndef __examples_input_example_input_scene_h
#define __examples_input_example_input_scene_h

#include <metil.h>
#include <metil_scenes/metil_scene.h>

void example_input_scene_initialize(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
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
