#include <metil_player.h>

#include <metil_input/controller.h>
#include <metil_input/cursor.h>
#include <metil_input/keycodes.h>
#include <metil_input/map.h>

#include <math.h>

void metil_player_initialize(
  struct metil_player* player
) {
  player->position.x = 0.0f;
  player->position.y = 0.0f;
  player->position.z = 0.0f;

  player->speed_movement = 0.8f;
  player->speed_rotation = (
    player->speed_movement / 4.0f
  );

  player->velocity.x = 0.0f;
  player->velocity.y = 0.0f;
  player->velocity.z = 0.0f;

  player->data = (void*)0;
}

void metil_player_poll_input(
  struct metil_player* player
) {
  float speed_original = player->speed_movement;

  if (
    metil_controller_state.available == 1 &&
    metil_controller_state.trigger_left >= 0.1f &&
    metil_controller_state.thumbstick_button_left == 0.0f
  ) {
    player->speed_movement = (
      player->speed_movement *
      metil_controller_state.trigger_left +
      1.0f
    );
  } else if (
    metil_controller_state.available == 1 &&
    metil_controller_state.trigger_left < 0.1f &&
    metil_controller_state.thumbstick_button_left >= 0.1f
  ) {
    player->speed_movement = (
      player->speed_movement / 2.0f
    );
  } else if (
    (
      metil_input_map_keydown[
        metil_keycode_option_right
      ] == 1 ||
      metil_input_map_keydown[
        metil_keycode_control
      ] == 1
    )  && (
      metil_input_map_keydown[
        metil_keycode_shift_left
      ] == 0 &&
      metil_input_map_keydown[
        metil_keycode_shift_right
      ] == 0
    )
  ) {
    player->speed_movement = (
      player->speed_movement / 2.0f
    );
  } else if (
    (
      metil_input_map_keydown[
        metil_keycode_option_right
      ] == 0 &&
      metil_input_map_keydown[
        metil_keycode_control
      ] == 0
    ) && (
      metil_input_map_keydown[
        metil_keycode_shift_left
      ] == 1 ||
      metil_input_map_keydown[
        metil_keycode_shift_right
      ] == 1 
    )
  ) {
    player->speed_movement = (
      player->speed_movement * 2.0f
    );
  }

  struct clic3_vector3_float movement = {
    .x = 0.0f,
    .y = 0.0f,
    .z = 0.0f
  };

  struct clic3_vector2_float ratio_movement = {
    .x = 0.0f,
    .y = 0.0f
  };

  struct clic3_vector2_float ratio_movement_strafe = {
    .x = 0.0f,
    .y = 0.0f
  };

  player->rotation.y = (
    player->rotation.y + (
      metil_input_delta_cursor.x / 50.0f *
      player->speed_rotation
    )
  );

  player->rotation.x = (
    player->rotation.x + (
      metil_input_delta_cursor.y / 50.0f *
      player->speed_rotation
    )
  );

  if (metil_controller_state.available == 1) {
    if (
      metil_controller_state.input_axis_x_right >= 0.1f || 
      metil_controller_state.input_axis_x_right <= -0.1f
    ) {
      player->rotation.y = (
        player->rotation.y + (
          metil_controller_state.input_axis_x_right *
          player->speed_rotation
        )
      );
    }

    if (
      metil_controller_state.thumbstick_axis_y_right >= 0.1f || 
      metil_controller_state.thumbstick_axis_y_right <= -0.1f
    ) {
      player->rotation.x = (
        player->rotation.x + (
          -metil_controller_state.thumbstick_axis_y_right *
          player->speed_rotation
        )
      );
    }
  }

  if (
    player->rotation.x > M_PI / 2.0f
  ) {
    player->rotation.x = M_PI / 2.0f;
  } else if (
    player->rotation.x < -M_PI / 2.0f
  ) {
    player->rotation.x = -M_PI / 2.0f;
  }

  metil_input_delta_cursor.x = 0;
  metil_input_delta_cursor.y = 0;
  
  float ratio_axis = fmod(
    player->rotation.y,
    (M_PI * 2.0f)
  ) / (M_PI * 2.0f);

  if (ratio_axis >= 0.0f) {
    if (
      ratio_axis <= 0.25f
    ) {
      ratio_movement.y = -(0.25f - ratio_axis) / 0.25f;
      ratio_movement.x = (ratio_axis / 0.25f);
    } else if (
      ratio_axis >= 0.25f &&
      ratio_axis <= 0.5f 
    ) {
      ratio_axis = ratio_axis - 0.25f;

      ratio_movement.y = (ratio_axis / 0.25f);
      ratio_movement.x = (0.25f - ratio_axis) / 0.25f;
    } else if (
      ratio_axis >= 0.5f &&
      ratio_axis <= 0.75f 
    ) {
      ratio_axis = ratio_axis - 0.5f;

      ratio_movement.y = (0.25f - ratio_axis) / 0.25f;
      ratio_movement.x = -(ratio_axis / 0.25f);
    } else {
      ratio_axis = ratio_axis - 0.75f;

      ratio_movement.y = -(ratio_axis / 0.25f);
      ratio_movement.x = -(0.25f - ratio_axis) / 0.25f;
    }
  } else {
    if (
      ratio_axis >= -0.25f
    ) {
      ratio_movement.y = -(-0.25f - ratio_axis) / -0.25f;
      ratio_movement.x = (ratio_axis / 0.25f);
    } else if (
      ratio_axis <= -0.25f &&
      ratio_axis >= -0.5f
    ) {
      ratio_axis = ratio_axis + 0.25f;

      ratio_movement.y = (ratio_axis / -0.25f);
      ratio_movement.x = (-0.25f - ratio_axis) / 0.25f;
    } else if (
      ratio_axis <= -0.5f &&
      ratio_axis >= -0.75f 
    ) {
      ratio_axis = ratio_axis + 0.5f;

      ratio_movement.y = (-0.25f - ratio_axis) / -0.25f;
      ratio_movement.x = -(ratio_axis / 0.25f);
    } else {
      ratio_axis = ratio_axis + 0.75f;

      ratio_movement.y = -(ratio_axis / -0.25f);
      ratio_movement.x = -(-0.25f - ratio_axis) / 0.25f;
    }
  }

  ratio_axis = fmod(
    player->rotation.y,
    (M_PI * 2.0f)
  ) / (M_PI * 2.0f);

  if (ratio_axis >= 0.0f) {
    if (
      ratio_axis <= 0.25f
    ) {
      ratio_movement_strafe.y = (ratio_axis / 0.25f);
      ratio_movement_strafe.x = (0.25f - ratio_axis) / 0.25f;
    } else if (
      ratio_axis >= 0.25f &&
      ratio_axis <= 0.5f
    ) {
      ratio_axis = ratio_axis - 0.25f;

      ratio_movement_strafe.y = (0.25f - ratio_axis) / 0.25f;
      ratio_movement_strafe.x = -(ratio_axis / 0.25f);
    } else if (
      ratio_axis >= 0.5f &&
      ratio_axis <= 0.75f
    ) {
      ratio_axis = ratio_axis - 0.5f;

      ratio_movement_strafe.y = -(ratio_axis / 0.25f);
      ratio_movement_strafe.x = -(0.25f - ratio_axis) / 0.25f;
    } else {
      ratio_axis = ratio_axis - 0.75f;

      ratio_movement_strafe.y = -(0.25f - ratio_axis) / 0.25f;
      ratio_movement_strafe.x = (ratio_axis / 0.25f);
    }
  } else {
    if (
      ratio_axis >= -0.25f
    ) {
      ratio_movement_strafe.y = (ratio_axis / 0.25f);
      ratio_movement_strafe.x = (-0.25f - ratio_axis) / -0.25f;
    } else if (
      ratio_axis <= -0.25f &&
      ratio_axis >= -0.5f
    ) {
      ratio_axis = ratio_axis + 0.25f;

      ratio_movement_strafe.y = (-0.25f - ratio_axis) / 0.25f;
      ratio_movement_strafe.x = -(ratio_axis / -0.25f);
    } else if (
      ratio_axis <= -0.5f &&
      ratio_axis >= -0.75f
    ) {
      ratio_axis = ratio_axis + 0.5f;

      ratio_movement_strafe.y = -(ratio_axis / 0.25f);
      ratio_movement_strafe.x = -(-0.25f - ratio_axis) / -0.25f;
    } else {
      ratio_axis = ratio_axis + 0.75f;

      ratio_movement_strafe.y = -(-0.25f - ratio_axis) / 0.25f;
      ratio_movement_strafe.x = (ratio_axis / -0.25f);
    }
  }

  if (metil_controller_state.available == 1) {
    movement.x = (
      (metil_controller_state.thumbstick_axis_y_left * ratio_movement.x) +
      (metil_controller_state.thumbstick_axis_x_left * ratio_movement_strafe.x)
    );

    movement.z = (
      (metil_controller_state.thumbstick_axis_y_left * ratio_movement.y) +
      (metil_controller_state.thumbstick_axis_x_left * ratio_movement_strafe.y)
    );
  }

  if (
    metil_input_map_keydown[
      metil_keycode_q
    ] == 1 ||
    metil_input_map_keydown[
      metil_keycode_e
    ] == 1 ||
    metil_input_map_keydown[
      metil_keycode_period
    ] == 1 ||
    metil_input_map_keydown[
      metil_keycode_slash
    ] == 1
  ) {
    movement.y = (
      -metil_input_map_keydown[
        metil_keycode_q
      ] +
      metil_input_map_keydown[
        metil_keycode_e
      ] + 
      -metil_input_map_keydown[
        metil_keycode_period
      ] +
      metil_input_map_keydown[
        metil_keycode_slash
      ]
    );

    if (movement.y > 1.0f) {
      movement.y = 1.0f;
    } else if (movement.y < -1.0f) {
      movement.y = -1.0f;
    }
  }

  if (
    metil_input_map_keydown[
      metil_keycode_left_arrow
    ] == 1 ||
    metil_input_map_keydown[
      metil_keycode_right_arrow
    ] == 1 ||
    metil_input_map_keydown[
      metil_keycode_a
    ] == 1 ||
    metil_input_map_keydown[
      metil_keycode_d
    ] == 1  ||
    metil_input_map_keydown[
      metil_keycode_down_arrow
    ] == 1 || 
    metil_input_map_keydown[
      metil_keycode_up_arrow
    ] == 1 || 
    metil_input_map_keydown[
      metil_keycode_s
    ] == 1 ||
    metil_input_map_keydown[
      metil_keycode_w
    ] == 1
  ) {
    movement.x = (
      (
        metil_input_map_keydown[
          metil_keycode_up_arrow
        ] || metil_input_map_keydown[
          metil_keycode_w
        ]
      ) * ratio_movement.x +
      -(
        metil_input_map_keydown[
          metil_keycode_down_arrow
        ] || 
        metil_input_map_keydown[
          metil_keycode_s
        ]
      ) * ratio_movement.x +
      (
        metil_input_map_keydown[
          metil_keycode_right_arrow
        ] || metil_input_map_keydown[
          metil_keycode_d
        ]
      ) * ratio_movement_strafe.x +
      -(
        metil_input_map_keydown[
          metil_keycode_left_arrow
        ] || metil_input_map_keydown[
          metil_keycode_a
        ]
      ) * ratio_movement_strafe.x
    );

    movement.z = (
      (
        metil_input_map_keydown[
          metil_keycode_up_arrow
        ] || metil_input_map_keydown[
          metil_keycode_w
        ]
      ) * ratio_movement.y +
      -(
        metil_input_map_keydown[
          metil_keycode_down_arrow
        ] || metil_input_map_keydown[
          metil_keycode_s
        ]
      ) * ratio_movement.y +
      (
        metil_input_map_keydown[
          metil_keycode_right_arrow
        ] || 
        metil_input_map_keydown[
          metil_keycode_d
        ]
      ) * ratio_movement_strafe.y + 
      -(
        metil_input_map_keydown[
          metil_keycode_left_arrow
        ] || metil_input_map_keydown[
          metil_keycode_a
        ]
      ) * ratio_movement_strafe.y
    );
  }

  if (
    (metil_input_map_keydown[
      metil_keycode_space
    ] == 1 ||(
      metil_controller_state.available == 1 &&
      metil_controller_state.button_cross >= 0.1f
    )) &&
    player->velocity.y == 0.0f
  ) {
    player->velocity.y = speed_original / 1.25f;
  }

  player->position.x = (
    player->position.x + (
      movement.x *
      player->speed_movement
    )
  );

  player->position.y = (
    player->position.y + (
      movement.y *
      player->speed_movement
    ) + player->velocity.y
  );

  player->position.z = (
    player->position.z + (
      movement.z *
      player->speed_movement
    )
  );

  if (player->position.y > 0.0f) {
    player->velocity.y = (
      player->velocity.y - (
        speed_original / 50.0f
      )
    );
  }

  if (player->position.y < 0.0f) {
    player->position.y = 0.0f;
    player->velocity.y = 0.0f;
  }

  player->speed_movement = speed_original;
}

void metil_player_poll(
  struct metil_player* player
) {}

void metil_player_destroy(
  struct metil_player* player
) {}
