#include <example_fog_scene.h>

#include <example_fog_pipeline_index.h>
#include <example_fog_values.h>

#include <metil.h>
#include <metil_mesh/metil_mesh_ball.h>
#include <metil_mesh/metil_mesh_dollop.h>
#include <metil_mesh/metil_mesh_gem.h>
#include <metil_mesh/metil_mesh_mushroom.h>
#include <metil_mesh/metil_mesh_shuttle.h>
#include <metil_mesh/metil_mesh_tube.h>
#include <metil_object.h>
#include <metil_player/metil_player.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderable_type.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/metil_scene.h>

#include <math_c_vector.h>

void example_fog_scene_initialize(
  struct metil* metil,
  struct metil_scene* scene
) {
  metil_scene_initialize_with_renderables(
    metil,
    scene,
    2000
  );

  scene->poll = example_fog_scene_poll;

  struct metil_object* object = (
    0
  );

  for (
    unsigned int index_renderable = 1;
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

    switch (
      index_renderable % 6
    ) {
      case 0: {
        metil_mesh_dollop_initialize(
          &object->mesh,
          (struct math_c_vector3_float) {
            .x = 10.0f,
            .y = 10.0f,
            .z = 10.0f
          }, (struct math_c_vector2_unsigned_short_int) {
            .x = 10,
            .y = 10
          }
        );
        break;
      }
      case 1: {
        metil_mesh_gem_initialize(
          &object->mesh,
          (struct math_c_vector3_float) {
            .x = 10.0f,
            .y = 10.0f,
            .z = 10.0f
          }, (struct math_c_vector2_unsigned_short_int) {
            .x = 10,
            .y = 10
          }
        );
        break;
      }
      case 2: {
        metil_mesh_mushroom_initialize(
          &object->mesh,
          (struct math_c_vector3_float) {
            .x = 10.0f,
            .y = 10.0f,
            .z = 10.0f
          }, (struct math_c_vector2_unsigned_short_int) {
            .x = 10,
            .y = 10
          }
        );
        break;
      }
      case 3: {
        metil_mesh_shuttle_initialize(
          &object->mesh,
          (struct math_c_vector3_float) {
            .x = 10.0f,
            .y = 10.0f,
            .z = 10.0f
          }, (struct math_c_vector2_unsigned_short_int) {
            .x = 10,
            .y = 10
          }
        );
        break;
      }
      case 4: {
        metil_mesh_tube_initialize(
          &object->mesh,
          (struct math_c_vector3_float) {
            .x = 10.0f,
            .y = 10.0f,
            .z = 10.0f
          }, (struct math_c_vector2_unsigned_short_int) {
            .x = 10,
            .y = 10
          },
          0
        );
        break;
      }
      case 5: {
        metil_mesh_ball_initialize(
          &object->mesh,
          2.0f * ((index_renderable * 3) % 10),
          (struct math_c_vector2_unsigned_short_int) {
            .x = 10 + (
              index_renderable % 2
            ),
            .y = 10 + (
              index_renderable % 3 == 0 ? 1 : 0
            )
          }
        );
        break;
      }
    }

    metil_object_buffers_initialize(
      object,
      metil->renderer_interface.metal_device
    );

    object->position.x = ((float) (
      index_renderable % 21 + index_renderable % 32
    ) / 53.0f - 0.5f) * 1000.0f;

    object->position.y = (
      object->mesh.size.y +
      index_renderable % 30
    );

    object->position.z = ((float) (
      index_renderable % 34 + index_renderable % 23
    ) / 57.0f - 0.5f) * 1000.0f;

    object->rotation.x = (
      (float) index_renderable *
      34.34f
    );

    object->rotation.y = (
      (float) index_renderable *
      25.34f
    );

    object->rotation.z = (
      (float) index_renderable *
      98.11f
    );

    struct metil_renderer_data_object* data_object = (
      object->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );

    data_object->colour.x = (
      (float) (index_renderable % 10) / 10.0f
    );

    data_object->colour.y = (
      (float) ((index_renderable + 3) % 10) / 10.0f
    );

    data_object->colour.z = (
      (float) ((index_renderable + 5) % 10) / 10.0f
    );

    data_object->colour.w = 1.0f;
  }

  metil_renderable_initialize_at_index(
    scene->renderables,
    0,
    metil_renderable_type_object
  );

  object = (
    scene->renderables[
      0
    ].renderable
  );

  metil_mesh_ball_initialize(
    &object->mesh,
    fog_distance_maximum,
    (struct math_c_vector2_unsigned_short_int) {
      .x = 100,
      .y = 100
    }
  );

  metil_object_buffers_initialize(
    object,
    metil->renderer_interface.metal_device
  );

  struct metil_renderer_data_object* data_object = (
    object->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  data_object->colour.x = (
    1.0f
  );

  data_object->colour.y = (
    1.0f
  );

  data_object->colour.z = (
    1.0f
  );

  data_object->colour.w = (
    fog_thickness_maximum
  );

  object->index_pipeline_render = (
    example_face_pipeline_index_fog
  );

  object->depth_disabled = 1;

  object->rotation.x = M_PI / 2.0f;
  object->rotation.z = M_PI / 2.0f;

  scene->player.speed_movement = (
    scene->player.speed_movement *
    10.0f
  );
}

void example_fog_scene_poll(
  struct metil* metil,
  struct metil_scene* scene
) {
  metil_scene_poll_default(
    metil,
    scene
  );

  struct metil_object* object = (
    scene->renderables[
      0
    ].renderable
  );

  object->position.x = scene->player.position.x;
  object->position.y = scene->player.position.y;
  object->position.z = scene->player.position.z;
}
