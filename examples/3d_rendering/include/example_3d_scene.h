#ifndef __example_3d_scene_h
#define __example_3d_scene_h

#include <metil.h>
#include <metil_scenes/metil_scene.h>

#define example_3d_scene_length_renderables 0x05

enum example_3d_scene_index_renderable {
  example_3d_scene_index_renderable_sky          = 0x00,
  example_3d_scene_index_renderable_ground       = 0x01,
  example_3d_scene_index_renderable_structures   = 0x02,
  example_3d_scene_index_renderable_doors        = 0x03,
  example_3d_scene_index_renderable_solar_system = 0x04
};

void example_3d_scene_initialize(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void example_3d_scene_poll(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

#endif
