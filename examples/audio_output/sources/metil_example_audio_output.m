#include <metil_example_audio_output.h>

#include <metil_example_audio_output_scene.h>

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
    "metil_example_audio_output",
    metil_example_audio_output_renderer_on_initialize
  );
}

void metil_example_audio_output_renderer_on_initialize(
  struct metil* metil,
  void* data
) {
  metil_library_initialize(
    &metil->library,
    metil->renderer_interface.metal_device,
    @"metil_example_audio_output_fragment",
    @"metil_example_audio_output_vertex"
  );

  struct metil_scene_controller* metil_scene_controller = (
    metil->scene_controller
  );

  metil_example_audio_output_scene_initialize(
    metil,
    &metil_scene_controller->scene
  );
}
