#include <metil_model/metil_model.h>

#include <metil_joint/metil_joint.h>
#include <metil_joint/metil_joint_id_offset.h>
#include <metil_positioning.h>
#include <metil_rendering/metil_renderer_data_model_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>
#include <metil_scenes/metil_scene_controller.h>

#include <clic3_memory.h>

void metil_model_initialize(
  struct metil_model* metil_model
) {
  metil_model->length_objects = 0;
  metil_model->objects = 0;

  clic3_memory_allocate(
    &metil_model->objects,
    (
      sizeof(
        struct metil_object
      ) *
      metil_model->length_objects
    )
  );

  metil_model->vertex_joint_maps = 0;

  metil_model->joints = 0;
  metil_model->length_joints = 0;

  clic3_memory_allocate(
    &metil_model->joints,
    (
      sizeof(
        struct metil_joint
      ) *
      metil_model->length_joints
    )
  );
  
  metil_model->length_textures = 0;
  metil_model->textures = 0;

  clic3_memory_allocate(
    &metil_model->textures,
    (
      sizeof(
        id<MTLTexture>
      ) *
      metil_model->length_textures
    )
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

  metil_model->data = 0;
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

  clic3_memory_allocate(
    &metil_model->objects,
    (
      sizeof(
        struct metil_object
      ) *
      metil_model->length_objects
    )
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
  metil_model_joints_add_length(
    metil_model,
    1
  );
}

void metil_model_joints_add_length(
  struct metil_model* metil_model,
  unsigned char length_metil_joints
) {
  metil_model->length_joints = (
    metil_model->length_joints +
    length_metil_joints
  );

  clic3_memory_allocate(
    &metil_model->joints,
    (
      sizeof(
        struct metil_joint
      ) *
      metil_model->length_joints
    )
  );

  for (
    unsigned char index_joint = (
      metil_model->length_joints -
      length_metil_joints
    );
    index_joint < length_metil_joints;
    ++index_joint
  ) {
    metil_joint_initialize(
      &metil_model->joints[
        index_joint
      ]
    );
  }
}

void metil_model_vertex_joint_maps_initialize(
  struct metil_model* metil_model
) {
  clic3_memory_allocate(
    &metil_model->vertex_joint_maps,
    (
      sizeof(
        unsigned int*
      ) *
      metil_model->length_objects
    )
  );

  for (
    unsigned char index_vertex_joint_map = 0;
    index_vertex_joint_map < metil_model->length_objects;
    ++index_vertex_joint_map
  ) {
    unsigned int length_vertex_joint_map = (
      metil_model->objects[
        index_vertex_joint_map
      ].mesh.length_vertices
    );

    metil_model->vertex_joint_maps[
      index_vertex_joint_map
    ] = 0;

    clic3_memory_allocate(
      &metil_model->vertex_joint_maps[
        index_vertex_joint_map
      ],
      (
        sizeof(
          unsigned int
        ) *
        length_vertex_joint_map
      )
    );

    for (
      unsigned int index_vertex_joint_map_value = 0;
      index_vertex_joint_map_value < length_vertex_joint_map;
      ++index_vertex_joint_map_value
    ) {
      metil_model->vertex_joint_maps[
        index_vertex_joint_map
      ][
        index_vertex_joint_map_value
      ] = (
        0
      );
    }
  }
}

void metil_model_vertex_joint_attach(
  struct metil_model* metil_model,
  unsigned char index_object,
  unsigned int index_vertex,
  unsigned char index_joint
) {
  metil_model->vertex_joint_maps[
    index_object
  ][
    index_vertex
  ] = (
    index_joint +
    1
  );
}

void metil_model_buffers_initialize(
  struct metil* metil,
  struct metil_model* metil_model,
  id<MTLDevice> metal_device
) {
  /*
   * [position, translation, rotation, ...]
   * index 0 == [(0,0,0), (0,0,0), (0,0,0)]
   * lookup values are +1 to actual joint index
   */
  metil_model->buffer_joints = [
    metal_device
    newBufferWithLength: (
      sizeof(
        struct math_c_vector3_float
      ) * (
        metil_model->length_joints +
        1
      ) *
      3
    )
    options: MTLResourceStorageModeShared
  ];

  struct math_c_vector3_float* buffer_joints_contents_joint = &(
    (
      (struct math_c_vector3_float*)
      metil_model->buffer_joints.contents
    )[0]
  );

  buffer_joints_contents_joint->x = 0.0f;
  buffer_joints_contents_joint->y = 0.0f;
  buffer_joints_contents_joint->z = 0.0f;

  buffer_joints_contents_joint = &(
    (
      (struct math_c_vector3_float*)
      metil_model->buffer_joints.contents
    )[1]
  );

  buffer_joints_contents_joint->x = 0.0f;
  buffer_joints_contents_joint->y = 0.0f;
  buffer_joints_contents_joint->z = 0.0f;

  buffer_joints_contents_joint = &(
    (
      (struct math_c_vector3_float*)
      metil_model->buffer_joints.contents
    )[2]
  );

  buffer_joints_contents_joint->x = 0.0f;
  buffer_joints_contents_joint->y = 0.0f;
  buffer_joints_contents_joint->z = 0.0f;

  metil_model_buffer_joints_poll(
    metil,
    metil_model
  );

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

    metil_object_buffers_initialize_with_data_size(
      metil_object,
      metal_device,
      sizeof(
        struct metil_renderer_data_model_object
      )
    );

    metil_object_buffers_add(
      metil_object,
      metal_device,
      metil_object_buffer_type_vertex
    );

    metil_object_buffers_add(
      metil_object,
      metal_device,
      metil_object_buffer_type_vertex
    );

    metil_object->buffers_vertex[
      metil_object_buffer_default_index_vertex_joint_map
    ].buffer = [metal_device
      newBufferWithBytes: (
        metil_model->vertex_joint_maps[
          index_object
        ]
      )
      length: (
        sizeof(
          unsigned int
        ) *
        metil_object->mesh.length_vertices
      )
      options: MTLResourceStorageModePrivate
    ];

    metil_object->buffers_vertex[
      metil_object_buffer_default_index_joints
    ].buffer = (
      metil_model->buffer_joints
    );
  }
}

void metil_model_texture_add(
  struct metil_model* metil_model,
  id<MTLTexture> texture
) {}

void metil_model_poll(
  struct metil* metil,
  struct metil_model* metil_model,
  matrix_float3x4* matrix_projection_static,
  matrix_float4x4* matrix_object_projection,
  matrix_float4x4* matrix_player_projection,
  struct metil_camera* metil_camera
) {
  metil_model_buffer_joints_poll(
    metil,
    metil_model
  );

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

    struct metil_renderer_data_model_object* data = (
      metil_object->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );

    metil_positioning_view_model_matrix_projection_with_offsets_set(
      metil_object->positioning,
      &data->view_model_matrix_projection,
      matrix_projection_static,
      matrix_object_projection,
      matrix_player_projection,
      &metil_object->position,
      &metil_object->rotation,
      &((struct metil_scene_controller*) metil->scene_controller)->scene.player.position,
      &metil_model->position,
      &metil_model->rotation,
      metil_camera
    );

    metil_object->poll(
      metil,
      metil_object,
      matrix_projection_static,
      matrix_object_projection,
      matrix_player_projection,
      metil_camera
    );
  }
}

void metil_model_buffer_joints_poll(
  struct metil* metil,
  struct metil_model* metil_model
) {
  struct math_c_vector3_float* buffer_joints_contents_joint;

  for (
    unsigned char index_joint = 0;
    index_joint < metil_model->length_joints;
    ++index_joint
  ) {
    struct metil_joint* metil_joint = &(
      metil_model->joints[
        index_joint
      ]
    );

    unsigned int id_buffer_joint = (
      (
        index_joint +
        1
      ) *
      metil_joint_id_offset_length
    );

    buffer_joints_contents_joint = &(
      (
        (struct math_c_vector3_float*) metil_model->buffer_joints.contents
      )[
        id_buffer_joint +
        metil_joint_id_offset_position
      ]
    );

    buffer_joints_contents_joint->x = (
      metil_joint->position.x
    );

    buffer_joints_contents_joint->y = (
      metil_joint->position.y
    );

    buffer_joints_contents_joint->z = (
      metil_joint->position.z
    );

    buffer_joints_contents_joint = &(
      (
        (struct math_c_vector3_float*) metil_model->buffer_joints.contents
      )[
        id_buffer_joint +
        metil_joint_id_offset_rotation
      ]
    );

    buffer_joints_contents_joint->x = (
      metil_joint->rotation.x +
      metil_joint->rotation_applied.x
    );

    buffer_joints_contents_joint->y = (
      metil_joint->rotation.y +
      metil_joint->rotation_applied.y
    );

    buffer_joints_contents_joint->z = (
      metil_joint->rotation.z +
      metil_joint->rotation_applied.z
    );

    buffer_joints_contents_joint = &(
      (
        (struct math_c_vector3_float*) metil_model->buffer_joints.contents
      )[
        id_buffer_joint +
        metil_joint_id_offset_translation
      ]
    );

    buffer_joints_contents_joint->x = (
      metil_joint->translation.x
    );

    buffer_joints_contents_joint->y = (
      metil_joint->translation.y
    );

    buffer_joints_contents_joint->z = (
      metil_joint->translation.z
    );
  }
}

void metil_model_object_poll(
  struct metil* metil,
  struct metil_object* metil_object,
  matrix_float3x4* matrix_projection_static,
  matrix_float4x4* matrix_object_projection,
  matrix_float4x4* matrix_player_projection,
  struct metil_camera* metil_camera
) {
  struct metil_renderer_data_model_object* data = (
    metil_object->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  data->position.x = (
    metil_object->position.x
  );

  data->position.y = (
    metil_object->position.y
  );

  data->position.z = (
    metil_object->position.z
  );

  data->size.x = metil_object->mesh.size.x;
  data->size.y = metil_object->mesh.size.y;
  data->size.z = metil_object->mesh.size.z;
}

void metil_model_destroy(
  struct metil* metil,
  struct metil_model* metil_model
) {
  [
    metil_model->buffer_joints
    release
  ];

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

    metil_object->buffers_vertex[
      metil_object_buffer_default_index_joints
    ].buffer = (
      0
    );

    metil_object->destroy(
      metil,
      metil_object
    );
  }

  clic3_memory_free(
    metil_model->objects
  );

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

  clic3_memory_free(
    metil_model->joints
  );

  clic3_memory_free(
    metil_model->data
  );

  clic3_memory_free(
    metil_model->textures
  );
}

void metil_model_destroy_with_textures(
  struct metil* metil,
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

  metil_model_destroy(
    metil,
    metil_model
  );
}
