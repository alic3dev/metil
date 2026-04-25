#include <example_input.h>

#include <example_input_pipeline_index.h>
#include <example_input_scene.h>

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
    "example_model",
    example_input_renderer_on_initialize
  );
}

void example_input_renderer_on_initialize(
  struct metil* metil,
  void* data
) {
  metil_library_initialize(
    &metil->library,
    metil->renderer_interface.metal_device,
    @"model_fragment",
    @"model_vertex"
  );

  example_input_pipeline_index_model_item = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"model_item_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"model_item_vertex"
    ]
  ];

  struct metil_scene_controller* metil_scene_controller = (
    metil->scene_controller
  );

  example_input_scene_initialize(
    metil,
    &metil_scene_controller->scene
  );
}
