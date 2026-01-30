#include <example_meshes_scene.h>

#include <metil.h>

/* 2d meshes */
#include <metil_mesh/metil_mesh_2d/metil_mesh_circle.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_rectangle.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_square.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_triangle.h>

/* 3d meshes */
#include <metil_mesh/metil_mesh_ball.h>
#include <metil_mesh/metil_mesh_box.h>
#include <metil_mesh/metil_mesh_dollop.h>
#include <metil_mesh/metil_mesh_gem.h>
#include <metil_mesh/metil_mesh_mushroom.h>
#include <metil_mesh/metil_mesh_ring.h>
#include <metil_mesh/metil_mesh_shuttle.h>
#include <metil_mesh/metil_mesh_sphere.h>
#include <metil_mesh/metil_mesh_tube.h>

#include <metil_object.h>
#include <metil_player/metil_player.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/metil_scene.h>

#include <clic3_memory.h>

#include <math_c_pi.h>
#include <math_c_vector.h>

void example_meshes_scene_initialize(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  metil_scene_initialize_with_renderables(
    metil,
    metil_scene,
    13
  );

  metil_scene->poll = (
    example_meshes_scene_poll
  );

  float width = (
    metil_scene->length_renderables *
    20.0f
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

    switch (
      index_renderable %
      13
    ) {
      case 0: {
        metil_mesh_circle_initialize(
          metil_mesh,
          10.0f,
          100
        );

        break;
      }
      case 1: {
        metil_mesh_rectangle_initialize(
          metil_mesh,
          (struct math_c_vector2_float) {
            .x = 10.0f,
            .y = 5.0f
          }
        );

        break;
      }
      case 2: {
        metil_mesh_square_initialize(
          metil_mesh,
          10.0f
        );

        break;
      }
      case 3: {
        metil_mesh_triangle_initialize(
          metil_mesh,
          (struct math_c_vector2_float) {
            .x = 10.0f,
            .y = 10.0f
          }
        );

        break;
      }
      case 4: {
        metil_mesh_ball_initialize(
          metil_mesh,
          10,
          (struct math_c_vector2_unsigned_short_int) {
            .x = 100,
            .y = 100
          }
        );

        break;
      }
      case 5: {
        metil_mesh_box_initialize(
          metil_mesh,
          (struct math_c_vector3_float) {
            .x = 10.0f,
            .y = 10.0f,
            .z = 10.0f
          }
        );

        break;
      }
      case 6: {
        metil_mesh_dollop_initialize(
          metil_mesh,
          (struct math_c_vector3_float) {
            .x = 10.0f,
            .y = 10.0f,
            .z = 10.0f
          },
          (struct math_c_vector2_unsigned_short_int) {
            .x = 100,
            .y = 100
          }
        );

        break;
      }
      case 7: {
        metil_mesh_gem_initialize(
          metil_mesh,
          (struct math_c_vector3_float) {
            .x = 10.0f,
            .y = 10.0f,
            .z = 10.0f
          },
          (struct math_c_vector2_unsigned_short_int) {
            .x = 100,
            .y = 100
          }
        );

        break;
      }
      case 8: {
        metil_mesh_mushroom_initialize(
          metil_mesh,
          (struct math_c_vector3_float) {
            .x = 10.0f,
            .y = 10.0f,
            .z = 10.0f
          },
          (struct math_c_vector2_unsigned_short_int) {
            .x = 110,
            .y = 110
          }
        );

        break;
      }
      case 9: {
        metil_mesh_ring_initialize(
          metil_mesh,
          (struct math_c_vector3_float) {
            .x = 10.0f,
            .y = 1.0f,
            .z = 10.0f
          },
          (struct math_c_vector3_float) {
            .x = 8.0f,
            .y = 1.0f,
            .z = 8.0f
          },
          (struct math_c_vector2_unsigned_short_int) {
            .x = 100,
            .y = 100
          }
        );

        break;
      }
      case 10: {
        metil_mesh_shuttle_initialize(
          metil_mesh,
          (struct math_c_vector3_float) {
            .x = 10.0f,
            .y = 10.0f,
            .z = 10.0f
          },
          (struct math_c_vector2_unsigned_short_int) {
            .x = 7,
            .y = 7
          }
        );

        break;
      }
      case 11: {
        metil_mesh_sphere_initialize(
          metil_mesh,
          10,
          (struct math_c_vector2_unsigned_short_int) {
            .x = 100,
            .y = 100
          }
        );

        break;
      }
      case 12: {
        metil_mesh_tube_initialize(
          metil_mesh,
          (struct math_c_vector3_float) {
            .x = 10.0f,
            .y = 10.0f,
            .z = 10.0f
          },
          (struct math_c_vector2_unsigned_short_int) {
            .x = 100,
            .y = 100
          },
          metil_direction_up
        );

        break;
      }
    }

    metil_object_buffers_initialize(
      metil_object,
      metil->renderer_interface.metal_device
    );

    float percentage = (
      (float) index_renderable / 
      (float) (
        metil_scene->length_renderables -
        1
      )
    );

    metil_object->position.x = percentage * width - width / 2.0f;
    metil_object->position.y = 10.0f;

    metil_object->rotation.x = (
      index_renderable *
      math_c_pi
    );

    metil_object->rotation.y = (
      index_renderable *
      math_c_pi_half
    );

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
    struct metil_object* metil_object = (
      metil_scene->renderables[
        index_renderable
      ].renderable
    );

    metil_object->rotation.x = (
      metil_object->rotation.x +
      0.01
    );

    metil_object->rotation.y = (
      metil_object->rotation.y +
      0.01
    );
  }
}
