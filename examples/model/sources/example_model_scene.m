#include <example_model_scene.h>

#include <example_model_pipeline_index.h>

#include <metil_mesh/metil_mesh.h>
#include <metil_mesh/metil_mesh_box.h>
#include <metil_model/metil_model.h>
#include <metil_input/metil_cursor.h>
#include <metil_object.h>
#include <metil_player/metil_player.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/metil_scene.h>

#include <math.h>

void example_model_scene_initialize(
  struct metil* metil,
  struct metil_scene* scene
) {
  metil_scene_initialize_with_renderables(
    metil,
    scene,
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

      if (
        index_object < 6
      ) {
        metil_object->position.z = 55.0f + (15.0f * (index_object % 3));
      } else if (
        index_object < 9
      ) {
        metil_object->position.z = 60.0f + (16.0f * (index_object % 3));
      } else if (
        index_object < 12
      ) {
        metil_object->position.z = 53.0f + (14.0f * (index_object % 3));
      } else {
        metil_object->position.z = 50.0f + (10.0f * (index_object % 3));
      } 
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

  metil_model_joints_add_length(
    metil_model,
    16
  );

  struct metil_joint* metil_joint;

  metil_model_vertex_joint_maps_initialize(
    metil_model
  );

  for (
    unsigned char index_object = 0;
    index_object < 15;
    ++index_object
  ) {
    metil_object = &(
      metil_model->objects[
        index_object
      ]
    );

    unsigned int index_joint = (
      index_object +
      1
    );

    if (
      index_object % 3 == 0
    ) {
      metil_joint_attach(
        &(
          metil_model->joints[
            0
          ]
        ),
        &(
          metil_model->joints[
            index_joint
          ]
        )
      );

      metil_joint_attach(
        &(
          metil_model->joints[
            index_joint
          ]
        ),
        &(
          metil_model->joints[
            index_joint + 1
          ]
        )
      );

      metil_joint_attach(
        &(
          metil_model->joints[
            index_joint + 1
          ]
        ),
        &(
          metil_model->joints[
            index_joint + 2
          ]
        )
      );
    }

    for (
      unsigned int index_vertex = 0;
      index_vertex < metil_object->mesh.length_vertices;
      ++index_vertex
    ) {
      metil_model_vertex_joint_attach(
        metil_model,
        index_object,
        index_vertex,
        index_joint
      );
    }

    metil_model_vertex_joint_attach(
      metil_model, (
        metil_model->length_objects -
        1
      ),
      index_object,
      index_joint
    );
  }

  for (
    unsigned char index_joint = 1;
    index_joint < metil_model->length_joints;
    ++index_joint
  ) {
    metil_joint = &(
      metil_model->joints[
        index_joint
      ]
    );

    metil_object = &(
      metil_model->objects[
        index_joint -
        1
      ]
    );

    metil_joint->position.x = metil_object->position.x;
    metil_joint->position.z = (
      metil_object->position.z -
      2.5f - (
        ((index_joint - 1) % 3) == 0
        ? 5.0f
        : 0.0f
      )
    );
  }

  metil_model_buffers_initialize(
    metil_model,
    metil->renderer_interface.metal_device
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
    metil->renderer_interface.metal_device
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
  struct metil* metil,
  struct metil_scene* scene
) {
  metil_scene_poll_default(
    metil,
    scene
  );

  struct metil_model* metil_model = (
    scene->renderables[
      0
    ].renderable
  );

  for (
    unsigned char index_joint = 1;
    index_joint < metil_model->length_joints;
    ++index_joint
  ) {
    if (
      index_joint == 1
    ) {
      if (
        (long int) metil_model->data < 4
      ) {
        metil_model->joints[index_joint].translation.y = (
          metil_model->joints[index_joint].translation.y +
          0.001f
        );
      } else {
        metil_model->joints[index_joint].translation.y = (
          metil_model->joints[index_joint].translation.y -
          0.001f
        );
      }
    }

    if (
      index_joint < 4
    ) {
      if (
        (long int) metil_model->data < 4
      ) {
        metil_model->joints[index_joint].rotation.x = (
          metil_model->joints[index_joint].rotation.x - (
            (index_joint - 1) % 3 == 0 
            ? 0.001f
            : (index_joint - 1) % 3 == 1
            ? 0.0025f
            :0.001f
          ) / 2.3f
        );

        metil_model->joints[index_joint].rotation.y = (
          metil_model->joints[index_joint].rotation.y - (
            (index_joint - 1) % 3 == 0 
            ? 0.001f
            : (index_joint - 1) % 3 == 1
            ? 0.0025f
            :0.001f
          ) / 2.3f
        );
      } else {
        metil_model->joints[index_joint].rotation.x = (
          metil_model->joints[index_joint].rotation.x + (
            (index_joint - 1) % 3 == 0 
            ? 0.001f
            : (index_joint - 1) % 3 == 1
            ? 0.0025f
            : 0.001f
          ) / 2.3f
        );

        metil_model->joints[index_joint].rotation.y = (
          metil_model->joints[index_joint].rotation.y + (
            (index_joint - 1) % 3 == 0 
            ? 0.001f
            : (index_joint - 1) % 3 == 1
            ? 0.0025f
            : 0.001f
          ) / 2.3f
        );
      }
    } else {
      if (
        (long int) metil_model->data < 4
      ) {
        metil_model->joints[index_joint].rotation.x = (
          metil_model->joints[index_joint].rotation.x - (
            (index_joint - 1) % 3 == 0 
            ? 0.001f
            : (index_joint - 1) % 3 == 1
            ? 0.0025f
            :0.0012f
          ) * (
            (
              (
                index_joint -
                1
              ) %
              3
            ) +
            2
          ) /
          2.0f
        );
      } else {
        metil_model->joints[index_joint].rotation.x = (
          metil_model->joints[index_joint].rotation.x + (
            (index_joint - 1) % 3 == 0 
            ? 0.001f
            : (index_joint - 1) % 3 == 1
            ? 0.0025f
            : 0.00125f
          ) * (
            (
              (
                index_joint -
                1
              ) %
              3
            ) +
            2
          ) /
          2.0f
        );
      }
    }
  }

  for (
    unsigned char index_joint = 1;
    index_joint < metil_model->length_joints;
    index_joint += 3
  ) {
    metil_joint_propagate(
      &metil_model->joints[
        index_joint
      ]
    );
  }

  struct metil_object* metil_object = (
    (void*) 0
  );

  float shift = (
    0.0000625f *
    scene->time_delta
  );

  if (
    (long int) metil_model->data % 2 == 0
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
      metil_model->data = (void*) ((long int) metil_model->data + 1);
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
      metil_model->data = (void*) (((long int) metil_model->data + 1) % 8);
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
  struct metil* metil,
  struct metil_scene* scene
) {
  struct metil_model* metil_model = (
    scene->renderables[
      0
    ].renderable
  );

  metil_model->data = 0;

  metil_scene_destroy_default(
    metil,
    scene
  );
}
