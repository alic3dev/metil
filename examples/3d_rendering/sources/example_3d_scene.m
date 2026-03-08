#include <example_3d_scene.h>

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
    1
  );

  metil_scene->poll = (
    example_3d_scene_poll
  );

  for (
    unsigned int index_renderable = 0;
    index_renderable < metil_scene->length_renderables;
    ++index_renderable
  ) {
    metil_renderable_initialize_at_index(
      metil_scene->renderables,
      index_renderable,
      metil_renderable_type_object
    );

    struct metil_object* metil_object_ground = (
      metil_scene->renderables[
        index_renderable
      ].renderable
    );

    metil_mesh_celled_triangles_quadruple_grid_initialize(
      &metil_object_ground->mesh,
      (struct math_c_vector2_float) {
        .x = 500.0f,
        .y = 500.0f
      },
      (struct math_c_vector2_unsigned_long_int) {
        .x = 500,
        .y = 500
      }
    );

    metil_object_buffers_initialize(
      metil_object_ground,
      metil->renderer_interface.metal_device
    );

    metil_object_ground->index_pipeline_render = (
      example_3d_rendering_index_pipeline_ground
    );

    struct metil_renderer_data_object* data_object = (
      metil_object_ground->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );

    metil_object_ground->rotation.x = (
      math_c_pi_half
    );

    data_object->colour.x = (
      0.7  
    );

    data_object->colour.y = (
      0.5
    );

    data_object->colour.z = (
      0.4
    );

    data_object->colour.w = 1.0f;
  }
}

void example_3d_scene_poll(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  metil_scene_poll_default(
    metil,
    metil_scene
  );
}
