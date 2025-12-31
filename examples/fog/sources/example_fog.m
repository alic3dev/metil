#include <example_fog.h>

#include <example_fog_scene.h>

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
    "example_fog",
    example_fog_renderer_on_initialize
  );
}

void example_fog_renderer_on_initialize(
  struct metil* metil,
  void* data
) {

  metil->rendering_properties.mode = metil_rendering_properties_mode_wireframe;
  // metil->rendering_properties.camera.distance_view.far = 100.0f;

  metil_library_initialize(
    &metil->library,
    metil->renderer_interface.metal_device,
    @"fog_object_fragment",
    @"fog_object_vertex"
  );

  example_fog_scene_initialize(
    metil,
    &metil_scene_controller.scene
  );
}
