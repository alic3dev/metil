#include <example_fog.h>

#include <example_fog_scene.h>
#include <example_fog_pipeline_index.h>

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

  metil_library_initialize(
    &metil->library,
    metil->renderer_interface.metal_device,
    @"fog_object_fragment",
    @"fog_object_vertex"
  );

  example_face_pipeline_index_fog = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"fog_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"fog_vertex"
    ]
  ];

  example_fog_scene_initialize(
    metil,
    &((struct metil_scene_controller*) metil->scene_controller)->scene
  );
}
