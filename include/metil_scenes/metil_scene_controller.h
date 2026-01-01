#ifndef __metil_scenes_metil_scene_controller_h
#define __metil_scenes_metil_scene_controller_h

#include <metil.h>
#include <metil_scenes/metil_scene.h>

typedef void (*metil_scene_controller_on_scene_change)(
  struct metil* _Nonnull,
  int,
  void* _Nullable
);

typedef void (*metil_scene_controller_after_scene_change)(
  struct metil* _Nonnull,
  int,
  void* _Nullable
);

struct metil_scene_controller {
  struct metil_scene scene;

  unsigned char length_on_scene_change;
  metil_scene_controller_on_scene_change _Nonnull * _Nonnull on_scene_change;
  void* _Nonnull * _Nullable on_scene_change_data;

  unsigned char length_after_scene_change;
  metil_scene_controller_after_scene_change _Nonnull * _Nonnull after_scene_change;
  void* _Nonnull * _Nullable after_scene_change_data;
};

void metil_scene_controller_initialize(
  struct metil* _Nonnull,
  struct metil_scene_controller* _Nonnull
);

void metil_scene_controller_scene_change(
  struct metil* _Nonnull,
  struct metil_scene_controller* _Nonnull,
  int
);

void metil_scene_controller_on_scene_change_add(
  struct metil_scene_controller* _Nonnull,
  metil_scene_controller_on_scene_change _Nonnull,
  void* _Nullable
);

void metil_scene_controller_after_scene_change_add(
  struct metil_scene_controller* _Nonnull,
  metil_scene_controller_after_scene_change _Nonnull,
  void* _Nullable
);

void metil_scene_controller_destroy(
  struct metil* _Nonnull,
  struct metil_scene_controller* _Nonnull
);

#endif
