#ifndef __example_2d_scene_h
#define __example_2d_scene_h

#include <metil.h>
#include <metil_scenes/metil_scene.h>

#define example_2d_rendering_length_renderables 0x04

enum example_2d_rendering_index_renderable {
  example_2d_rendering_index_renderable_background = 0x00,
  example_2d_rendering_index_renderable_servers = 0x01,
  example_2d_rendering_index_renderable_server_housings = 0x02,
  example_2d_rendering_index_renderable_player = 0x03
};

#define example_2d_rendering_length_servers 0x0128

void example_2d_scene_initialize(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void example_2d_scene_poll(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

#endif
