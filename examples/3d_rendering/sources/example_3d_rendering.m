#include <example_3d_rendering.h>

#include <example_3d_scene.h>

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
    "example_3d_rendering",
    example_3d_rendering_renderer_on_initialize
  );
}

void example_3d_rendering_renderer_on_initialize(
  struct metil* metil,
  void* data
) {
  metil_library_initialize(
    &metil->library,
    metil->renderer_interface.metal_device,
    @"shader_3d_fragment",
    @"shader_3d_vertex"
  );

  metil->rendering_properties.colour_clear.x = (
    0.724f
  );

  metil->rendering_properties.colour_clear.y = (
    0.832f
  );

  metil->rendering_properties.colour_clear.z = (
    0.934f
  );

  example_3d_scene_initialize(
    metil,
    &((struct metil_scene_controller*) metil->scene_controller)->scene
  );
}
