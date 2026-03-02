#include <example_2d_scene.h>

#include <example_2d_rendering_index_pipeline.h>
#include <example_2d_scene_textures.h>

#include <metil.h>
#include <metil_group.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_circle.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_rectangle.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_square.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_triangle.h>
#include <metil_object.h>
#include <metil_player/metil_player.h>
#include <metil_positioning.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderable_type.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/metil_scene.h>

#include <math_c_pi.h>
#include <math_c_sine.h>
#include <math_c_vector.h>

#include <clic3_memory.h>

void example_2d_scene_initialize(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  metil_scene_initialize_with_renderables(
    metil,
    metil_scene,
    example_2d_rendering_length_renderables
  );

  metil_scene->player.poll_input = (
    metil_player_poll_input_null
  );

  metil_scene->poll = (
    example_2d_scene_poll
  );

  example_2d_scene_textures_initialize(
    metil,
    metil_scene
  );

  for (
    unsigned char index_renderable = 0;
    index_renderable < metil_scene->length_renderables;
    ++index_renderable
  ) {
    switch (
      index_renderable
    ) {
      case example_2d_rendering_index_renderable_servers:
      case example_2d_rendering_index_renderable_server_housings: {
        metil_renderable_initialize_at_index(
          metil_scene->renderables,
          index_renderable,
          metil_renderable_type_group
        );

        break;
      }
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

  struct metil_object* metil_object_background = (
    metil_scene->renderables[
      example_2d_rendering_index_renderable_background
    ].renderable
  );

  struct metil_object* metil_object_floor = (
    metil_scene->renderables[
      example_2d_rendering_index_renderable_floor
    ].renderable
  );

  struct metil_object* metil_object_player = (
    metil_scene->renderables[
      example_2d_rendering_index_renderable_player
    ].renderable
  );

  struct metil_group* metil_group_servers = (
    metil_scene->renderables[
      example_2d_rendering_index_renderable_servers
    ].renderable
  );

  struct metil_group* metil_group_server_housings = (
    metil_scene->renderables[
      example_2d_rendering_index_renderable_server_housings
    ].renderable
  );

  metil_group_add_length_initialize(
    metil_group_servers,
    example_2d_rendering_length_servers,
    metil_renderable_type_object
  );

  metil_group_add_length_initialize(
    metil_group_server_housings,
    metil_group_servers->length,
    metil_renderable_type_object
  );

  for (
    unsigned int index_server = 0;
    index_server < metil_group_servers->length;
    ++index_server
  ) {
    struct metil_object* metil_object_server = (
      metil_group_servers->renderables[
        index_server
      ]->renderable
    );
    
    struct metil_object* metil_object_server_housing = (
      metil_group_server_housings->renderables[
        index_server
      ]->renderable
    );

    metil_mesh_rectangle_initialize(
      &metil_object_server->mesh,
      (struct math_c_vector2_float) {
        .x = (
          (
            (
              index_server %
              3
            ) !=
            1
            ? 0.1f
            : (
              (
                index_server %
                2
              ) *
              0.05f
            )
          ) +
          (
            (
              index_server *
              3
            ) %
            10
          ) /
          100.0f
        ),
        .y = (
          0.1f + 
          (
            (
              index_server %
              3
            ) !=
            1
            ? 0.1f
            : 0.0f
          )
        )
      }
    );

    metil_mesh_rectangle_initialize(
      &metil_object_server_housing->mesh,
      (struct math_c_vector2_float) {
        .x = (
          metil_object_server->mesh.size.x
        ),
        .y = (
          metil_object_server->mesh.size.y
        )
      }
    );

    metil_object_server->positioning = (
      metil_positioning_static
    );

    metil_object_server_housing->positioning = (
      metil_positioning_static
    );

    metil_object_buffers_initialize(
      metil_object_server,
      metil->renderer_interface.metal_device
    );

    metil_object_buffers_initialize(
      metil_object_server_housing,
      metil->renderer_interface.metal_device
    );

    metil_object_server->position.x = (
      index_server *
      0.1 +
      0.1f -
      metil_object_server->mesh.size.x 
    );

    metil_object_server->position.y = (
      metil_object_server->mesh.size.y /
      2.0f
    );

    if (
      index_server % 5 == 0
    ) {
      metil_object_server->position.x = (
        metil_object_server->position.x -
        0.25f +
        0.075f
      );
    }

    metil_object_server_housing->position.x = (
      metil_object_server->position.x
    );

    metil_object_server_housing->position.y = (
      metil_object_server->position.y
    );

    metil_object_texture_add(
      metil_object_server,
      metil_scene->textures[
        example_2d_rendering_index_texture_background
      ]
    );

    metil_object_texture_add(
      metil_object_server_housing,
      metil_scene->textures[
        example_2d_rendering_index_texture_server_housing
      ]
    );
  }

  metil_mesh_rectangle_initialize(
    &metil_object_floor->mesh,
    (struct math_c_vector2_float) {
      .x = (
        2.0f
      ),
      .y = (
        1.0f
      )
    }
  );

  metil_object_buffers_initialize(
    metil_object_floor,
    metil->renderer_interface.metal_device
  );

  metil_object_floor->position.y = (
    -0.5f
  );

  metil_object_floor->positioning = (
    metil_positioning_absolute
  );

  metil_object_texture_add(
    metil_object_floor,
    metil_scene->textures[
      example_2d_rendering_index_texture_floor
    ]
  );

  metil_mesh_square_initialize(
    &metil_object_background->mesh,
    2
  );

  metil_mesh_rectangle_initialize(
    &metil_object_player->mesh,
    (struct math_c_vector2_float) {
      .x = 0.001f,
      .y = 0.2f
    }
  );

  metil_object_background->positioning = (
    metil_positioning_absolute
  );

  metil_object_player->positioning = (
    metil_positioning_static
  );

  metil_object_background->index_pipeline_render = (
    example_2d_rendering_index_pipeline_background
  );

  metil_object_buffers_initialize(
    metil_object_background,
    metil->renderer_interface.metal_device
  );

  metil_object_buffers_initialize(
    metil_object_player,
    metil->renderer_interface.metal_device
  );

  metil_object_texture_add(
    metil_object_background,
    metil_scene->textures[
      example_2d_rendering_index_texture_background
    ]
  );
}

void example_2d_scene_poll(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  metil_scene_poll_default(
    metil,
    metil_scene
  );

  float translation_x = (
    (float) metil_scene->time_delta /
    3231.1323f
  );

  metil_scene->player.position.x = (
    metil_scene->player.position.x +
    translation_x
  );

  struct metil_object* metil_object_floor = (
    metil_scene->renderables[
      example_2d_rendering_index_renderable_floor
    ].renderable
  );
  
  struct metil_group* metil_group_servers = (
    metil_scene->renderables[
      example_2d_rendering_index_renderable_servers
    ].renderable
  );

  struct metil_group* metil_group_server_housings = (
    metil_scene->renderables[
      example_2d_rendering_index_renderable_server_housings
    ].renderable
  );

  metil_object_floor->position.x = (
    metil_object_floor->position.x +
    translation_x
  );

  for (
    unsigned int index_server = 0;
    index_server < metil_group_servers->length;
    ++index_server
  ) {
    struct metil_object* metil_object_server = (
      metil_group_servers->renderables[
        index_server
      ]->renderable
    );

    struct metil_object* metil_object_server_housing = (
      metil_group_server_housings->renderables[
        index_server
      ]->renderable
    );

    if (
      (
        metil_object_server->position.x -
        metil_scene->player.position.x
      ) < -2.0f
    ) {
      metil_object_server->position.x = (
        metil_object_server->position.x +
        4.0f
      );

      metil_object_server_housing->position.x = (
        metil_object_server->position.x
      );
    }
  }
}
