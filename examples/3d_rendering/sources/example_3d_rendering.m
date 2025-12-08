#include <example_3d_rendering.h>

#include <example_3d_scene.h>

#include <metil_initialize.h>
#include <metil_library.h>
#include <metil_rendering/metil_renderer_interface.h>
#include <metil_scenes/scene_controller.h>

int main(
  int length_parameters,
  const char** parameters
) {
  return metil_initialize(
    length_parameters,
    parameters,
    "example_3d_rendering",
    example_3d_rendering_renderer_on_initialize
  );
}

void example_3d_rendering_renderer_on_initialize(
  struct metil_renderer_interface* metil_renderer_interface,
  void* data
) {
  metil_library_initialize(
    metil_renderer_interface->metal_device,
    @"shader_3d_fragment",
    @"shader_3d_vertex"
  );

  example_3d_scene_initialize(
    &metil_scene_controller.scene,
    metil_renderer_interface->metal_device
  );
}
