#include <metil_model/metil_model.h>

#include <metil_joint.h>
#include <metil_model/metil_model_segment.h>
#include <metil_positioning.h>
#include <metil_rendering/metil_renderer_data_object.h>

void metil_model_initialize(
  struct metil_model* metil_model
) {
  metil_model->length_objects = 0;
  metil_model->objects = malloc(
    sizeof(struct metil_object) *
    metil_model->length_objects
  );

  metil_model->length_joints = 0;
  metil_model->joints = malloc(
    sizeof(struct metil_joint) *
    metil_model->length_joints
  );
  
  metil_model->length_textures = 0;
  metil_model->textures = malloc(
    sizeof(id<MTLTexture>) *
    metil_model->length_textures
  );

  metil_model->position.x = 0.0f;
  metil_model->position.y = 0.0f;
  metil_model->position.z = 0.0f;

  metil_model->rotation.x = 0.0f;
  metil_model->rotation.y = 0.0f;
  metil_model->rotation.z = 0.0f;

  metil_model->visible = 1;

  metil_model->positioning = metil_positioning_normal;

  metil_model->destroy = metil_model_destroy;
  metil_model->poll = metil_model_poll;

  metil_model->data = (
    (void*) 0
  );
}

void metil_model_objects_add(
  struct metil_model* metil_model
) {
  metil_model_objects_add_length(
    metil_model,
    1
  );
}

void metil_model_objects_add_length(
  struct metil_model* metil_model,
  unsigned char length
) {
  metil_model->length_objects = (
    metil_model->length_objects +
    length
  );

  metil_model->objects = realloc(
    metil_model->objects,
    sizeof(struct metil_object) *
    metil_model->length_objects
  );

  for (
    unsigned char index_object = (
      metil_model->length_objects -
      length
    );
    index_object < metil_model->length_objects;
    ++index_object
  ) {
    struct metil_object* metil_object = (
      &metil_model->objects[
        index_object
      ]
    );

    metil_object_initialize(
      metil_object
    );

    metil_object->poll = metil_model_object_poll;
  }
}

void metil_model_joints_add(
  struct metil_model* metil_model
) {
  metil_model->length_joints = (
    metil_model->length_joints +
    1
  );

  metil_model->joints = realloc(
    metil_model->joints,
    sizeof(struct metil_joint) *
    metil_model->length_joints
  );

  metil_joint_initialize(
    &metil_model->joints[
      metil_model->length_joints
    ]
  );
}

void metil_model_buffers_initialize(
  struct metil_model* metil_model,
  id<MTLDevice> metal_device
) {
  for (
    unsigned char index_object = 0;
    index_object < metil_model->length_objects;
    ++index_object
  ) {
    metil_object_buffers_initialize(
      &metil_model->objects[
        index_object
      ],
      metal_device
    );
  }
}

void metil_model_texture_add(
  struct metil_model* metil_model,
  id<MTLTexture> texture
) {

}

void metil_model_poll(
  struct metil_model* metil_model,
  matrix_float3x4* matrix_projection_static,
  matrix_float4x4* matrix_object_projection,
  matrix_float4x4* matrix_player_projection,
  struct metil_camera* metil_camera
) {
  for (
    unsigned char index_object = 0;
    index_object < metil_model->length_objects;
    ++index_object
  ) {
    struct metil_object* metil_object = &(
      metil_model->objects[
        index_object
      ]
    );

    struct metil_renderer_data_object* data = (
      metil_object->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );

    data->position.x = metil_object->position.x;
    data->position.y = metil_object->position.y;
    data->position.z = metil_object->position.z;

    metil_positioning_view_model_matrix_projection_with_offsets_set(
      metil_object->positioning,
      &data->view_model_matrix_projection,
      matrix_projection_static,
      matrix_object_projection,
      matrix_player_projection,
      &metil_object->position,
      &metil_object->rotation,
      &metil_model->position,
      &metil_model->rotation,
      metil_camera
    );

    metil_object->poll(
      metil_object,
      matrix_projection_static,
      matrix_object_projection,
      matrix_player_projection,
      metil_camera
    );
  }
}

void metil_model_object_poll(
  struct metil_object* metil_object,
  matrix_float3x4* matrix_projection_static,
  matrix_float4x4* matrix_object_projection,
  matrix_float4x4* matrix_player_projection,
  struct metil_camera* metil_camera
) {
  struct metil_renderer_data_object* data = (
    metil_object->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  data->size.x = metil_object->mesh.size.x;
  data->size.y = metil_object->mesh.size.y;
  data->size.z = metil_object->mesh.size.z;
}

void metil_model_destroy(
  struct metil_model* metil_model
) {
  for (
    unsigned char index_object = 0;
    index_object < metil_model->length_objects;
    ++index_object
  ) {
    metil_model->objects[
      index_object
    ].destroy(
      &metil_model->objects[
        index_object
      ]
    );
  }

  free(metil_model->objects);

  for (
    unsigned char index_joint = 0;
    index_joint < metil_model->length_joints;
    ++index_joint
  ) {
    metil_joint_destroy(
      &metil_model->joints[
        index_joint
      ]
    );
  }

  if (
    metil_model->data != (void*) 0
  ) {
    free(metil_model->data);
  }

  free(metil_model->joints);

  free(metil_model->textures);
}

void metil_model_destroy_with_textures(
  struct metil_model* metil_model
) {
  for (
    unsigned char index_texture = 0;
    index_texture < metil_model->length_textures;
    ++index_texture
  ) {
    [metil_model->textures[
      index_texture
    ] release];
  }

  metil_model_destroy(metil_model);
}
