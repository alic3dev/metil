#include <example_collision.h>

#include <example_collision_pipeline_index.h>
#include <example_collision_scene.h>

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
    "example_collision",
    example_collision_renderer_on_initialize
  );
}

void example_collision_renderer_on_initialize(
  struct metil* metil,
  void* data
) {
  metil_library_initialize(
    &metil->library,
    metil->renderer_interface.metal_device,
    @"turret_fragment",
    @"turret_vertex"
  );

  metil->rendering_properties.fps_display = 1;

  example_collision_pipeline_index_turret_barrel = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"turret_barrel_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"turret_barrel_vertex"
    ]
  ];

  example_collision_pipeline_index_turret_sight = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"turret_sight_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"turret_sight_vertex"
    ]
  ];

  example_collision_pipeline_index_projectile = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"projectile_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"projectile_vertex"
    ]
  ];

  example_collision_pipeline_index_target = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"target_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"target_vertex"
    ]
  ];

  example_collision_pipeline_index_floor = [
    metil->renderer_interface.renderer
    pipeline_add: [
      metil->library.library
      newFunctionWithName: @"floor_fragment"
    ]
    function_vertex: [
      metil->library.library
      newFunctionWithName: @"floor_vertex"
    ]
  ];

  struct metil_scene_controller* metil_scene_controller = (
    metil->scene_controller
  );

  example_collision_scene_initialize(
    metil,
    &metil_scene_controller->scene
  );
}
