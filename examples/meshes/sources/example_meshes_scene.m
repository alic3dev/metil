#include <example_meshes_scene.h>

#include <metil.h>

#include <metil_mesh/metil_mesh_2d/metil_mesh_circle.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_rectangle.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_square.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_triangle.h>

#include <metil_mesh/metil_mesh_ball.h>
#include <metil_mesh/metil_mesh_box.h>
#include <metil_mesh/metil_mesh_dollop.h>
#include <metil_mesh/metil_mesh_gem.h>
#include <metil_mesh/metil_mesh_mushroom.h>
#include <metil_mesh/metil_mesh_ring.h>
#include <metil_mesh/metil_mesh_shuttle.h>
#include <metil_mesh/metil_mesh_sphere.h>
#include <metil_mesh/metil_mesh_text.h>
#include <metil_mesh/metil_mesh_tube.h>

#include <metil_object.h>
#include <metil_player/metil_player.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/metil_scene.h>

#include <clic3_memory.h>

#include <math_c_vector.h>

void example_meshes_scene_initialize(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  metil_scene_initialize_with_renderables(
    metil,
    metil_scene,
    100
  );

  metil_scene->poll = (
    example_meshes_scene_poll
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

    struct metil_object* metil_object = (
      metil_scene->renderables[
        index_renderable
      ].renderable
    );

    struct metil_mesh* metil_mesh = (
      &metil_object->mesh
    );

    metil_mesh_ring_initialize(
      metil_mesh,
      (struct math_c_vector3_float) {
        .x = 10.0f,
        .y = 1.0f,
        .z = 10.0f
      },
      (struct math_c_vector3_float) {
        .x = 8.0f,
        .y = 0.0f,
        .z = 8.0f
      },
      (struct math_c_vector2_unsigned_short_int) {
        .x = 100,
        .y = 100
      }
    );

    metil_object_buffers_initialize(
      metil_object,
      metil->renderer_interface.metal_device
    );

    metil_object->position.x = ((index_renderable % 14) - 5) * 50.0f - 250.0f;
    metil_object->position.y = ((index_renderable % 16) - 2) * 10.0f - 30.0f;

    struct metil_renderer_data_object* data_object = (
      metil_object->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );
  }

  metil_scene->player.position.z = -100.0f;
}

void example_meshes_scene_poll(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  metil_scene_poll_default(
    metil,
    metil_scene
  );

  for (
    unsigned int index_renderable = 0;
    index_renderable < metil_scene->length_renderables;
    ++index_renderable
  ) {
    struct metil_object* metil_object_ring = (
      metil_scene->renderables[
        index_renderable
      ].renderable
    );

    metil_object_ring->rotation.x = (
      metil_object_ring->rotation.x +
      0.01543f
    );

    metil_object_ring->rotation.y = (
      metil_object_ring->rotation.y +
      0.03543f
    );
  }
}
