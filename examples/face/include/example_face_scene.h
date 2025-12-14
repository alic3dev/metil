#ifndef __example_face_scene_h
#define __example_face_scene_h

#include <metil_scenes/scene.h>

#include <Metal/MTLDevice.h>

void example_face_scene_initialize(
  struct metil_scene*,
  struct metil_renderer_interface*
);

void example_face_scene_poll(
  struct metil_scene*
);

void example_face_scene_destroy(
  struct metil_scene*
);

#endif
