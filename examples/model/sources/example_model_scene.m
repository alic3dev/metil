#include <example_model_scene.h>

#include <example_model_pipeline_index.h>
#include <example_model_renderer_data_object.h>

#include <metil_application/metil_renderer_size.h>
#include <metil_mesh/mesh.h>
#include <metil_mesh/mesh_box.h>
#include <metil_model/metil_model.h>
#include <metil_input/cursor.h>
#include <metil_object.h>
#include <metil_player.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/scene.h>

#include <math.h>

void example_model_scene_initialize(
  struct metil_scene* scene,
  struct metil_renderer_interface* metil_renderer_interface
) {
  metil_scene_initialize_with_renderables(
    scene,
    metil_renderer_interface,
    2
  );

  scene->player.position.z = 5.0f;

  metil_renderable_initialize_at_index(
    scene->renderables,
    0,
    metil_renderable_type_model
  );

  metil_renderable_initialize_at_index(
    scene->renderables,
    1,
    metil_renderable_type_object
  );

  struct metil_model* metil_model = (
    scene->renderables[
      0
    ].renderable
  );

  struct metil_object* metil_object = (
    (void*) 0
  );

  struct metil_mesh* metil_mesh = (
    (void*) 0
  );

  metil_model->data = 0;

  metil_model_objects_add_length(
    metil_model,
    18
  );

  for (
    unsigned char index_object = 0;
    index_object < metil_model->length_objects - 1;
    ++index_object
  ) {
    metil_object = &(
      metil_model->objects[
        index_object
      ]
    );

    metil_mesh = (
      &metil_object->mesh
    );

    metil_mesh_box_initialize(
      metil_mesh,
      (struct clic3_vector3_float) {
        .x = 5.0f,
        .y = 5.0f,
        .z = 5.0f
      }
    );

    if (
      index_object < 3
    ) {
      metil_object->position.x =  -20.0f;
      metil_object->position.z = 20.0f + (15.0f * (index_object % 3));
    } else if (
      index_object < 15
    ) {
      metil_object->position.x =  -20.0f + (7.5f * (index_object / 3));
      metil_object->position.z = 55.0f + (15.0f * (index_object % 3));
    } else if (
      index_object == 15
    ) {
      metil_object->position.z = 15.0f;
    } else {
      metil_object->position.z = 5.0f;
    }
  }

  metil_object = &(
    metil_model->objects[
      metil_model->length_objects -
      1
    ]
  );

  metil_mesh = &(
    metil_object->mesh
  );

  metil_mesh_initialize(
    metil_mesh
  );

  metil_mesh->length_indices = 29;
  metil_mesh->length_vertices = (
    metil_model->length_objects -
    1
  );

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

  metil_object->type_primitive = MTLPrimitiveTypeLineStrip;

  for (
    unsigned char index_vertex = 0;
    index_vertex < metil_mesh->length_vertices;
    ++index_vertex
  ) {
    metil_object = &(
      metil_model->objects[
        index_vertex
      ]
    );

    metil_mesh->vertices[index_vertex].x = metil_object->position.x;
    metil_mesh->vertices[index_vertex].y = metil_object->position.y;
    metil_mesh->vertices[index_vertex].z = metil_object->position.z;
    metil_mesh->vertices[index_vertex].w = 1.0f;
  }

  metil_mesh->indices[0] = 2;
  metil_mesh->indices[1] = 1;
  metil_mesh->indices[2] = 0;

  metil_mesh->indices[3] = 15;

  metil_mesh->indices[4] = 3;
  metil_mesh->indices[5] = 4;
  metil_mesh->indices[6] = 5;
  metil_mesh->indices[7] = 4;
  metil_mesh->indices[8] = 3;

  metil_mesh->indices[9] = 15;

  metil_mesh->indices[10] = 6;
  metil_mesh->indices[11] = 7;
  metil_mesh->indices[12] = 8;
  metil_mesh->indices[13] = 7;
  metil_mesh->indices[14] = 6;

  metil_mesh->indices[15] = 15;

  metil_mesh->indices[16] = 9;
  metil_mesh->indices[17] = 10;
  metil_mesh->indices[18] = 11;
  metil_mesh->indices[19] = 10;
  metil_mesh->indices[20] = 9;

  metil_mesh->indices[21] = 15;

  metil_mesh->indices[22] = 12;
  metil_mesh->indices[23] = 13;
  metil_mesh->indices[24] = 14;
  metil_mesh->indices[25] = 13;
  metil_mesh->indices[26] = 12;

  metil_mesh->indices[27] = 15;

  metil_mesh->indices[28] = 16;

  metil_model_buffers_initialize(
    metil_model,
    scene->renderer_interface->metal_device
  );

  metil_object = (
    scene->renderables[
      1
    ].renderable
  );

  metil_mesh = (
    &metil_object->mesh
  );

  metil_mesh_box_initialize(
    metil_mesh,
    (struct clic3_vector3_float) {
      .x = 2.5f,
      .y = 2.5f,
      .z = 2.5f
    }
  );

  metil_object->position.y = 12.5f;
  metil_object->position.z = 35.0f;

  metil_object_buffers_initialize(
    metil_object,
    scene->renderer_interface->metal_device
  );

  struct metil_renderer_data_object* metil_renderer_data_object = (
    metil_object->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  metil_renderer_data_object->color.x = (
    0.0f
  );

  metil_renderer_data_object->color.y = (
    1.0f / 3.0f
  );

  metil_renderer_data_object->color.z = (
    2.0f / 3.0f
  );

  metil_renderer_data_object->color.w = (
    1.0f
  );
  
  metil_object->index_pipeline_render = (
    example_model_pipeline_index_model_item
  );

  scene->destroy = example_model_scene_destroy;
  scene->poll = example_model_scene_poll;
}


/*
    |  |  |  |
    .  .  .  .
    |  |  |  |
    .  .  .  .
 .  |  |  |  |
 |  .  .  .  .
 .
  \.     .
         |
         .

*/

void example_model_scene_poll(
  struct metil_scene* scene
) {
  metil_scene_poll_default(
    scene
  );

  struct metil_model* metil_model = (
    scene->renderables[
      0
    ].renderable
  );

  struct metil_object* metil_object = (
    (void*) 0
  );

  float shift = (
    0.0000625f *
    scene->time_delta
  );

  for (
    unsigned char index_object = 0;
    index_object < (
      metil_model->length_objects -
      1
    );
    ++index_object
  ) {
    metil_object = (
      &metil_model->objects[
        index_object
      ]
    );

    metil_object->rotation.x = (
      metil_object->rotation.x +
      shift * (
        metil_model->length_objects -
        index_object +
        1
      )
    );

    metil_object->rotation.y = (
      metil_object->rotation.y +
      shift * (
        index_object +
        1
      )
    );
  }

  if (
    metil_model->data == 0
  ) {
    metil_model->position.y = (
      metil_model->position.y +
      shift * 8.0f
    );

    metil_model->rotation.x = (
      metil_model->rotation.x +
      shift
    );

    if (
      metil_model->position.y >= 1.0f
    ) {
      metil_model->data = (void*) 1;
    }
  } else {
    metil_model->position.y = (
      metil_model->position.y -
      shift * 8.0f
    );

    metil_model->rotation.x = (
      metil_model->rotation.x -
      shift
    );

    if (
      metil_model->position.y <= 0.0f
    ) {
      metil_model->data = 0;
    }
  }

  shift = (
    shift *
    16.0f
  );

  metil_object = (
    scene->renderables[
      1
    ].renderable
  );

  metil_object->rotation.x = (
    metil_object->rotation.x +
    shift
  );

  metil_object->rotation.y = (
    metil_object->rotation.y +
    shift
  );

  struct metil_renderer_data_object* metil_renderer_data_object = (
    metil_object->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  shift = (
    shift /
    20.0f
  );

  metil_renderer_data_object->color.x = (
    metil_renderer_data_object->color.x +
    shift
  );

  metil_renderer_data_object->color.y = (
    metil_renderer_data_object->color.y +
    shift
  );

  metil_renderer_data_object->color.z = (
    metil_renderer_data_object->color.z +
    shift
  );
}

void example_model_scene_destroy(
  struct metil_scene* scene
) {
  struct metil_model* metil_model = (
    scene->renderables[
      0
    ].renderable
  );

  metil_model->data = 0;

  metil_scene_destroy_default(
    scene
  );
}
