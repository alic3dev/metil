#include <example_3d_scene.h>

#include <3d_rendering_objects/3d_rendering_ground.h>
#include <3d_rendering_objects/3d_rendering_sky.h>
#include <example_3d_rendering_index_pipeline.h>

#include <metil.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_grid.h>
#include <metil_object.h>
#include <metil_player/metil_player.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderable_type.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/metil_scene.h>

#include <clic3_memory.h>

#include <math_c_absolute.h>
#include <math_c_pi.h>
#include <math_c_vector.h>

void example_3d_scene_initialize(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  metil_scene_initialize_with_renderables(
    metil,
    metil_scene,
    example_3d_scene_length_renderables
  );

  metil_scene->poll = (
    example_3d_scene_poll
  );

  for (
    unsigned int index_renderable = 0;
    index_renderable < metil_scene->length_renderables;
    ++index_renderable
  ) {
    switch (
      index_renderable
    ) {
      case example_3d_scene_index_renderable_sky:
      case example_3d_scene_index_renderable_ground:
      default: {
        metil_renderable_initialize_at_index(
          metil_scene->renderables,
          index_renderable,
          metil_renderable_type_object
        );

        break;
      }
    }
  }
  struct metil_object* metil_object_sky = (
    metil_scene->renderables[
      example_3d_scene_index_renderable_sky
    ].renderable
  );

  metil_example_3d_rendering_sky_initialize(
    metil,
    metil_object_sky
  );

  struct metil_object* metil_object_ground = (
    metil_scene->renderables[
      example_3d_scene_index_renderable_ground
    ].renderable
  );

  metil_example_3d_rendering_ground_initialize(
    metil,
    metil_object_ground
  );
}

void example_3d_scene_poll(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  struct metil_object* metil_object_sky = (
    metil_scene->renderables[
      example_3d_scene_index_renderable_sky
    ].renderable
  );

  metil_object_sky->rotation.y = (
    metil_object_sky->rotation.y +
    -0.00001f *
    metil_scene->time_delta
  );

  metil_scene_poll_default(
    metil,
    metil_scene
  );
}
