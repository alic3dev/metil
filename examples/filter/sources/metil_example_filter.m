#include <metil_example_filter.h>

#include <metil_example_filter_scene.h>
#include <metil_example_filter_pipeline_index.h>

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
    "metil_example_filter",
    metil_example_filter_renderer_on_initialize
  );
}

void metil_example_filter_renderer_on_initialize(
  struct metil* metil,
  void* data
) {
  metil->data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct metil_example_filter_pipeline_index
      )
    )
  );
  
  struct metil_example_filter_pipeline_index* metil_example_filter_pipeline_index = (
    metil->data
  );

  metil_library_initialize(
    &metil->library,
    metil->renderer_interface.metal_device,
    @"metil_example_filter_object_fragment",
    @"metil_example_filter_object_vertex"
  );
  
  metil_example_filter_pipeline_index->compute = (
    0x00
  );

  metil_example_filter_pipeline_index->fog = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"metil_example_filter_fog_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"metil_example_filter_fog_vertex"
    ]
  ];
  
  struct metil_scene_controller* metil_scene_controller = (
    metil->scene_controller
  );

  metil_example_filter_scene_initialize(
    metil,
    &metil_scene_controller->scene
  );
}
