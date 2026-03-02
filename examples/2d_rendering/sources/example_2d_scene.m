#include <example_2d_scene.h>

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
      case example_2d_rendering_index_renderable_background: {
        metil_renderable_initialize_at_index(
          metil_scene->renderables,
          index_renderable,
          metil_renderable_type_object
        );

        break;
      }
      default: {
        break;
      }
    }
  }

  struct metil_object* metil_object_background = (
    metil_scene->renderables[
      example_2d_rendering_index_renderable_background
    ].renderable
  );

  metil_mesh_square_initialize(
    &metil_object_background->mesh,
    2
  );

  metil_object_background->positioning = (
    metil_positioning_absolute
  );

  metil_object_buffers_initialize(
    metil_object_background,
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
}
