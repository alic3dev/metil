#include <example_2d_rendering.h>

#include <example_2d_rendering_index_pipeline.h>
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
  struct metil* metil,
  void* data
) {
  metil_library_initialize(
    &metil->library,
    metil->renderer_interface.metal_device,
    @"metil_example_2d_rendering_fragment",
    @"metil_example_2d_rendering_vertex"
  );

  example_2d_rendering_index_pipeline_background = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"metil_example_2d_rendering_background_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"metil_example_2d_rendering_background_vertex"
    ]
  ];

  example_2d_scene_initialize(
    metil,
    &((struct metil_scene_controller*) metil->scene_controller)->scene
  );
}
