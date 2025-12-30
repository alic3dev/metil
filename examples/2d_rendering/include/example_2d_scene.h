#ifndef __example_2d_scene_h
#define __example_2d_scene_h

#include <metil_rendering/metil_renderer_interface.h>
#include <metil_scenes/metil_scene.h>

void example_2d_scene_initialize(
  struct metil_scene*,
  struct metil_renderer_interface* metil_renderer_interface
);

void example_2d_scene_poll(
  struct metil_scene*
);

#endif
