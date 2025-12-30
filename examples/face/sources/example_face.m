#include <example_face.h>

#include <example_face_pipeline_index.h>
#include <example_face_scene.h>

#include <metil_initialize.h>
#include <metil_input/metil_cursor.h>
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
    "example_face",
    example_face_renderer_on_initialize
  );
}

void example_face_renderer_on_initialize(
  struct metil_renderer_interface* metil_renderer_interface,
  void* data
) {
  metil_input_cursor_lockable_unset();

  metil_library_initialize(
    metil_renderer_interface->metal_device,
    @"face_fragment",
    @"face_vertex"
  );

  example_face_pipeline_index_face_points = [
    metil_renderer_interface->renderer
    pipeline_add: [
      metil_library.library
      newFunctionWithName: @"face_points_fragment"
    ]
    function_vertex: [
      metil_library.library
      newFunctionWithName: @"face_points_vertex"
    ]
  ];

  example_face_scene_initialize(
    &metil_scene_controller.scene,
    metil_renderer_interface
  );
}
