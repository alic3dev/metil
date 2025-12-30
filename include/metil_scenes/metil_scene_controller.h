#ifndef __metil_scene_controller_h
#define __metil_scene_controller_h

#include <metil_scenes/metil_scene.h>

typedef void (*metil_scene_controller_on_scene_change)(int, void*);
typedef void (*metil_scene_controller_after_scene_change)(int, void*);

struct metil_scene_controller {
  struct metil_scene scene;

  unsigned char length_on_scene_change;
  metil_scene_controller_on_scene_change* on_scene_change;
  void** on_scene_change_data;

  unsigned char length_after_scene_change;
  metil_scene_controller_after_scene_change* after_scene_change;
  void** after_scene_change_data;
};

extern struct metil_scene_controller metil_scene_controller;

void metil_scene_controller_initialize();

void metil_scene_controller_scene_change(
  int scene_id
);

void metil_scene_controller_on_scene_change_add(
  metil_scene_controller_on_scene_change,
  void*
);

void metil_scene_controller_after_scene_change_add(
  metil_scene_controller_after_scene_change,
  void*
);

void metil_scene_controller_destroy();

#endif
