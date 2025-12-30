#ifndef __example_2d_scene_h
#define __example_2d_scene_h

#include <metil.h>
#include <metil_scenes/metil_scene.h>

void example_2d_scene_initialize(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void example_2d_scene_poll(
  struct metil_scene* _Nonnull
);

#endif
