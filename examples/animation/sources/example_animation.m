#include <example_animation.h>

#include <example_animation_scene.h>

#include <metil.h>
#include <metil_initialize.h>
#include <metil_library.h>
#include <metil_scenes/metil_scene_controller.h>

int main(
  int length_parameters,
  const char** parameters
) {
  return metil_initialize(
    length_parameters,
    parameters,
    "example_animation",
    example_animation_renderer_on_initialize
  );
}

void example_animation_renderer_on_initialize(
  struct metil* metil,
  void* data
) {
  metil_library_initialize(
    &metil->library,
    metil->renderer_interface.metal_device,
    @"shader_example_animation_fragment",
    @"shader_example_animation_vertex"
  );

  example_animation_scene_initialize(
    metil,
    &((struct metil_scene_controller*) metil->scene_controller)->scene
  );
}
