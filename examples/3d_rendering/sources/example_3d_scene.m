#include <example_3d_scene.h>

#include <metil_mesh/mesh_box.h>
#include <metil_object.h>
#include <metil_player.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/scene.h>

#include <clic3_vector.h>

#include <Metal/MTLDevice.h>

#include <math.h>
#include <stdlib.h>

void example_3d_scene_initialize(
  struct metil_scene* scene,
  id<MTLDevice> metal_device
) {
  metil_scene_initialize(
    scene,
    metal_device
  );

  scene->player.poll_input = metil_player_poll_input_null;

  scene->type = metil_scene_type_game;
  scene->id = 0;

  scene->poll = example_3d_scene_poll;

  scene->length_renderables = 100;
  scene->renderables = realloc(
    scene->renderables,
    sizeof(struct metil_renderable) *
    scene->length_renderables
  );

  struct metil_object* object = (
    (void*)0
  );

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

    object = (
      scene->renderables[
        index_renderable
      ].renderable
    );

    metil_mesh_box_initialize(
      &object->mesh,
      (struct clic3_vector3_float) {
        .x = 0.1f,
        .y = 0.1f,
        .z = 0.1f
      }
    );

    metil_object_buffers_initialize(
      object,
      metal_device
    );

    struct metil_renderer_data_object* data_object = (
      object->data.contents
    );

    data_object->id = index_renderable;
    data_object->color.x = (
      (float) (index_renderable % 10) / 10.0f
    );
    data_object->color.y = (
      (float) ((index_renderable + 3) % 10) / 10.0f
    );
    data_object->color.z = (
      (float) ((index_renderable + 5) % 10) / 10.0f
    );
    data_object->color.w = 1.0f;

    object->position.z = (
      1.0f
    );
  }
}

void example_3d_scene_poll(
  struct metil_scene* scene
) {
  metil_scene_poll_default(scene);

  struct metil_object* object = (
    (void*)0
  );

  struct metil_renderer_data_object* data_object = (
    (void*)0
  );

  for (
    unsigned char index_renderable = 0;
    index_renderable < scene->length_renderables;
    ++index_renderable
  ) {
    object = (
      scene->renderables[
        index_renderable
      ].renderable
    );

    float angle = (
      (float) scene->time_elapsed / 1000.0f +
      (float) (index_renderable) /
      (float) scene->length_renderables *
      M_PI *
      4.0f
    );

    data_object = (
      object->data.contents
    );

    float distance = 2.0f;

    object->position.x = (
      (index_renderable % 2 == 0 ? -1 : 1) *
      sin(angle) *
      distance / 2.0f
    );

    object->position.y = (
      (index_renderable % 2 == 0 ? -1 : 1) *
      cos(angle) *
      distance / 2.0f
    );

    object->position.z = 2.0f;

    object->rotation.y = fmod(
      scene->time_elapsed / (
        10000.0f *
        (float) ((index_renderable % 10) + 1)
      ),
      (M_PI * 2.0f)
    );

    object->rotation.x = fmod(
      scene->time_elapsed / (
        11000.0f *
        (float) (((index_renderable + 2) % 10) + 1)
      ),
      (M_PI * 2.0f)
    );

    object->rotation.z = fmod(
      scene->time_elapsed / (
        12000.0f *
        (float) (((index_renderable + 3) % 10) + 1)
      ),
      (M_PI * 2.0f)
    );
  }
}
