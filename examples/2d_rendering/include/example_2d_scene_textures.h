#ifndef __example_2d_scene_textures_h
#define __example_2d_scene_textures_h

#include <metil.h>
#include <metil_scenes/metil_scene.h>

#define example_2d_rendering_length_textures 0x06

enum example_2d_rendering_index_texture {
  example_2d_rendering_index_texture_background        = 0x00,
  example_2d_rendering_index_texture_floor             = 0x01,
  example_2d_rendering_index_texture_server_housing    = 0x02,
  example_2d_rendering_index_texture_player_walk_one   = 0x03,
  example_2d_rendering_index_texture_player_walk_two   = 0x04,
  example_2d_rendering_index_texture_player_walk_three = 0x05
};

void example_2d_scene_textures_initialize(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void example_2d_scene_textures_initialize_background(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void example_2d_scene_textures_initialize_floor(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void example_2d_scene_textures_initialize_server_housing(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void example_2d_scene_textures_initialize_player_walk_one(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void example_2d_scene_textures_initialize_player_walk_two(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void example_2d_scene_textures_initialize_player_walk_three(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

#endif
