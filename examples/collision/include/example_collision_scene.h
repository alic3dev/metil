#ifndef __example_collision_scene_h
#define __example_collision_scene_h

#include <metil.h>
#include <metil_scenes/metil_scene.h>

#define scene_example_collision_length_renderables 4

#define scene_example_collision_length_targets 100

enum scene_example_collision_index_renderable {
  scene_example_collision_index_renderable_floor = 0,
  scene_example_collision_index_renderable_group_targets = 1,
  scene_example_collision_index_renderable_group_projectiles = 2,
  scene_example_collision_index_renderable_turret = 3
};

void example_collision_scene_initialize(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void scene_example_collision_populate_targets(
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
