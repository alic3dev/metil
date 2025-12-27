#ifndef __example_model_scene_h
#define __example_model_scene_h

#include <metil_scenes/scene.h>
#include <metil_rendering/metil_renderer_interface.h>

void example_model_scene_initialize(
  struct metil_scene*,
  struct metil_renderer_interface*
);

void example_model_scene_poll(
  struct metil_scene*
);

void example_model_scene_destroy(
  struct metil_scene*
);

#endif
