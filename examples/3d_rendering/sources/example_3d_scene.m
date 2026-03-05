#include <example_3d_scene.h>

#include <metil.h>
#include <metil_mesh/metil_mesh_box.h>
#include <metil_object.h>
#include <metil_player/metil_player.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderable_type.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/metil_scene.h>

#include <clic3_memory.h>

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

    struct metil_object* object = (
      metil_scene->renderables[
        index_renderable
      ].renderable
    );

    metil_mesh_box_initialize(
      &object->mesh,
      (struct math_c_vector3_float) {
        .x = 10.0f,
        .y = 10.0f,
        .z = 10.0f
      }
    );

    metil_object_buffers_initialize(
      object,
      metil->renderer_interface.metal_device
    );

    object->position.x = ((float) (
      index_renderable % 21 + index_renderable % 32
    ) / 53.0f - 0.5f) * 1000.0f;
    object->position.y = (
      object->mesh.size.y +
      index_renderable % 14
    );
    object->position.z = ((float) (
      index_renderable % 34 + index_renderable % 23
    ) / 57.0f - 0.5f) * 1000.0f;

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
