#include <example_input_scene.h>

#include <example_input_animations/example_input_animation_kickflip.h>
#include <example_input_data.h>
#include <example_input_pipeline_index.h>
#include <example_input_stance.h>
#include <example_input_trick.h>

#include <clic3_memory.h>

#include <math_c_absolute.h>
#include <math_c_bound.h>
#include <math_c_modulus.h>
#include <math_c_pi.h>
#include <math_c_sine.h>
#include <math_c_vector.h>

#include <metil_animation/metil_animation.h>
#include <metil_direction.h>
#include <metil_mesh/metil_mesh.h>
#include <metil_mesh/metil_mesh_box.h>
#include <metil_mesh/metil_mesh_ring.h>
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
#include <metil_scenes/metil_scene_controller.h>

void example_input_scene_initialize(
  struct metil* metil,
  struct metil_scene* scene
) {
  struct example_input_pipeline_index* example_input_pipeline_index = (
    metil->data
  );

  metil_scene_initialize_with_renderables(
    metil,
    scene,
    0x03
  );

  scene->data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct example_input_data
      )
    )
  );

  struct example_input_data* example_input_data = (
    scene->data
  );

  example_input_data->animation = (
    0x00
  );

  example_input_data->trick = (
    example_input_trick_none
  );

  example_input_data->stance = (
    example_input_stance_goofy
  );

  metil->rendering_properties.camera.height = (
    0x20
  );

  metil->rendering_properties.camera.mode = (
    metil_camera_mode_third_person
  );

  scene->player.rotation.x = (
    -0.25f
  );

  scene->player.speed_movement = (
    0.25f
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
    0x02,
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
        0.5f
      ),
      .y = (
        0x02
      ),
      .z = (
        0.5f
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
        0.5f
      ),
      .y = (
        0x02
      ),
      .z = (
        0.5f
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
    &metil_object_player_arm_right->mesh,
    (struct math_c_vector3_float) {
      .x = (
        0.5f
      ),
      .y = (
        0x02
      ),
      .z = (
        0.5f
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
    &metil_object_player_arm_right_lower->mesh,
    (struct math_c_vector3_float) {
      .x = (
        0.5f
      ),
      .y = (
        0x02
      ),
      .z = (
        0.5f
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
    &metil_object_player_leg_left->mesh,
    (struct math_c_vector3_float) {
      .x = (
        0.5f
      ),
      .y = (
        0x02
      ),
      .z = (
        0.5f
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
    &metil_object_player_leg_left_lower->mesh,
    (struct math_c_vector3_float) {
      .x = (
        0.5f
      ),
      .y = (
        0x02
      ),
      .z = (
        0.5f
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
    &metil_object_player_leg_right->mesh,
    (struct math_c_vector3_float) {
      .x = (
        0.5f
      ),
      .y = (
        0x02
      ),
      .z = (
        0.5f
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
    &metil_object_player_leg_right_lower->mesh,
    (struct math_c_vector3_float) {
      .x = (
        0.5f
      ),
      .y = (
        0x02
      ),
      .z = (
        0.5f
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

  metil_mesh_box_initialize(
    &metil_object_skateboard_deck->mesh,
    (struct math_c_vector3_float) {
      .x = (
        0x01
      ),
      .y = (
        0.125f
      ),
      .z = (
        0x02
      )
    }
  );

  metil_mesh_box_initialize(
    &metil_object_skateboard_truck_front->mesh,
    (struct math_c_vector3_float) {
      .x = (
        0.9f
      ),
      .y = (
        0.125f
      ),
      .z = (
        0.125f
      )
    }
  );

  metil_mesh_box_initialize(
    &metil_object_skateboard_truck_back->mesh,
    (struct math_c_vector3_float) {
      .x = (
        0.9f
      ),
      .y = (
        0.125f
      ),
      .z = (
        0.125f
      )
    }
  );

  metil_mesh_ring_initialize(
    &metil_object_skateboard_wheel_front_left->mesh,
    (struct math_c_vector3_float) {
      .x = (
        0.25f
      ),
      .y = (
        0.25f
      ),
      .z = (
        0.25f
      ),
    },
    (struct math_c_vector3_float) {
      .x = (
        0.125f
      ),
      .y = (
        0.125f
      ),
      .z = (
        0.125f
      )
    },
    (struct math_c_vector2_unsigned_short_int) {
      .x = (
        0x08
      ),
      .y = (
        0x08
      )
    }
  );

  metil_mesh_ring_initialize(
    &metil_object_skateboard_wheel_front_right->mesh,
    (struct math_c_vector3_float) {
      .x = (
        0.25f
      ),
      .y = (
        0.25f
      ),
      .z = (
        0.25f
      )
    },
    (struct math_c_vector3_float) {
      .x = (
        0.125f
      ),
      .y = (
        0.125f
      ),
      .z = (
        0.125f
      )
    },
    (struct math_c_vector2_unsigned_short_int) {
      .x = (
        0x08
      ),
      .y = (
        0x08
      )
    }
  );

  metil_mesh_ring_initialize(
    &metil_object_skateboard_wheel_back_left->mesh,
    (struct math_c_vector3_float) {
      .x = (
        0.25f
      ),
      .y = (
        0.25f
      ),
      .z = (
        0.25f
      )
    },
    (struct math_c_vector3_float) {
      .x = (
        0.125f
      ),
      .y = (
        0.125f
      ),
      .z = (
        0.125f
      )
    },
    (struct math_c_vector2_unsigned_short_int) {
      .x = (
        0x08
      ),
      .y = (
        0x08
      )
    }
  );

  metil_mesh_ring_initialize(
    &metil_object_skateboard_wheel_back_right->mesh,
    (struct math_c_vector3_float) {
      .x = (
        0.25f
      ),
      .y = (
        0.25f
      ),
      .z = (
        0.25f
      )
    },
    (struct math_c_vector3_float) {
      .x = (
        0.125f
      ),
      .y = (
        0.125f
      ),
      .z = (
        0.125f
      )
    },
    (struct math_c_vector2_unsigned_short_int) {
      .x = (
        0x08
      ),
      .y = (
        0x08
      )
    }
  );

  metil_object_skateboard_wheel_front_left->position.x = (
    -metil_object_skateboard_deck->mesh.size.x /
    0x02 +
    metil_object_skateboard_wheel_front_left->mesh.size.x /
    0x02
  );

  metil_object_skateboard_wheel_front_left->position.y = (
    metil_object_skateboard_wheel_front_left->mesh.size.y /
    0x02
  );

  metil_object_skateboard_wheel_front_left->position.z = (
    metil_object_skateboard_deck->mesh.size.z *
    0.4f
  );

  metil_object_skateboard_wheel_front_right->position.x = (
    metil_object_skateboard_deck->mesh.size.x /
    0x02 -
    metil_object_skateboard_wheel_front_right->mesh.size.x /
    0x02
  );

  metil_object_skateboard_wheel_front_right->position.y = (
    metil_object_skateboard_wheel_front_right->mesh.size.y /
    0x02
  );

  metil_object_skateboard_wheel_front_right->position.z = (
    metil_object_skateboard_deck->mesh.size.z *
    0.4f
  );

  metil_object_skateboard_wheel_back_left->position.x = (
    metil_object_skateboard_wheel_front_left->position.x
  );

  metil_object_skateboard_wheel_back_left->position.y = (
    metil_object_skateboard_wheel_front_left->position.y
  );

  metil_object_skateboard_wheel_back_left->position.z = (
    -metil_object_skateboard_wheel_front_left->position.z
  );

  metil_object_skateboard_wheel_back_right->position.x = (
    metil_object_skateboard_wheel_front_right->position.x
  );

  metil_object_skateboard_wheel_back_right->position.y = (
    metil_object_skateboard_wheel_front_right->position.y
  );

  metil_object_skateboard_wheel_back_right->position.z = (
    -metil_object_skateboard_wheel_front_right->position.z
  );

  metil_object_skateboard_truck_front->position.y = (
    metil_object_skateboard_wheel_front_left->mesh.size.y /
    0x02
  );

  metil_object_skateboard_truck_front->position.z = (
    metil_object_skateboard_wheel_front_right->position.z
  );

  metil_object_skateboard_truck_back->position.y = (
    metil_object_skateboard_wheel_back_right->mesh.size.y /
    0x02
  );

  metil_object_skateboard_truck_back->position.z = (
    metil_object_skateboard_wheel_back_left->position.z
  );
  metil_object_skateboard_deck->position.y = (
    metil_object_skateboard_wheel_back_right->mesh.size.y *
    1.25f
  );

  metil_object_player_leg_left_lower->position.x = (
    -metil_object_player_leg_left_lower->mesh.size.x /
    0x02
  );

  metil_object_player_leg_left_lower->position.y = (
    metil_object_player_leg_left_lower->mesh.size.y /
    0x02 +
    metil_object_skateboard_deck->position.y +
    metil_object_skateboard_deck->mesh.size.y /
    0x02
  );

  metil_object_player_leg_left->position.x = (
    metil_object_player_leg_left_lower->position.x
  );

  metil_object_player_leg_left->position.y = (
    metil_object_player_leg_left_lower->position.y +
    metil_object_player_leg_left_lower->mesh.size.y /
    0x02 +
    metil_object_player_leg_left->mesh.size.y /
    0x02
  );

  metil_object_player_leg_right_lower->position.x = (
    metil_object_player_leg_right_lower->mesh.size.x /
    0x02
  );

  metil_object_player_leg_right_lower->position.y = (
    metil_object_player_leg_right_lower->mesh.size.y /
    0x02 +
    metil_object_skateboard_deck->position.y +
    metil_object_skateboard_deck->mesh.size.y /
    0x02
  );

  metil_object_player_leg_right->position.x = (
    metil_object_player_leg_right_lower->position.x
  );

  metil_object_player_leg_right->position.y = (
    metil_object_player_leg_right_lower->position.y +
    metil_object_player_leg_right_lower->mesh.size.y /
    0x02 +
    metil_object_player_leg_right->mesh.size.y /
    0x02
  );

  metil_object_player_body->position.y = (
    metil_object_player_leg_right->position.y +
    metil_object_player_leg_right->mesh.size.y /
    0x02 +
    metil_object_player_body->mesh.size.y /
    0x02
  );

  metil_object_player_arm_left->position.y = (
    metil_object_player_body->position.y +
    metil_object_player_body->mesh.size.y /
    0x02 -
    metil_object_player_arm_left->mesh.size.y /
    0x02
  );

  metil_object_player_arm_left->position.x = (
    -metil_object_player_body->mesh.size.x /
    0x02 -
    metil_object_player_arm_left->mesh.size.x /
    0x02
  );

  metil_object_player_arm_left_lower->position.x = (
    metil_object_player_arm_left->position.x
  );

  metil_object_player_arm_left_lower->position.y = (
    metil_object_player_arm_left->position.y -
    metil_object_player_arm_left->mesh.size.y /
    0x02 -
    metil_object_player_arm_left_lower->mesh.size.y /
    0x02
  );

  metil_object_player_arm_right->position.x = (
    -metil_object_player_arm_left->position.x
  );

  metil_object_player_arm_right->position.y = (
    metil_object_player_arm_left->position.y
  );

  metil_object_player_arm_right_lower->position.x = (
    metil_object_player_arm_right->position.x
  );

  metil_object_player_arm_right_lower->position.y = (
    metil_object_player_arm_left_lower->position.y
  );

  metil_object_player_head->position.y = (
    metil_object_player_body->position.y +
    metil_object_player_body->mesh.size.y /
    0x02 +
    metil_object_player_head->mesh.size.y /
    0x02
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
        0x1ff
      ),
      .y = (
        0x01
      ),
      .z = (
        0x1ff
      )
    }
  );

  metil_object_ground->position.y = (
    -0x01
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

  metil_object_player_head->index_pipeline_render = (
    example_input_pipeline_index->model_player_body
  );

  metil_object_player_arm_left->index_pipeline_render = (
    example_input_pipeline_index->model_player_shirt
  );

  metil_object_player_arm_left_lower->index_pipeline_render = (
    example_input_pipeline_index->model_player_body
  );

  metil_object_player_arm_right->index_pipeline_render = (
    example_input_pipeline_index->model_player_shirt
  );

  metil_object_player_arm_right_lower->index_pipeline_render = (
    example_input_pipeline_index->model_player_body
  );

  metil_object_player_body->index_pipeline_render = (
    example_input_pipeline_index->model_player_shirt
  );

  metil_object_player_leg_left->index_pipeline_render = (
    example_input_pipeline_index->model_player_pants
  );

  metil_object_player_leg_left_lower->index_pipeline_render = (
    example_input_pipeline_index->model_player_pants
  );

  metil_object_player_leg_right->index_pipeline_render = (
    example_input_pipeline_index->model_player_pants
  );

  metil_object_player_leg_right_lower->index_pipeline_render = (
    example_input_pipeline_index->model_player_pants
  );

  metil_object_skateboard_deck->index_pipeline_render = (
    example_input_pipeline_index->model_skateboard_deck
  );

  metil_object_skateboard_truck_front->index_pipeline_render = (
    example_input_pipeline_index->model_skateboard_truck
  );

  metil_object_skateboard_wheel_front_left->index_pipeline_render = (
    example_input_pipeline_index->model_skateboard_wheel
  );

  metil_object_skateboard_wheel_front_right->index_pipeline_render = (
    example_input_pipeline_index->model_skateboard_wheel
  );

  metil_object_skateboard_truck_back->index_pipeline_render = (
    example_input_pipeline_index->model_skateboard_truck
  );

  metil_object_skateboard_wheel_back_left->index_pipeline_render = (
    example_input_pipeline_index->model_skateboard_wheel
  );

  metil_object_skateboard_wheel_back_right->index_pipeline_render = (
    example_input_pipeline_index->model_skateboard_wheel
  );

  scene->destroy = (
    example_input_scene_destroy
  );

  scene->poll = (
    example_input_scene_poll
  );

  scene->player.poll_input = (
    example_input_scene_player_poll_input
  );
}

void example_input_scene_player_poll_input(
  struct metil* metil,
  struct metil_player* metil_player,
  unsigned long int time,
  unsigned long int time_delta
) {
  float amount_movement = (
    time_delta *
    metil_player->speed_movement
  );

  if (
    math_c_absolute_float(
      metil->input.controller_state.right_stick.y
    ) >=
    metil_player->deadzone_stick
  ) {
    metil_player->rotation.x = (
      metil_player->rotation.x +
      metil->input.controller_state.right_stick.y *
      0.1f
    );
  } else {
    metil_player->rotation.x = (
      metil_player->rotation.x +
      -metil->input.cursor.delta.y *
      0.005f
    );
  }

  
  metil_player->rotation.x = (
    math_c_bound_float(
      metil_player->rotation.x,
      -0.1f,
      -(
        math_c_pi_half *
        0.5f
      )
    )
  );
  
  if (
    math_c_absolute_float(
      metil->input.controller_state.left_stick.x
    ) >=
    metil_player->deadzone_stick
  ) {
    metil_player->rotation.y = (
      metil_player->rotation.y -
      metil->input.controller_state.left_stick.x *
      0.1f
    );
  } else {
    metil_player->rotation.y = (
      metil_player->rotation.y -
      metil->input.cursor.delta.x *
      0.005f
    );
  }
  
  while (
    metil_player->rotation.y <
    -math_c_pi
  ) {
    metil_player->rotation.y = (
      metil_player->rotation.y +
      math_c_pi_doubled
    );
  }

  while (
    metil_player->rotation.y >
    math_c_pi
  ) {
    metil_player->rotation.y = (
      metil_player->rotation.y -
      math_c_pi_doubled
    );
  }

  metil->input.cursor.delta.x = (
    0x00
  );

  metil->input.cursor.delta.y = (
    0x00
  );

  struct math_c_vector2_float ratio_movement = {
    .x = -(
      metil_player->rotation.y /
      math_c_pi_half
    ),
    .y = (
      0x00
    )
  };

  if (
    ratio_movement.x >
    0x00
  ) {
    ratio_movement.x = (
      math_c_modulus_mirror_float(
        ratio_movement.x,
        0x01
      )
    );
  } else {
    ratio_movement.x = -(
      math_c_modulus_mirror_float(
        -ratio_movement.x,
        0x01
      )
    );
  }

  ratio_movement.y = (
    0x01 -
    math_c_absolute_float(
      ratio_movement.x
    )
  );

  if (
    math_c_absolute_float(
      metil_player->rotation.y
    ) >
    math_c_pi_half
  ) {
    ratio_movement.y = -(
      ratio_movement.y
    );
  }
  
  metil_player->position.x = (
    metil_player->position.x +
    ratio_movement.x *
    amount_movement
  );

  metil_player->position.z = (
    metil_player->position.z +
    ratio_movement.y *
    amount_movement
  );

  struct metil_scene_controller* metil_scene_controller = (
    metil->scene_controller
  );

  struct metil_scene* metil_scene = &(
    metil_scene_controller->scene
  );

  struct example_input_data* example_input_data = (
    metil_scene->data
  );

  struct metil_model* metil_model_player = (
    metil_scene->renderables[
      0x01
    ].renderable
  );

  struct metil_model* metil_model_skateboard = (
    metil_scene->renderables[
      0x02
    ].renderable
  );

  if (
    metil_model_skateboard->position.y ==
    0x00
  ) {
    if (
      (
        metil->input.keydown_map[
          metil_keycode_space
        ] !=
        0x00
      ) ||
      (
        metil->input.controller_state.cross !=
        0x00
      )
    ) {
      metil_player->velocity.y = (
        0x01
      );
    } else {
      metil_player->velocity.y = (
        0x00
      );
    }
  } else {
    metil_player->velocity.y = (
      metil_player->velocity.y -
      0.004f *
      time_delta
    );

    if (
      (
        metil_player->velocity.y >=
        -0.25f
      ) &&
      (
        example_input_data->trick ==
        example_input_trick_none
      )
    ) {
      if (
        (
          metil->input.keydown_map[
            metil_keycode_e
          ] !=
          0x00
        ) ||
        (
          metil->input.controller_state.square !=
          0x00
        )
      ) {
        example_input_data->trick = (
          example_input_trick_kickflip
        );
      }
    }
  }

  metil_model_skateboard->position.y = (
    metil_model_skateboard->position.y +
    metil_player->velocity.y
  );

  if (
    metil_model_skateboard->position.y <
    0x00
  ) {
    metil_model_skateboard->position.y = (
      0x00
    );
  }

  metil_model_player->position.y = (
    metil_model_skateboard->position.y
  );
}

void example_input_scene_poll(
  struct metil* metil,
  struct metil_scene* scene
) {
  metil_scene_poll_default(
    metil,
    scene
  );

  struct example_input_data* example_input_data = (
    scene->data
  );

  if (
    example_input_data->animation ==
    0x00
  ) {
    if (
      example_input_data->trick !=
      example_input_trick_none
    ) {
      example_input_data->animation = (
        clic3_memory_allocate_raw(
          sizeof(
            struct metil_animation
          )
        )
      );

      metil_animation_initialize(
        example_input_data->animation
      );

      example_input_data->animation->loops = (
        0x00
      );

      example_input_data->animation->length = (
        0xff
      );

      switch (
        example_input_data->trick
      ) {
        case example_input_trick_kickflip: {
          example_input_data->animation->poll = (
            example_input_animation_kickflip
          );

          break;
        }
        default: {
          clic3_memory_free_raw(
            example_input_data->animation
          );

          example_input_data->animation = (
            0x00
          );

          break;
        }
      }

      if (
        example_input_data->animation !=
        0x00
      ) {
        metil_animation_start(
          example_input_data->animation,
          0x00,
          scene->renderables
        );
      }
    }
  } else if (
    example_input_data->animation->state ==
    metil_animation_state_complete
  ) {
    example_input_data->animation->poll(
      example_input_data->animation,
      0x00,
      scene,
      0x01
    );

    clic3_memory_free_raw(
      example_input_data->animation
    );

    example_input_data->animation = (
      0x00
    );

    example_input_data->trick = (
      example_input_trick_none
    );
  } else {
    metil_animation_poll(
      example_input_data->animation,
      0x00,
      scene
    );
  }

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

  metil_model_player->position.x = (
    scene->player.position.x
  );

  metil_model_player->position.z = (
    scene->player.position.z
  );

  metil_model_player->rotation.y = (
    -scene->player.rotation.y -
    math_c_pi_half
  );

  metil_model_skateboard->position.x = (
    scene->player.position.x
  );

  metil_model_skateboard->position.z = (
    scene->player.position.z
  );

  metil_model_skateboard->rotation.y = (
    -scene->player.rotation.y
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

void example_input_scene_destroy(
  struct metil* metil,
  struct metil_scene* scene
) {
  struct metil_model* metil_model = (
    scene->renderables[
      0x00
    ].renderable
  );

  metil_model->data = (
    0x00
  );

  metil_scene_destroy_default(
    metil,
    scene
  );
}
