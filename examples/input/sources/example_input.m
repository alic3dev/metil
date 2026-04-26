#include <example_input.h>

#include <example_input_pipeline_index.h>
#include <example_input_scene.h>

#include <clic3_memory.h>

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
    "example_input",
    example_input_renderer_on_initialize
  );
}

void example_input_renderer_on_initialize(
  struct metil* metil,
  void* data
) {
  metil->data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct example_input_pipeline_index
      )
    )
  );

  struct example_input_pipeline_index* example_input_pipeline_index = (
    metil->data
  );

  example_input_pipeline_index_initialize(
    example_input_pipeline_index
  );

  metil_library_initialize(
    &metil->library,
    metil->renderer_interface.metal_device,
    @"example_input_ground_fragment",
    @"example_input_ground_vertex"
  );

  example_input_pipeline_index->model_player_body = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"example_input_model_player_body_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"example_input_model_player_body_vertex"
    ]
  ];

  example_input_pipeline_index->model_player_shirt = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"example_input_model_player_shirt_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"example_input_model_player_shirt_vertex"
    ]
  ];

  example_input_pipeline_index->model_player_pants = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"example_input_model_player_pants_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"example_input_model_player_pants_vertex"
    ]
  ];

  example_input_pipeline_index->model_skateboard_deck = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"example_input_model_skateboard_deck_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"example_input_model_skateboard_deck_vertex"
    ]
  ];

  example_input_pipeline_index->model_skateboard_truck = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"example_input_model_skateboard_truck_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"example_input_model_skateboard_truck_vertex"
    ]
  ];

  example_input_pipeline_index->model_skateboard_wheel = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"example_input_model_skateboard_wheel_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"example_input_model_skateboard_wheel_vertex"
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
