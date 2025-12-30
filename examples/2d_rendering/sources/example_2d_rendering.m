#include <example_2d_rendering.h>

#include <example_2d_scene.h>

#include <metil_initialize.h>
#include <metil_library.h>
#include <metil_rendering/metil_renderer_interface.h>
#include <metil_scenes/metil_scene_controller.h>

int main(
  int length_parameters,
  const char** parameters
) {
  return metil_initialize(
    length_parameters,
    parameters,
    "example_2d_rendering",
    example_2d_rendering_renderer_on_initialize
  );
}

void example_2d_rendering_renderer_on_initialize(
  struct metil_renderer_interface* metil_renderer_interface,
  void* data
) {
  metil_library_initialize(
    metil_renderer_interface->metal_device,
    @"shader_2d_fragment",
    @"shader_2d_vertex"
  );

  example_2d_scene_initialize(
    &metil_scene_controller.scene,
    metil_renderer_interface
  );
}
