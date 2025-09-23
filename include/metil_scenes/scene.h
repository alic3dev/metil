#ifndef __metil_scenes_scene_h
#define __metil_scenes_scene_h

#include <metil_object.h>
#include <metil_player.h>

#include <MetalKit/MetalKit.h>

struct metil_scene;

typedef void (*metil_function_scene_poll)(struct metil_scene*);
typedef void (*metil_function_scene_poll_input)(struct metil_scene*);
typedef void (*metil_function_scene_destroy)(struct metil_scene*);

enum metil_scene_type {
  metil_scene_type_unknown,
  metil_scene_type_menu,
  metil_scene_type_game
};

struct metil_scene_rendering_properties {
  float brightness;
  float brightness_text;
};

struct metil_scene {
  id<MTLDevice> metal_kit_device;

  struct metil_player player;
  enum metil_scene_type type;
  int id;

  struct metil_object** objects;
  unsigned short int length_objects;

  id<MTLTexture>* textures;
  unsigned short int length_textures;

  unsigned char loading;

  unsigned long int time_initial;
  unsigned long int time_elapsed;

  unsigned long int time;
  unsigned long int time_previous;
  unsigned long int time_delta;

  unsigned long int time_input;
  unsigned long int time_input_previous;
  unsigned long int time_input_delta;

  metil_function_scene_poll poll;
  metil_function_scene_poll_input poll_input;
  metil_function_scene_destroy destroy;

  struct metil_scene_rendering_properties rendering_properties;

  void* data;
};

void metil_scene_initialize(
  struct metil_scene*,
  id<MTLDevice>
);

void metil_scene_poll_input(
  struct metil_scene*,
  unsigned long int
);

void metil_scene_poll(
  struct metil_scene*,
  unsigned long int
);

void metil_scene_destroy(
  struct metil_scene*
);

void metil_scene_poll_input_default(
  struct metil_scene*
);

void metil_scene_poll_default(
  struct metil_scene*
);

void metil_scene_destroy_default(
  struct metil_scene*
);

#endif
