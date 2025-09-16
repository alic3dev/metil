#ifndef __metil_scene_controller_h
#define __metil_scene_controller_h

#include <metil_scenes/scene.h>

typedef void (*metil_scene_controller_on_scene_change)(enum metil_scene_id, void*);

struct metil_scene_controller_structure {
  unsigned char length_on_scene_change;
  metil_scene_controller_on_scene_change* on_scene_change;
  void** on_scene_change_data;
};

extern struct metil_scene_controller_structure scene_controller;

void metil_scene_controller_initialize();

void metil_scene_controller_scene_change(
  enum metil_scene_id scene_id
);

void metil_scene_controller_on_scene_change_add(
  metil_scene_controller_on_scene_change,
  void*
);

void metil_scene_controller_destroy();

#endif
