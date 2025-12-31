#include <example_2d_scene.h>

#include <metil.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_square.h>
#include <metil_object.h>
#include <metil_player/metil_player.h>
#include <metil_positioning.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/metil_scene.h>

#include <clic3_vector.h>

#include <stdlib.h>

void example_2d_scene_initialize(
  struct metil* metil,
  struct metil_scene* scene
) {
  metil_scene_initialize_with_renderables(
    scene,
    &metil->renderer_interface,
    100
  );

  scene->player.poll_input = metil_player_poll_input_null;

  scene->poll = example_2d_scene_poll;

  for (
    unsigned char index_renderable = 0;
    index_renderable < scene->length_renderables;
    ++index_renderable
  ) {
    metil_renderable_initialize_at_index(
      scene->renderables,
      index_renderable,
      metil_renderable_type_object
    );

    struct metil_object* object = (
      scene->renderables[
        index_renderable
      ].renderable
    );

    metil_mesh_square_initialize(
      &object->mesh,
      0.2f
    );

    object->positioning = (
      metil_positioning_absolute
    );

    metil_object_buffers_initialize(
      object,
      scene->renderer_interface->metal_device
    );

    struct metil_renderer_data_object* data_object = (
      object->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );

    data_object->color.x = (
      (float) index_renderable /
      (scene->length_renderables - 1)
    );

    data_object->color.y = (
      (float) ((index_renderable + 33) % scene->length_renderables) /
      (scene->length_renderables - 1)
    );

    data_object->color.z = (
      (float) ((index_renderable + 66) % scene->length_renderables) /
      (scene->length_renderables - 1)
    );

    data_object->color.w = 1.0f;

    object->position.x = (
      (float) (index_renderable % 10)
    ) * 0.2f - 0.9f;

    object->position.y = (
      (float) (index_renderable / 10)
    ) * 0.2f - 0.9f;

    object->position.z = (
      1.0f
    );
  }
}

void example_2d_scene_poll(
  struct metil_scene* scene
) {
  metil_scene_poll_default(scene);

  float brightness_minimum = 0.25f;

  for (
    unsigned char index_renderable = 0;
    index_renderable < scene->length_renderables;
    ++index_renderable
  ) {
    struct metil_renderer_data_object* data_object = (
      (struct metil_object*) scene->renderables[
        index_renderable
      ].renderable
    )->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents;

    struct clic3_vector3_unsigned_int time_offset = {
      .x = scene->time + (index_renderable + 2) * 20,
      .y = scene->time + (index_renderable + 3) * 30,
      .z = scene->time + (index_renderable + 1) * 10
    };

    data_object->color.x = (
      ((time_offset.x / 1000) % 2 == 0
        ? (float) (time_offset.x % 1000) / 1500.0f
        : (float) (1000 - (time_offset.x % 1000)) / 1500.0f
      ) +
      brightness_minimum
    );
    data_object->color.y = (
      ((time_offset.y / 1000) % 2 == 0
        ? (float) (time_offset.y % 1000) / 1500.0f
        : (float) (1000 - (time_offset.y % 1000)) / 1500.0f
      ) +
      brightness_minimum
    );
    data_object->color.z = (
      ((time_offset.z / 1000) % 2 == 0
        ? (float) (time_offset.z % 1000) / 1500.0f
        : (float) (1000 - (time_offset.z % 1000)) / 1500.0f
      ) +
      brightness_minimum
    );
  }
}
