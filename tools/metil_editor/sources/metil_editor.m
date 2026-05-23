#include <metil_editor.h>

#include <metil_editor_index_pipeline_render.h>
#include <metil_editor_scene.h>

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
    "metil_editor",
    metil_editor_renderer_on_initialize
  );
}

void metil_editor_renderer_on_initialize(
  struct metil* metil,
  void* data
) {
  metil->data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct metil_editor_index_pipeline_render
      )
    )
  );

  struct metil_editor_index_pipeline_render* metil_editor_index_pipeline_render = (
    metil->data
  );

  metil_library_initialize(
    &metil->library,
    metil->renderer_interface.metal_device,
    @"metil_editor_fragment",
    @"metil_editor_vertex"
  );

  metil_editor_index_pipeline_render->cursor = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"metil_editor_cursor_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"metil_editor_cursor_vertex"
    ]
  ];
  
  metil_editor_index_pipeline_render->grid_lines = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"metil_editor_grid_lines_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"metil_editor_grid_lines_vertex"
    ]
  ];

  metil->rendering_properties.camera.height_default = (
    0x00
  );

  metil->rendering_properties.camera.distance_view.near = (
    0.001f
  );

  metil_camera_normalization_set(
    &metil->rendering_properties.camera
  );

  metil->rendering_properties.camera.height = (
    metil->rendering_properties.camera.height_default
  );

  struct metil_scene_controller* metil_scene_controller = (
    metil->scene_controller
  );

  metil_editor_scene_initialize(
    metil,
    &metil_scene_controller->scene
  );
}
