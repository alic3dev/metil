#include <example_2d_scene.h>

#include <metil.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_square.h>
#include <metil_object.h>
#include <metil_player/metil_player.h>
#include <metil_positioning.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderable_type.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/metil_scene.h>

#include <math_c_vector.h>
#include <math_c_pi.h>
#include <math_c_sine.h>

#include <clic3_memory.h>

void example_2d_scene_initialize(
  struct metil* metil,
  struct metil_scene* scene
) {
  metil_scene_initialize_with_renderables(
    metil,
    scene,
    2
  );

  scene->player.poll_input = metil_player_poll_input_null;

  scene->poll = example_2d_scene_poll;

  #undef M_PI
  #define M_PI math_c_pi_calculate(1000)

  printf("%.100f\n", M_PI);
  printf("%.100f\n", math_c_pi_calculate(1000));

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

    metil_mesh_initialize(
      &object->mesh
    );

    object->mesh.length_vertices = 1000;
    object->mesh.length_indices = 1000;
    object->type_primitive = MTLPrimitiveTypeLineStrip;

    clic3_memory_reallocate_raw(
      &object->mesh.vertices,
      sizeof(struct math_c_vector4_float) * object->mesh.length_vertices
    );

    clic3_memory_reallocate_raw(
      &object->mesh.indices,
      sizeof(unsigned int) * object->mesh.length_indices
    );

    float mult = M_PI * 4.20;

    for (
      unsigned int i = 0; i < object->mesh.length_vertices; ++i
    ) {
      float ssin;

      ssin = ((float) i / (float) (object->mesh.length_vertices - 1)) * mult - 0.5f;

      if (index_renderable == 0) {
        ssin = math_c_tangent(
          ssin,
          M_PI
        );
      } else {
        
        ssin = tan(ssin);
      }

      object->mesh.vertices[i].x = (-1.0f) + (((float) i / (float) (object->mesh.length_vertices - 1)) * 2.0f);
      object->mesh.vertices[i].y = ssin;
      object->mesh.vertices[i].z = 0.0f;
      object->mesh.vertices[i].w = 1.0f;

      object->mesh.indices[i] = i;
    }

    object->positioning = (
      metil_positioning_absolute
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

    if (index_renderable != 0) {
      data_object->colour.x = (
        0.0f
      );

      data_object->colour.y = (
        1.0f
      );

      data_object->colour.z = (
        0.0f
      );
    }

    data_object->colour.w = 1.0f;

    // object->position.x = (
    //   (float) (index_renderable % 10)
    // ) * 0.2f - 0.9f;

    // object->position.y = (
    //   (float) (index_renderable / 10)
    // ) * 0.2f - 0.9f;

    // object->position.z = (
    //   1.0f
    // );
  }
}

void example_2d_scene_poll(
  struct metil* metil,
  struct metil_scene* scene
) {
  metil_scene_poll_default(
    metil,
    scene
  );

  return;

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

    struct math_c_vector3_unsigned_int time_offset = {
      .x = scene->time + (index_renderable + 2) * 20,
      .y = scene->time + (index_renderable + 3) * 30,
      .z = scene->time + (index_renderable + 1) * 10
    };

    data_object->colour.x = (
      ((time_offset.x / 1000) % 2 == 0
        ? (float) (time_offset.x % 1000) / 1500.0f
        : (float) (1000 - (time_offset.x % 1000)) / 1500.0f
      ) +
      brightness_minimum
    );
    data_object->colour.y = (
      ((time_offset.y / 1000) % 2 == 0
        ? (float) (time_offset.y % 1000) / 1500.0f
        : (float) (1000 - (time_offset.y % 1000)) / 1500.0f
      ) +
      brightness_minimum
    );
    data_object->colour.z = (
      ((time_offset.z / 1000) % 2 == 0
        ? (float) (time_offset.z % 1000) / 1500.0f
        : (float) (1000 - (time_offset.z % 1000)) / 1500.0f
      ) +
      brightness_minimum
    );
  }
}
