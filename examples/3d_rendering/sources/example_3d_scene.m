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

  scene->poll = example_3d_scene_poll;

  scene->length_renderables = 2;
  scene->renderables = realloc(
    scene->renderables,
    sizeof(struct metil_renderable) *
    scene->length_renderables
  );

  struct metil_object* object = (
    (void*)0
  );

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

  metil_mesh_box_initialize(
    &object->mesh,
    (struct clic3_vector3_float) {
      .x = 10.0f,
      .y = 10.0f,
      .z = 10.0f
    }
  );

  metil_object_buffers_initialize(
    object,
    metal_device
  );

  object->position.x = 100.0f;
  object->position.z = 100.0f;

  struct metil_renderer_data_object* data_object = (
    object->data.contents
  );

  data_object->id = 0;
  data_object->color.x = (
    (float) (0 % 10) / 10.0f
  );
  data_object->color.y = (
    (float) ((0 + 3) % 10) / 10.0f
  );
  data_object->color.z = (
    (float) ((0 + 5) % 10) / 10.0f
  );
  data_object->color.w = 1.0f;

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

    struct metil_mesh* metil_mesh = (
      &object->mesh
    );

    metil_mesh_initialize(
      metil_mesh
    );

    metil_mesh->size.x = 100.0f;
    metil_mesh->size.y = 0.0f;
    metil_mesh->size.z = 100.0f;

    metil_mesh->length_vertices = 400;
    metil_mesh->length_indices = 404;

    metil_mesh->indices = realloc(
      metil_mesh->indices,
      sizeof(unsigned int) *
      metil_mesh->length_indices
    );

    metil_mesh->vertices = realloc(
      metil_mesh->vertices,
      sizeof(struct clic3_vector4_float) *
      metil_mesh->length_vertices
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
          ].z = -metil_mesh->size.z / 2.0f;
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
          ].z = metil_mesh->size.z / 2.0f;
          break;
        }
        case 2: {
          metil_mesh->vertices[
            index
          ].x = -metil_mesh->size.x / 2.0f;

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
          ].x = metil_mesh->size.x / 2.0f;

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

    object->type_primitive = MTLPrimitiveTypeLine;

    metil_object_buffers_initialize(
      object,
      metal_device
    );

    struct metil_renderer_data_object* data_object = (
      object->data.contents
    );

    data_object->id = index_renderable;
    data_object->color.x = (
      (float) (0 % 10) / 10.0f
    );
    data_object->color.y = (
      (float) ((0 + 3) % 10) / 10.0f
    );
    data_object->color.z = (
      (float) ((0 + 5) % 10) / 10.0f
    );
    data_object->color.w = 1.0f;
  }
}

void example_3d_scene_poll(
  struct metil_scene* scene
) {
  metil_scene_poll_default(scene);

 
}
