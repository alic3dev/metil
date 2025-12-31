#ifndef __metil_scenes_metil_scene_h
#define __metil_scenes_metil_scene_h

#include <metil_player/metil_player.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderer_interface.h>

struct metil_scene;

typedef void (*metil_function_scene_poll)(struct metil_scene* _Nonnull);
typedef void (*metil_function_scene_poll_input)(struct metil_scene* _Nonnull);
typedef void (*metil_function_scene_destroy)(struct metil_scene* _Nonnull);

struct metil_scene_rendering_properties {
  float brightness;
  float brightness_text;
};

struct metil_scene {
  struct metil_renderer_interface* _Nullable renderer_interface;

  struct metil_player player;

  struct metil_renderable* _Nonnull renderables;
  unsigned int length_renderables;

  _Nonnull id<MTLTexture>* _Nonnull textures;
  unsigned int length_textures;

  unsigned char loading;

  unsigned long int time_initial;
  unsigned long int time_elapsed;

  unsigned long int time;
  unsigned long int time_previous;
  unsigned long int time_delta;

  unsigned long int time_input;
  unsigned long int time_input_previous;
  unsigned long int time_input_delta;

  _Nonnull metil_function_scene_poll poll;
  _Nonnull metil_function_scene_poll_input poll_input;
  _Nonnull metil_function_scene_destroy destroy;

  struct metil_scene_rendering_properties rendering_properties;

  void* _Nullable data;
};

void metil_scene_initialize(
  struct metil_scene* _Nonnull,
  struct metil_renderer_interface* _Nullable
);

void metil_scene_initialize_with_renderables(
  struct metil_scene* _Nonnull,
  struct metil_renderer_interface* _Nullable,
  unsigned int
);

void metil_scene_renderables_set_length(
  struct metil_scene* _Nonnull,
  unsigned int
);

void metil_scene_poll_input(
  struct metil_scene* _Nonnull,
  unsigned long int
);

void metil_scene_poll(
  struct metil_scene* _Nonnull,
  unsigned long int
);

void metil_scene_destroy(
  struct metil_scene* _Nonnull
);

void metil_scene_poll_input_default(
  struct metil_scene* _Nonnull
);

void metil_scene_poll_default(
  struct metil_scene* _Nonnull
);

void metil_scene_destroy_default(
  struct metil_scene* _Nonnull
);

#endif
