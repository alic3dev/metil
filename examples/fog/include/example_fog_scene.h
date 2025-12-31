#ifndef __example_fog_scene_h
#define __example_fog_scene_h

#include <metil.h>
#include <metil_scenes/metil_scene.h>

void example_fog_scene_initialize(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void example_fog_scene_poll(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

#endif
