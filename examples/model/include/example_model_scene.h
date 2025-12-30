#ifndef __example_model_scene_h
#define __example_model_scene_h

#include <metil.h>
#include <metil_scenes/metil_scene.h>

void example_model_scene_initialize(
  struct metil*,
  struct metil_scene*
);

void example_model_scene_poll(
  struct metil_scene*
);

void example_model_scene_destroy(
  struct metil_scene*
);

#endif
