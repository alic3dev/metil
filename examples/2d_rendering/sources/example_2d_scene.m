#include <example_2d_scene.h>

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
    5
  );

  metil_scene->player.poll_input = (
    metil_player_poll_input_null
  );

  metil_scene->poll = (
    example_2d_scene_poll
  );

  for (
    unsigned char index_renderable = 0;
    index_renderable < metil_scene->length_renderables;
    ++index_renderable
  ) {
    metil_renderable_initialize_at_index(
      metil_scene->renderables,
      index_renderable,
      metil_renderable_type_group
    );

    struct metil_group* metil_group = (
      metil_scene->renderables[
        index_renderable
      ].renderable
    );

    metil_group_add_length_initialize(
      metil_group,
      100,
      metil_renderable_type_object
    );

    for (
      unsigned int index_group_renderable = 0;
      index_group_renderable < metil_group->length;
      ++index_group_renderable
    ) {
      struct metil_object* metil_object = (
        metil_group->renderables[
          index_group_renderable
        ]->renderable
      );

      float percentage_group = (
        (float)
        index_group_renderable /
        (float)
        (
          metil_group->length -
          1
        )
      );

      if (
        index_renderable > 0
      ) {
        metil_mesh_circle_initialize(
          &metil_object->mesh,
          (
            0.001f *
            (
              index_group_renderable +
              1
            )
          ),
          (
            index_group_renderable +
            2
          )
        );
      } else {
        metil_mesh_square_initialize(
          &metil_object->mesh,
          (
            1.6f *
            (
              1.0f -
              percentage_group
            )
          )
        );
      }

      metil_object->positioning = (
        metil_positioning_static
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

      if (
        index_renderable > 0
      ) {
        metil_renderer_data_object->colour.x = (
          percentage_group
        );

        metil_renderer_data_object->colour.y = (
          percentage_group *
          0.75f +
          0.25f
        );

        metil_renderer_data_object->colour.w = (
          1.0f
        );
      } else {
        metil_renderer_data_object->colour.x = (
          1.0f
        );

        metil_renderer_data_object->colour.y = (
          1.0f -
          (
            percentage_group
          )
        );

        metil_renderer_data_object->colour.z = (
          metil_renderer_data_object->colour.y
        );

        metil_renderer_data_object->colour.w = (
          1.0f -
          (
            percentage_group
          )
        );
      }
    }
  }
}

void example_2d_scene_poll(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  metil_scene_poll_default(
    metil,
    metil_scene
  );

  for (
    unsigned char index_renderable = 0;
    index_renderable < metil_scene->length_renderables;
    ++index_renderable
  ) {
    struct metil_group* metil_group = (
      metil_scene->renderables[
        index_renderable
      ].renderable
    );

    for (
      unsigned int index_group_renderable = 0;
      index_group_renderable < metil_group->length;
      ++index_group_renderable
    ) {
      struct metil_object* metil_object = (
        metil_group->renderables[
          index_group_renderable
        ]->renderable
      );

      float percentage_group = (
        (float)
        index_group_renderable /
        (float)
        (
          metil_group->length -
          1
        )
      );

      struct metil_renderer_data_object* metil_renderer_data_object = (
        metil_object->buffers_vertex[
          metil_object_buffer_default_index_data
        ].buffer.contents
      );

      if (
        index_renderable > 0
      ) {
        metil_object->position.x = (
          math_c_sine(
            (
              (float)
              metil->renderer_interface.rendering_properties->frame /
              60.0f +
              index_renderable
            ),
            math_c_pi
          ) *
          (
            percentage_group
          ) *
          (
            index_group_renderable % 2 == 0
            ? -1.0f
            : 1.0f
          )
        );

        metil_object->position.y = (
          math_c_cosine(
            (
              (float)
              metil->renderer_interface.rendering_properties->frame /
              (
                60.0f /
                (
                  (float)
                  (
                    index_renderable +
                    1
                  ) /
                  4.0f
                )
              ) +
              index_renderable
            ),
            math_c_pi
          ) *
          (
            percentage_group
          ) *
          (
            index_group_renderable % 2 == 0
            ? -1.0f
            : 1.0f
          )
        );

        float tangent = (
          math_c_tangent(
            (
              (
                (float)
                metil->renderer_interface.rendering_properties->frame /
                (
                  60.0f
                )
              ) *
              math_c_pi *
              1.0f +
              (
                index_renderable *
                metil_group->length
              ) +
              index_group_renderable
            ),
            math_c_pi
          ) /
          math_c_pi
        );

        if (
          tangent < 0.0f
        ) {
          tangent = (
            -tangent
          );
        }
        
        if (
          tangent > 1.0f
        ) {
          tangent = 1.0f;
        }

        metil_renderer_data_object->colour.y = (
          percentage_group *
          0.75f +
          (
            0.25f -
            (
              0.25f *
              tangent
            )
          )
        );

        metil_renderer_data_object->colour.x = (
          metil_renderer_data_object->colour.y  
        );
      } else {
        metil_object->rotation.z = (
          metil_object->rotation.z +
          0.0001f *
          index_group_renderable
        );
      }
    }
  }
}
