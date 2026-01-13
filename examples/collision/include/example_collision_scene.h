#ifndef __example_collision_scene_h
#define __example_collision_scene_h

#include <metil.h>
#include <metil_scenes/metil_scene.h>

enum scene_example_collision_index_renderable {
  scene_example_collision_index_renderable_floor = 0,
  scene_example_collision_index_renderable_turret = 1
};

void example_collision_scene_initialize(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void example_collision_scene_poll(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void example_collision_scene_destroy(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

#endif
