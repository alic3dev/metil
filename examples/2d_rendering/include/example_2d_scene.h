#ifndef __example_2d_scene_h
#define __example_2d_scene_h

#include <metil_scenes/scene.h>

#include <MetalKit/MetalKit.h>

void example_2d_scene_initialize(
  struct metil_scene*,
  id<MTLDevice>
);

void example_2d_scene_poll(
  struct metil_scene*
);

void example_2d_scene_destroy(
  struct metil_scene*
);

#endif
