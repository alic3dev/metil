#include <example_face.h>

#include <example_face_pipeline_index.h>
#include <example_face_scene.h>

#include <metil.h>
#include <metil_initialize.h>
#include <metil_input/metil_cursor.h>
#include <metil_library.h>
#include <metil_scenes/metil_scene_controller.h>

int main(
  int length_parameters,
  const char** parameters
) {
  return metil_initialize(
    length_parameters,
    parameters,
    "example_face",
    example_face_renderer_on_initialize
  );
}

void example_face_renderer_on_initialize(
  struct metil* metil,
  void* data
) {
  metil_cursor_lockable_unset();

  metil_library_initialize(
    &metil->library,
    metil->renderer_interface.metal_device,
    @"face_fragment",
    @"face_vertex"
  );

  example_face_pipeline_index_face_points = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"face_points_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"face_points_vertex"
    ]
  ];

  example_face_scene_initialize(
    metil,
    &((struct metil_scene_controller*) metil->scene_controller)->scene
  );
}
