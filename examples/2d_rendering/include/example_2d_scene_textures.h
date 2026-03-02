#ifndef __example_2d_scene_textures_h
#define __example_2d_scene_textures_h

#include <metil.h>
#include <metil_scenes/metil_scene.h>

#define example_2d_rendering_length_textures 0x01

enum example_2d_rendering_texture_index {
  example_2d_rendering_texture_index_background = 0x00
};

void example_2d_scene_textures_initialize(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void example_2d_scene_textures_initialize_background(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

#endif
