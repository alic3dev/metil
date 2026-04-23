#include <example_model_scene.h>

#include <example_model_pipeline_index.h>

#include <clic3_memory.h>

#include <metil_direction.h>
#include <metil_mesh/metil_mesh.h>
#include <metil_mesh/metil_mesh_box.h>
#include <metil_mesh/metil_mesh_sphere.h>
#include <metil_mesh/metil_mesh_tube.h>
#include <metil_model/metil_model.h>
#include <metil_input/metil_cursor.h>
#include <metil_object.h>
#include <metil_player/metil_player.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderable_type.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/metil_scene.h>

void example_model_scene_initialize(
  struct metil* metil,
  struct metil_scene* scene
) {
  metil_scene_initialize_with_renderables(
    metil,
    scene,
    0x03
  );

  metil_renderable_initialize_at_index(
    scene->renderables,
    0x00,
    metil_renderable_type_object
  );

  metil_renderable_initialize_at_index(
    scene->renderables,
    0x01,
    metil_renderable_type_model
  );

  metil_renderable_initialize_at_index(
    scene->renderables,
    0x02,
    metil_renderable_type_model
  );

  struct metil_object* metil_object_ground = (
    scene->renderables[
      0x00
    ].renderable
  );

  struct metil_model* metil_model_player = (
    scene->renderables[
      0x01
    ].renderable
  );

  struct metil_model* metil_model_skateboard = (
    scene->renderables[
      0x02
    ].renderable
  );

  metil_model_objects_add_length(
    metil_model_player,
    0x0a
  );

  metil_model_objects_add_length(
    metil_model_skateboard,
    0x07
  );

  struct metil_object* metil_object_player_head = &(
    metil_model_player->objects[
      0x00
    ]
  );


  struct metil_object* metil_object_player_body = &(
    metil_model_player->objects[
      0x01
    ]
  );

  struct metil_object* metil_object_player_arm_left = &(
    metil_model_player->objects[
      0x02
    ]
  );

  struct metil_object* metil_object_player_arm_left_lower = &(
    metil_model_player->objects[
      0x03
    ]
  );

  struct metil_object* metil_object_player_arm_right = &(
    metil_model_player->objects[
      0x04
    ]
  );

  struct metil_object* metil_object_player_arm_right_lower = &(
    metil_model_player->objects[
      0x05
    ]
  );

  struct metil_object* metil_object_player_leg_left = &(
    metil_model_player->objects[
      0x06
    ]
  );

  struct metil_object* metil_object_player_leg_left_lower = &(
    metil_model_player->objects[
      0x07
    ]
  );

  struct metil_object* metil_object_player_leg_right = &(
    metil_model_player->objects[
      0x08
    ]
  );

  struct metil_object* metil_object_player_leg_right_lower = &(
    metil_model_player->objects[
      0x09
    ]
  );
  struct metil_object* metil_object_skateboard_deck = &(
    metil_model_skateboard->objects[
      0x00
    ]
  );

  struct metil_object* metil_object_skateboard_truck_front = &(
    metil_model_skateboard->objects[
      0x01
    ]
  );

  struct metil_object* metil_object_skateboard_wheel_front_left = &(
    metil_model_skateboard->objects[
      0x02
    ]
  );

  struct metil_object* metil_object_skateboard_wheel_front_right = &(
    metil_model_skateboard->objects[
      0x03
    ]
  );

  struct metil_object* metil_object_skateboard_truck_back = &(
    metil_model_skateboard->objects[
      0x04
    ]
  );

  struct metil_object* metil_object_skateboard_wheel_back_left = &(
    metil_model_skateboard->objects[
      0x05
    ]
  );

  struct metil_object* metil_object_skateboard_wheel_back_right = &(
    metil_model_skateboard->objects[
      0x06
    ]
  );

  metil_mesh_sphere_initialize(
    &metil_object_player_head->mesh,
    1.0f,
    (struct math_c_vector2_unsigned_short_int) {
      .x = (
        0x08
      ),
      .y = (
        0x08
      )
    }
  );
  metil_mesh_tube_initialize(
    &metil_object_player_body->mesh,
    (struct math_c_vector3_float) {
      .x = (
        0x01
      ),
      .y = (
        0x04
      ),
      .z = (
        0x01
      )
    },
    (struct math_c_vector2_unsigned_short_int) {
      .x = (
        0x08
      ),
      .y = (
        0x08
      )
    },
    metil_direction_down
  );
  metil_mesh_tube_initialize(
    &metil_object_player_arm_left->mesh,
    (struct math_c_vector3_float) {
      .x = (
        0x01
      ),
      .y = (
        0x02
      ),
      .z = (
        0x01
      )
    },
    (struct math_c_vector2_unsigned_short_int) {
      .x = (
        0x08
      ),
      .y = (
        0x08
      )
    },
    metil_direction_down
  );

  metil_mesh_tube_initialize(
    &metil_object_player_arm_left_lower->mesh,
    (struct math_c_vector3_float) {
      .x = (
        0x01
      ),
      .y = (
        0x02
      ),
      .z = (
        0x01
      )
    },
    (struct math_c_vector2_unsigned_short_int) {
      .x = (
        0x08
      ),
      .y = (
        0x08
      )
    },
    metil_direction_down
  );

  metil_model_joints_add_length(
    metil_model_player,
    0x08
  );

  metil_model_joints_add_length(
    metil_model_skateboard,
    0x02
  );

  struct metil_joint* metil_joint;

  metil_model_vertex_joint_maps_initialize(
    metil_model_player
  );

  metil_model_vertex_joint_maps_initialize(
    metil_model_skateboard
  );

  struct metil_joint* metil_joint_player_shoulder_left = &(
    metil_model_player->joints[
      0x00
    ]
  );

  struct metil_joint* metil_joint_player_elbow_left = &(
    metil_model_player->joints[
      0x01
    ]
  );

  struct metil_joint* metil_joint_player_shoulder_right = &(
    metil_model_player->joints[
      0x02
    ]
  );

  struct metil_joint* metil_joint_player_elbow_right = &(
    metil_model_player->joints[
      0x03
    ]
  );

  struct metil_joint* metil_joint_player_hip_left = &(
    metil_model_player->joints[
      0x04
    ]
  );

  struct metil_joint* metil_joint_player_knee_left = &(
    metil_model_player->joints[
      0x05
    ]
  );

  struct metil_joint* metil_joint_player_hip_right = &(
    metil_model_player->joints[
      0x06
    ]
  );

  struct metil_joint* metil_joint_player_knee_right = &(
    metil_model_player->joints[
      0x07
    ]
  );
  struct metil_joint* metil_joint_skateboard_truck_front = &(
    metil_model_skateboard->joints[
      0x00
    ]
  );

  struct metil_joint* metil_joint_skateboard_truck_back = &(
    metil_model_skateboard->joints[
      0x01
    ]
  );

  metil_joint_attach(
    metil_joint_player_shoulder_left,    metil_joint_player_elbow_left  );

  metil_joint_attach(
    metil_joint_player_shoulder_right,
    metil_joint_player_elbow_right
  );

  metil_joint_attach(
    metil_joint_player_hip_left,
    metil_joint_player_knee_left
  );

  metil_joint_attach(
    metil_joint_player_hip_right,
    metil_joint_player_knee_right
  );

  for (
    unsigned int index_vertex = 0;
    index_vertex < metil_object_player_arm_left->mesh.length_vertices;
    ++index_vertex
  ) {
    metil_model_vertex_joint_attach(
      metil_model_player,
      0x01,
      index_vertex,
      0x00
    );
  }

  for (
    unsigned int index_vertex = (
      0x00
    );
    (
      index_vertex <
      metil_object_player_arm_left_lower->mesh.length_vertices
    );
    ++index_vertex
  ) {
    metil_model_vertex_joint_attach(
      metil_model_player,
      0x02,
      index_vertex,
      0x01
    );
  }

  for (
    unsigned int index_vertex = (
      0x00
    );
    (
      index_vertex <
      metil_object_player_arm_right->mesh.length_vertices
    );
    ++index_vertex
  ) {
    metil_model_vertex_joint_attach(
      metil_model_player,
      0x03,
      index_vertex,
      0x02
    );
  }

  for (
    unsigned int index_vertex = (
      0x00
    );
    (
      index_vertex <
      metil_object_player_arm_right_lower->mesh.length_vertices
    );
    ++index_vertex
  ) {
    metil_model_vertex_joint_attach(
      metil_model_player,
      0x04,
      index_vertex,
      0x03
    );
  }

  for (
    unsigned int index_vertex = (
      0x00
    );
    (
      index_vertex <
      metil_object_player_leg_left->mesh.length_vertices
    );
    ++index_vertex
  ) {
    metil_model_vertex_joint_attach(
      metil_model_player,
      0x05,
      index_vertex,
      0x04
    );
  }

  for (
    unsigned int index_vertex = (
      0x00
    );
    (
      index_vertex <
      metil_object_player_leg_left_lower->mesh.length_vertices
    );
    ++index_vertex
  ) {
    metil_model_vertex_joint_attach(
      metil_model_player,
      0x06,
      index_vertex,
      0x05
    );
  }

  for (
    unsigned int index_vertex = (
      0x00
    );
    (
      index_vertex <
      metil_object_player_leg_right->mesh.length_vertices
    );
    ++index_vertex
  ) {
    metil_model_vertex_joint_attach(
      metil_model_player,
      0x07,
      index_vertex,
      0x06
    );
  }

  for (
    unsigned int index_vertex = (
      0x00
    );
    (
      index_vertex <
      metil_object_player_leg_right_lower->mesh.length_vertices
    );
    ++index_vertex
  ) {
    metil_model_vertex_joint_attach(
      metil_model_player,
      0x08,
      index_vertex,
      0x07
    );
  }

  for (
    unsigned int index_vertex = (
      0x00
    );
    (
      index_vertex <
      metil_object_skateboard_truck_front->mesh.length_vertices
    );
    ++index_vertex
  ) {
    metil_model_vertex_joint_attach(
      metil_model_skateboard,
      0x01,
      index_vertex,
      0x00
    );
  }

  for (
    unsigned int index_vertex = (
      0x00
    );
    (
      index_vertex <
      metil_object_skateboard_wheel_front_left->mesh.length_vertices
    );
    ++index_vertex
  ) {
    metil_model_vertex_joint_attach(
      metil_model_skateboard,
      0x02,
      index_vertex,
      0x00
    );
  }

  for (
    unsigned int index_vertex = (
      0x00
    );
    (
      index_vertex <
      metil_object_skateboard_wheel_front_right->mesh.length_vertices
    );
    ++index_vertex
  ) {
    metil_model_vertex_joint_attach(
      metil_model_skateboard,
      0x03,
      index_vertex,
      0x00
    );
  }

  for (
    unsigned int index_vertex = (
      0x00
    );
    (
      index_vertex <
      metil_object_skateboard_truck_back->mesh.length_vertices
    );
    ++index_vertex
  ) {
    metil_model_vertex_joint_attach(
      metil_model_skateboard,
      0x04,
      index_vertex,
      0x01
    );
  }

  for (
    unsigned int index_vertex = (
      0x00
    );
    (
      index_vertex <
      metil_object_skateboard_wheel_back_left->mesh.length_vertices
    );
    ++index_vertex
  ) {
    metil_model_vertex_joint_attach(
      metil_model_skateboard,
      0x05,
      index_vertex,
      0x01
    );
  }

  for (
    unsigned int index_vertex = (
      0x00
    );
    (
      index_vertex <
      metil_object_skateboard_wheel_back_right->mesh.length_vertices
    );
    ++index_vertex
  ) {
    metil_model_vertex_joint_attach(
      metil_model_skateboard,
      0x06,
      index_vertex,
      0x01
    );
  }  metil_model_buffers_initialize(
    metil,
    metil_model_player,
    metil->renderer_interface.metal_device
  );

  metil_model_buffers_initialize(
    metil,
    metil_model_skateboard,
    metil->renderer_interface.metal_device
  );

  metil_mesh_box_initialize(
    &metil_object_ground->mesh,
    (struct math_c_vector3_float) {
      .x = (
        0xffff
      ),
      .y = (
        0x01
      ),
      .z = (
        0xffff
      )
    }
  );

  metil_object_ground->position.y = (
    -0.5f
  );

  metil_object_buffers_initialize(
    metil_object_ground,
    metil->renderer_interface.metal_device
  );

  struct metil_renderer_data_object* metil_renderer_data_object = (
    metil_object_ground->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  metil_renderer_data_object->colour.x = (
    0.9f
  );

  metil_renderer_data_object->colour.y = (
    0.9f
  );

  metil_renderer_data_object->colour.z = (
    0.95f
  );

  metil_renderer_data_object->colour.w = (
    1.0f
  );

  metil_object_ground->index_pipeline_render = (
    example_model_pipeline_index_model_item
  );

  scene->destroy = (
    example_model_scene_destroy
  );
  
  scene->poll = (
    example_model_scene_poll
  );
}

void example_model_scene_poll(
  struct metil* metil,
  struct metil_scene* scene
) {
  metil_scene_poll_default(
    metil,
    scene
  );

  struct metil_model* metil_model_player = (
    scene->renderables[
      0x01
    ].renderable
  );

  struct metil_model* metil_model_skateboard = (
    scene->renderables[
      0x02
    ].renderable
  );

  metil_joint_propagate(
    &metil_model_player->joints[
      0x00
    ]
  );

  metil_joint_propagate(
    &metil_model_skateboard->joints[
      0x00
    ]
  );

  metil_joint_propagate(
    &metil_model_skateboard->joints[
      0x01
    ]
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
