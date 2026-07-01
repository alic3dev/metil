#include <metil_example_filter_scene.h>

#include <metil_example_filter_pipeline_index.h>
#include <metil_example_filter_values.h>

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

#include <math_c_pi.h>
#include <math_c_vector.h>

void metil_example_filter_scene_initialize(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  metil_scene_initialize_with_renderables(
    metil,
    metil_scene,
    0x07d0
  );

  struct metil_example_filter_pipeline_index* metil_example_filter_pipeline_index = (
    metil->data
  );

  metil_scene->poll = (
    metil_example_filter_scene_poll
  );

  struct metil_object* metil_object = (
    0x00
  );

  for (
    unsigned int index_renderable = (
      0x01
    );
    (
      index_renderable <
      metil_scene->length_renderables
    );
    ++index_renderable
  ) {
    metil_renderable_initialize_at_index(
      metil_scene->renderables,
      index_renderable,
      metil_renderable_type_object
    );

    metil_object = (
      metil_scene->renderables[
        index_renderable
      ].renderable
    );

    switch (
      index_renderable %
      0x06
    ) {
      case 0x00: {
        metil_mesh_dollop_initialize(
          &metil_object->mesh,
          (struct math_c_vector3_float) {
            .x = (
              0x0a
            ),
            .y = (
              0x0a
            ),
            .z = (
              0x0a
            )
          },
          (struct math_c_vector2_unsigned_short_int) {
            .x = (
              0x0a
            ),
            .y = (
              0x0a
            )
          }
        );

        break;
      }
      case 0x01: {
        metil_mesh_gem_initialize(
          &metil_object->mesh,
          (struct math_c_vector3_float) {
            .x = (
              0x0a
            ),
            .y = (
              0x0a
            ),
            .z = (
              0x0a
            )
          },
          (struct math_c_vector2_unsigned_short_int) {
            .x = (
              0x0a
            ),
            .y = (
              0x0a
            )
          }
        );

        break;
      }
      case 0x02: {
        metil_mesh_mushroom_initialize(
          &metil_object->mesh,
          (struct math_c_vector3_float) {
            .x = (
              0x0a
            ),
            .y = (
              0x0a
            ),
            .z = (
              0x0a
            )
          },
          (struct math_c_vector2_unsigned_short_int) {
            .x = (
              0x0a
            ),
            .y = (
              0x0a
            )
          }
        );

        break;
      }
      case 0x03: {
        metil_mesh_shuttle_initialize(
          &metil_object->mesh,
          (struct math_c_vector3_float) {
            .x = (
              0x0a
            ),
            .y = (
              0x0a
            ),
            .z = (
              0x0a
            )
          },
          (struct math_c_vector2_unsigned_short_int) {
            .x = (
              0x0a
            ),
            .y = (
              0x0a
            )
          }
        );

        break;
      }
      case 0x04: {
        metil_mesh_tube_initialize(
          &metil_object->mesh,
          (struct math_c_vector3_float) {
            .x = (
              0x0a
            ),
            .y = (
              0x0a
            ),
            .z = (
              0x0a
            )
          },
          (struct math_c_vector2_unsigned_short_int) {
            .x = (
              0x0a
            ),
            .y = (
              0x0a
            )
          },
          0x00
        );

        break;
      }
      case 0x05: {
        metil_mesh_ball_initialize(
          &metil_object->mesh,
          (
            0x02 *
            (
              (
                index_renderable *
                0x03
              ) %
              0x0a
            )
          ),
          (struct math_c_vector2_unsigned_short_int) {
            .x = (
              0x0a +
              (
                index_renderable %
                0x02
              )
            ),
            .y = (
              0x0a +
              (
                (
                  (
                    index_renderable %
                    0x03
                  ) ==
                  0x00
                )
                ? 0x01
                : 0x00
              )
            )
          }
        );

        break;
      }
    }

    metil_object_buffers_initialize(
      metil_object,
      metil->renderer_interface.metal_device
    );

    metil_object->position.x = (
      (
        (float)
        (
          index_renderable %
          0x15 +
          index_renderable %
          0x20
        ) /
        0x35 -
        0.5f
      ) *
      0x03e8
    );

    metil_object->position.y = (
      metil_object->mesh.size.y +
      index_renderable %
      0x1e
    );

    metil_object->position.z = (
      (
        (float)
        (
          index_renderable %
          0x22 +
          index_renderable %
          0x17
        ) /
        0x39 -
        0.5f
      ) *
      0x03e8
    );

    metil_object->rotation.x = (
      (float)
      index_renderable *
      34.34f
    );

    metil_object->rotation.y = (
      (float)
      index_renderable *
      25.34f
    );

    metil_object->rotation.z = (
      (float)
      index_renderable *
      98.11f
    );

    struct metil_renderer_data_object* metil_renderer_data_object = (
      metil_object->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );

    metil_renderer_data_object->colour.x = (
      (float)
      (
        index_renderable %
        0x0a
       ) /
       0x0a
    );

    metil_renderer_data_object->colour.y = (
      (float)
      (
        (
          index_renderable +
          0x03
        ) %
        0x0a
      ) /
      0x0a
    );

    metil_renderer_data_object->colour.z = (
      (float)
      (
        (
          index_renderable +
          0x05
        ) %
        0x0a
      ) /
      0x0a
    );
  }

  metil_renderable_initialize_at_index(
    metil_scene->renderables,
    0x00,
    metil_renderable_type_object
  );

  metil_object = (
    metil_scene->renderables[
      0x00
    ].renderable
  );

  metil_mesh_ball_initialize(
    &metil_object->mesh,
    fog_distance_maximum,
    (struct math_c_vector2_unsigned_short_int) {
      .x = (
        0x64
      ),
      .y = (
        0x64
      )
    }
  );

  metil_object_buffers_initialize(
    metil_object,
    metil->renderer_interface.metal_device
  );

  struct metil_renderer_data_object* metil_renderer_data_object = (
    metil_object->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  metil_renderer_data_object->colour.w = (
    fog_thickness_maximum
  );

  metil_object->index_pipeline_render = (
    metil_example_filter_pipeline_index->fog
  );

  metil_object->depth_disabled = (
    0x01
  );

  metil_object->rotation.x = (
    math_c_pi_half
  );

  metil_object->rotation.z = (
    math_c_pi_half
  );

  metil_scene->player.speed_movement = (
    metil_scene->player.speed_movement *
    0x0a
  );
}

void metil_example_filter_scene_poll(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  metil_scene_poll_default(
    metil,
    metil_scene
  );

  struct metil_object* metil_object = (
    metil_scene->renderables[
      0x00
    ].renderable
  );

  metil_object->position.x = (
    metil_scene->player.position.x
  );

  metil_object->position.y = (
    metil_scene->player.position.y
  );

  metil_object->position.z = (
    metil_scene->player.position.z
  );
}
