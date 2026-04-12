#include <example_3d_rendering.h>

#include <example_3d_rendering_index_pipeline.h>
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

  example_3d_rendering_index_pipeline_ground = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"example_3d_rendering_ground_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"example_3d_rendering_ground_vertex"
    ]
  ];

  example_3d_rendering_index_pipeline_sky = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"metil_example_3d_rendering_sky_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"metil_example_3d_rendering_sky_vertex"
    ]
  ];

  metil->rendering_properties.colour_clear.x = (
    0.0f
  );

  metil->rendering_properties.colour_clear.y = (
    0.0f
  );

  metil->rendering_properties.colour_clear.z = (
    0.0f
  );

  struct metil_scene_controller* metil_scene_controller = (
    metil->scene_controller
  );

  example_3d_scene_initialize(
    metil,
    &metil_scene_controller->scene
  );
}
