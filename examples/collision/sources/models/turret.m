#include <models/turret.h>

#include <example_collision_pipeline_index.h>

#include <metil.h>
#include <metil_direction.h>
#include <metil_mesh/metil_mesh_box.h>
#include <metil_mesh/metil_mesh_tube.h>
#include <metil_model/metil_model.h>
#include <metil_rendering/metil_renderer_data_model_object.h>

void model_turret_initialize(
  struct metil* metil,
  struct metil_model* model_turret
) {
  metil_model_objects_add_length(
    model_turret,
    7
  );

  struct math_c_vector3_float size_turret_leg = {
    .x = 0.4f,
    .y = 4.0f,
    .z = 0.4f
  };

  struct metil_object* object_turret_leg_one = &(
    model_turret->objects[
      model_turret_index_object_leg_one
    ]
  );

  struct metil_object* object_turret_leg_two = &(
    model_turret->objects[
      model_turret_index_object_leg_two
    ]
  );

  struct metil_object* object_turret_leg_three = &(
    model_turret->objects[
      model_turret_index_object_leg_three
    ]
  );

  struct metil_object* object_turret_leg_four = &(
    model_turret->objects[
      model_turret_index_object_leg_four
    ]
  );

  struct metil_object* object_turret_box = &(
    model_turret->objects[
      model_turret_index_object_box
    ]
  );

  struct metil_object* object_turret_barrel = &(
    model_turret->objects[
      model_turret_index_object_barrel
    ]
  );

  struct metil_object* object_turret_sight = &(
    model_turret->objects[
      model_turret_index_object_sight
    ]
  );

  metil_mesh_box_initialize(
    &object_turret_leg_one->mesh,
    size_turret_leg
  );

  metil_mesh_box_initialize(
    &object_turret_leg_two->mesh,
    size_turret_leg
  );

  metil_mesh_box_initialize(
    &object_turret_leg_three->mesh,
    size_turret_leg
  );

  metil_mesh_box_initialize(
    &object_turret_leg_four->mesh,
    size_turret_leg
  );

  metil_mesh_box_initialize(
    &object_turret_box->mesh,
    (struct math_c_vector3_float) {
      .x = 4.0f,
      .y = 2.0f,
      .z = 2.0f
    }
  );

  metil_mesh_tube_initialize(
    &object_turret_barrel->mesh,
    (struct math_c_vector3_float) {
      .x = 3.0f,
      .y = 0.5f,
      .z = 0.5f
    },
    (struct math_c_vector2_unsigned_short_int) {
      .x = 10,
      .y = 10
    },
    metil_direction_right
  );

  metil_mesh_box_initialize(
    &object_turret_sight->mesh,
    (struct math_c_vector3_float) {
      .x = 0.1f,
      .y = 0.5f,
      .z = 1.0f
    }
  );

  object_turret_leg_one->position.x = -1.0f;
  object_turret_leg_one->rotation.z = (
    M_PI /
    4.0f
  );

  object_turret_leg_two->position.x = 1.0f;
  object_turret_leg_two->rotation.z = -(
    M_PI /
    4.0f
  );

  object_turret_leg_three->position.z = -1.0f;
  object_turret_leg_three->rotation.x = -(
    M_PI /
    4.0f
  );

  object_turret_leg_four->position.z = 1.0f;
  object_turret_leg_four->rotation.x = (
    M_PI /
    4.0f
  );

  object_turret_box->position.y = 2.5f;

  object_turret_barrel->position.x = (
    object_turret_box->mesh.size.x -
    object_turret_barrel->mesh.size.x /
    2.0f
  );
  object_turret_barrel->position.y = (
    object_turret_box->position.y
  );

  object_turret_sight->position.x = (
    object_turret_box->mesh.size.x /
    2.25
  );
  object_turret_sight->position.y = (
    object_turret_sight->mesh.size.y /
    2.0f +
    object_turret_box->position.y +
    object_turret_box->mesh.size.y /
    2.0f
  );
  object_turret_sight->position.z = (
    -object_turret_box->mesh.size.z /
    2.0f +
    object_turret_sight->mesh.size.z /
    2.0f
  );

  metil_object_buffers_initialize(
    object_turret_leg_one,
    metil->renderer_interface.metal_device
  );

  metil_object_buffers_initialize(
    object_turret_leg_two,
    metil->renderer_interface.metal_device
  );

  metil_object_buffers_initialize(
    object_turret_leg_three,
    metil->renderer_interface.metal_device
  );

  metil_object_buffers_initialize(
    object_turret_leg_four,
    metil->renderer_interface.metal_device
  );

  metil_object_buffers_initialize(
    object_turret_box,
    metil->renderer_interface.metal_device
  );

  metil_object_buffers_initialize(
    object_turret_barrel,
    metil->renderer_interface.metal_device
  );

  metil_object_buffers_initialize(
    object_turret_sight,
    metil->renderer_interface.metal_device
  );

  struct metil_renderer_data_model_object* renderer_data_object_turret_leg_one = (
    object_turret_leg_one->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  struct metil_renderer_data_model_object* renderer_data_object_turret_leg_two = (
    object_turret_leg_two->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  struct metil_renderer_data_model_object* renderer_data_object_turret_leg_three = (
    object_turret_leg_three->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  struct metil_renderer_data_model_object* renderer_data_object_turret_leg_four = (
    object_turret_leg_four->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  struct metil_renderer_data_model_object* renderer_data_object_turret_box = (
    object_turret_box->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  struct metil_renderer_data_model_object* renderer_data_object_turret_barrel = (
    object_turret_barrel->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  struct metil_renderer_data_model_object* renderer_data_object_turret_sight = (
    object_turret_sight->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  renderer_data_object_turret_leg_one->color.x = 0.05f;
  renderer_data_object_turret_leg_one->color.y = 0.05f;
  renderer_data_object_turret_leg_one->color.z = 0.05f;
  renderer_data_object_turret_leg_one->color.w = 1.0f;

  renderer_data_object_turret_leg_two->color.x = (
    renderer_data_object_turret_leg_one->color.x
  );
  renderer_data_object_turret_leg_two->color.y = (
    renderer_data_object_turret_leg_one->color.y
  );
  renderer_data_object_turret_leg_two->color.z = (
    renderer_data_object_turret_leg_one->color.z
  );
  renderer_data_object_turret_leg_two->color.w = (
    renderer_data_object_turret_leg_one->color.w
  );

  renderer_data_object_turret_leg_three->color.x = (
    renderer_data_object_turret_leg_one->color.x
  );
  renderer_data_object_turret_leg_three->color.y = (
    renderer_data_object_turret_leg_one->color.y
  );
  renderer_data_object_turret_leg_three->color.z = (
    renderer_data_object_turret_leg_one->color.z
  );
  renderer_data_object_turret_leg_three->color.w = (
    renderer_data_object_turret_leg_one->color.w
  );

  renderer_data_object_turret_leg_four->color.x = (
    renderer_data_object_turret_leg_one->color.x
  );
  renderer_data_object_turret_leg_four->color.y = (
    renderer_data_object_turret_leg_one->color.y
  );
  renderer_data_object_turret_leg_four->color.z = (
    renderer_data_object_turret_leg_one->color.z
  );
  renderer_data_object_turret_leg_four->color.w = (
    renderer_data_object_turret_leg_one->color.w
  );

  renderer_data_object_turret_box->color.x = 0.05f;
  renderer_data_object_turret_box->color.y = 0.05f;
  renderer_data_object_turret_box->color.z = 0.05f;
  renderer_data_object_turret_box->color.w = 1.0f;

  renderer_data_object_turret_barrel->color.x = 0.05f;
  renderer_data_object_turret_barrel->color.y = 0.05f;
  renderer_data_object_turret_barrel->color.z = 0.05f;
  renderer_data_object_turret_barrel->color.w = 1.0f;

  renderer_data_object_turret_sight->color.x = 1.0f;
  renderer_data_object_turret_sight->color.y = 1.0f;
  renderer_data_object_turret_sight->color.z = 1.0f;
  renderer_data_object_turret_sight->color.w = 1.0f;

  object_turret_barrel->index_pipeline_render = (
    example_collision_pipeline_index_turret_barrel
  );

  object_turret_sight->index_pipeline_render = (
    example_collision_pipeline_index_turret_sight  
  );

  metil_model_joints_add_length(
    model_turret,
    1
  );

  metil_model_vertex_joint_maps_initialize(
    model_turret
  );

  for (
    unsigned char index_object = model_turret_index_object_box;
    index_object <= model_turret_index_object_sight;
    ++index_object
  ) {
    struct metil_object* object_turret_rotatable = &(
      model_turret->objects[
        index_object
      ]
    );

    for (
      unsigned int index_vertex = 0;
      index_vertex < object_turret_rotatable->mesh.length_vertices;
      ++index_vertex
    ) {
      metil_model_vertex_joint_attach(
        model_turret,
        index_object,
        index_vertex,
        0
      );
    }
  }

  metil_model_buffers_initialize(
    metil,
    model_turret,
    metil->renderer_interface.metal_device
  );
}

void model_turret_poll(
  struct metil* metil,
  struct metil_model* metil_model,
  matrix_float3x4* matrix_projection_static,
  matrix_float4x4* matrix_object_projection,
  matrix_float4x4* matrix_player_projection,
  struct metil_camera* metil_camera
) {
  metil_model_poll(
    metil,
    metil_model,
    matrix_projection_static,
    matrix_object_projection,
    matrix_player_projection,
    metil_camera
  );
}
