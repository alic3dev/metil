#include <example_3d_scene.h>

#include <metil.h>
#include <metil_mesh/metil_mesh_box.h>
#include <metil_object.h>
#include <metil_player/metil_player.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/metil_scene.h>

#include <clic3_memory.h>

#include <math_c_vector.h>

void example_3d_scene_initialize(
  struct metil* metil,
  struct metil_scene* scene
) {
  metil_scene_initialize_with_renderables(
    metil,
    scene,
    400
  );

  scene->poll = example_3d_scene_poll;

  struct metil_object* object = (
    (void*)0
  );

  for (
    unsigned int index_renderable = 0;
    index_renderable < 200;
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
  }

  for (
    unsigned int index_renderable = 200;
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

    struct metil_mesh* metil_mesh = (
      &object->mesh
    );

    metil_mesh_initialize(
      metil_mesh
    );

    metil_mesh->size.x = 10000.0f;
    metil_mesh->size.y = 0.0f;
    metil_mesh->size.z = 10000.0f;

    metil_mesh->length_vertices = 400;
    metil_mesh->length_indices = 404;

    clic3_memory_allocate(
      &metil_mesh->indices,
      (
        sizeof(
          unsigned int
        ) *
        metil_mesh->length_indices
      )
    );

    clic3_memory_allocate(
      &metil_mesh->vertices,
      (
        sizeof(
          struct math_c_vector4_float
        ) *
        metil_mesh->length_vertices
      )
    );

    float size_segment = (
      metil_mesh->size.x / 100
    );

    for (
      unsigned short int index = 0;
      index < 400;
      ++index
    ) {

      switch (
        index / 100
      ) {
        case 0: {
          metil_mesh->vertices[
            index
          ].x = (
            (index % 100) * size_segment - metil_mesh->size.x / 2.0f
          );

          metil_mesh->vertices[
            index
          ].z = -metil_mesh->size.z / 2.0f - (
            index % 26 + index % 14 + index % 64
          ) * size_segment;
          break;
        }
        case 1: {
          metil_mesh->vertices[
            index
          ].x = (
            (index % 100) * size_segment - metil_mesh->size.x / 2.0f
          );

          metil_mesh->vertices[
            index
          ].z = metil_mesh->size.z / 2.0f + (
            index % 14 + index % 64 + index % 8 +  index % 10
          ) * size_segment;
          break;
        }
        case 2: {
          metil_mesh->vertices[
            index
          ].x = -metil_mesh->size.x / 2.0f - (
            index % 7 + index % 47 + index % 27 + index % 37 + index % 17 + index % 67
          ) * size_segment;

          metil_mesh->vertices[
            index
          ].z = (
            (index % 100) * size_segment - metil_mesh->size.z / 2.0f
          );
          break;
        }
        case 3: {
          metil_mesh->vertices[
            index
          ].x = metil_mesh->size.x / 2.0f + (
            index % 42 + index % 31 + index % 26
          ) * size_segment;

          metil_mesh->vertices[
            index
          ].z = (
            (index % 100) * size_segment - metil_mesh->size.z / 2.0f
          );
          break;
        }
      }

      metil_mesh->vertices[
        index
      ].y = 0.0f;

      metil_mesh->vertices[
        index
      ].w = 1.0f;

      if (
        index < 100
      ) {
        metil_mesh->indices[
          (index * 2)
        ] = index;

        metil_mesh->indices[
          (index * 2) + 1
        ] = index + 100;
      } else if (
        index >= 200 &&
        index < 300
      ) {
        metil_mesh->indices[
          (index - 100) * 2
        ] = index;

        metil_mesh->indices[
          (index - 100) * 2 + 1
        ] = index + 100;
      }
    }

    metil_mesh->indices[
      400
    ] = 0;

    metil_mesh->indices[
      401
    ] = 99;

    metil_mesh->indices[
      402
    ] = 100;

    metil_mesh->indices[
      403
    ] = 199;

    object->type_primitive = MTLPrimitiveTypeLineStrip;

    object->position.x = 100.0f * ((float) (index_renderable % 40) / 40) - 50.0f;
    object->position.z = 100.0f * ((float) (index_renderable % 20 + index_renderable % 5) / 25.0f) - 50.0f;

    switch (
      index_renderable % 3
    ) {
      case 0: {
        object->rotation.x = (M_PI / 2.0f);
        break;
      }
      case 1: {
        object->rotation.z = (M_PI / 2.0f);
        break;
      }
      default: {
        break;
      }
    }

    metil_object_buffers_initialize(
      object,
      metil->renderer_interface.metal_device
    );

    struct metil_renderer_data_object* data_object = (
      object->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );

    data_object->color.x = (
      (float) (index_renderable % 10) / 10.0f
    );
    data_object->color.y = (
      (float) ((index_renderable * 3) % 10) / 10.0f
    );
    data_object->color.z = (
      (float) ((index_renderable * 5) % 10) / 10.0f
    );
    data_object->color.w = 1.0f;
  }
}

void example_3d_scene_poll(
  struct metil* metil,
  struct metil_scene* scene
) {
  metil_scene_poll_default(
    metil,
    scene
  );

  float color_shift = (
    scene->player.position.x +
    scene->player.position.y +
    scene->player.position.z +
    scene->player.rotation.x +
    scene->player.rotation.y +
    scene->player.rotation.z
  ) / 100.0f;

  for (
    unsigned int index_renderable = 0;
    index_renderable < scene->length_renderables;
    ++index_renderable
  ) {
    struct metil_object* object = (
      scene->renderables[
        index_renderable
      ].renderable
    );

    if (
      index_renderable < 200
    ) {
      object->rotation.x = (
        object->rotation.x +
        (index_renderable % 10) * 0.003f + 0.001f
      );
      object->rotation.y = (
        object->rotation.y +
        (index_renderable % 10) * 0.002f + 0.002f
      );
      object->rotation.z = (
        object->rotation.z + 
        (index_renderable % 10) * 0.001f + 0.003f
      );
    }

    struct metil_renderer_data_object* data_object = (
      object->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );

    data_object->color.x = (float) (index_renderable % 10) / 10.0f + color_shift;
    data_object->color.y = (float) ((index_renderable * 3) % 10) / 10.0f + color_shift;
    data_object->color.z = (float) ((index_renderable * 5) % 10) / 10.0f + color_shift;

    data_object->color.w = 1.0f;
  }
}
