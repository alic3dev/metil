#include <example_model.h>

#include <example_model_pipeline_index.h>
#include <example_model_scene.h>

#include <metil_initialize.h>
#include <metil_input/cursor.h>
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
    "example_model",
    example_model_renderer_on_initialize
  );
}

void example_model_renderer_on_initialize(
  struct metil_renderer_interface* metil_renderer_interface,
  void* data
) {
  metil_library_initialize(
    metil_renderer_interface->metal_device,
    @"model_fragment",
    @"model_vertex"
  );

  example_model_pipeline_index_model_item = [
    metil_renderer_interface->renderer
    pipeline_add: [
      metil_library.library
      newFunctionWithName: @"model_item_fragment"
    ]
    function_vertex: [
      metil_library.library
      newFunctionWithName: @"model_item_vertex"
    ]
  ];

  example_model_scene_initialize(
    &metil_scene_controller.scene,
    metil_renderer_interface
  );
}
