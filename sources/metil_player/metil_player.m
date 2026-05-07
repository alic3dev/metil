#include <metil_player/metil_player.h>

#include <math_c_bound.h>
#include <math_c_modulus.h>
#include <math_c_pi.h>
#include <math_c_vector.h>

#include <metil.h>
#include <metil_input/metil_input.h>
#include <metil_input/metil_keycodes.h>
#include <metil_player/metil_player_defaults.h>

void metil_player_initialize(
  struct metil_player* metil_player,
  struct metil_player_defaults* metil_player_defaults
) {
  metil_player->position.x = (
    0x00
  );

  metil_player->position.y = (
    0x00
  );

  metil_player->position.z = (
    0x00
  );

  metil_player->rotation.x = (
    0x00
  );

  metil_player->rotation.y = (
    0x00
  );

  metil_player->rotation.z = (
    0x00
  );

  metil_player->size.x = (
    metil_player_defaults->size.x
  );

  metil_player->size.y = (
    metil_player_defaults->size.y
  );

  metil_player->size.z = (
    metil_player_defaults->size.z
  );

  metil_player->deadzone_stick = (
    metil_player_defaults->deadzone_stick
  );

  metil_player->speed_movement = (
    metil_player_defaults->speed_movement
  );

  metil_player->speed_rotation = (
    metil_player_defaults->speed_rotation
  );

  metil_player->velocity.x = (
    0x00
  );

  metil_player->velocity.y = (
    0x00
  );

  metil_player->velocity.z = (
    0x00
  );

  metil_player->position_y_floor = (
    0x00
  );

  metil_player->poll_input = (
    metil_player_poll_input
  );

  metil_player->poll = (
    metil_player_poll
  );

  metil_player->destroy = (
    metil_player_destroy
  );

  metil_player->data = (
    0x00
  );
}

void metil_player_poll_input(
  struct metil* metil,
  struct metil_player* metil_player,
  unsigned long int time,
  unsigned long int time_delta
) {
  float speed_original = (
    metil_player->speed_movement
  );

  float speed_delta = (
    (float)
    time_delta /
    0x03e8
  );

  metil_player->speed_movement = (
    metil_player->speed_movement *
    speed_delta
  );

  if (
    (
      metil->input.controller_state.available ==
      0x01
    ) &&
    (
      metil->input.controller_state.l2 >=
      0.1f
    ) && (
      metil->input.controller_state.l3 ==
      0x00
    )
  ) {
    metil_player->speed_movement = (
      metil_player->speed_movement *
      (
        metil->input.controller_state.l2 +
        0x01
      )
    );
  } else if (
    (
      metil->input.controller_state.available ==
      0x01
    ) &&
    (
      metil->input.controller_state.l2 <
      0.1f
    ) &&
    (
      metil->input.controller_state.l3 >=
      0.1f
    )
  ) {
    metil_player->speed_movement = (
      metil_player->speed_movement /
      (
        metil->input.controller_state.l3 +
        0x01
      )
    );
  } else if (
    (
      (
        metil->input.keydown_map[
          metil_keycode_option_right
        ] ==
        0x01
      ) ||
      (
        metil->input.keydown_map[
          metil_keycode_control
        ] ==
        0x01
      )
    )  &&
    (
      (
        metil->input.keydown_map[
          metil_keycode_shift_left
        ] ==
        0x00
      ) &&
      (
        metil->input.keydown_map[
          metil_keycode_shift_right
        ] ==
        0x00
      )
    )
  ) {
    metil_player->speed_movement = (
      metil_player->speed_movement /
      0x02
    );
  } else if (
    (
      (
        metil->input.keydown_map[
          metil_keycode_option_right
        ] ==
        0x00
      ) &&
      (
        metil->input.keydown_map[
          metil_keycode_control
        ] ==
        0x00
      )
    ) && (
      (
        metil->input.keydown_map[
          metil_keycode_shift_left
        ] ==
        0x01
      ) ||
      (
        metil->input.keydown_map[
          metil_keycode_shift_right
        ] ==
        0x01
      )
    )
  ) {
    metil_player->speed_movement = (
      metil_player->speed_movement *
      0x02
    );
  }

  struct math_c_vector3_float movement = {
    .x = (
      0x00
    ),
    .y = (
      0x00
    ),
    .z = (
      0x00
    )
  };

  struct math_c_vector2_float ratio_movement = {
    .x = (
      0x00
    ),
    .y = (
      0x00
    )
  };

  struct math_c_vector2_float ratio_movement_strafe = {
    .x = (
      0x00
    ),
    .y = (
      0x00
    )
  };

  if (
    metil->input.cursor.locked ==
    0x01
  ) {
    metil_player->rotation.y = (
      metil_player->rotation.y -
      (
        metil->input.cursor.delta.x /
        0x32 *
        metil_player->speed_rotation
      )
    );

    metil_player->rotation.x = (
      metil_player->rotation.x -
      (
        metil->input.cursor.delta.y /
        0x32 *
        metil_player->speed_rotation
      )
    );

    metil->input.cursor.delta.x = (
      0x00
    );

    metil->input.cursor.delta.y = (
      0x00
    );
  }

  if (
    metil->input.controller_state.available ==
    0x01
  ) {
    if (
      (
        metil->input.controller_state.right_stick.x >=
        metil_player->deadzone_stick
      ) ||
      (
        metil->input.controller_state.right_stick.x <=
        -metil_player->deadzone_stick
      )
    ) {
      metil_player->rotation.y = (
        metil_player->rotation.y -
        (
          metil->input.controller_state.right_stick.x *
          metil_player->speed_rotation
        )
      );
    }

    if (
      (
        metil->input.controller_state.right_stick.y >=
        metil_player->deadzone_stick
      ) ||
      (
        metil->input.controller_state.right_stick.y <=
        -metil_player->deadzone_stick
      )
    ) {
      metil_player->rotation.x = (
        metil_player->rotation.x +
        (
          metil->input.controller_state.right_stick.y *
          metil_player->speed_rotation
        )
      );
    }
  }

  metil_player->rotation.x = (
    math_c_bound_float(
      metil_player->rotation.x,
      math_c_pi_half,
      -math_c_pi_half
    )
  );

  metil_player->rotation.y = (
    math_c_modulus_float(
      metil_player->rotation.y,
      math_c_pi_doubled
    )
  );

  float ratio_axis = -(
    metil_player->rotation.y /
    math_c_pi_doubled
  );

  if (
    (
      ratio_axis >=
      0x00
    ) &&
    (
      ratio_axis <=
      0.25f
    )
  ) {
    ratio_movement.y = (
      (
        0.25f -
        ratio_axis
      ) /
      0.25f
    );

    ratio_movement.x = (
      ratio_axis /
      0.25f
    );

    ratio_movement_strafe.y = -(
      ratio_axis /
      0.25f
    );

    ratio_movement_strafe.x = (
      (
        0.25f -
        ratio_axis
      ) /
      0.25f
    );
  } else if (
    (
      ratio_axis >=
      0.25f
    ) &&
    (
      ratio_axis <=
      0.5f
    )
  ) {
    ratio_axis = (
      ratio_axis -
      0.25f
    );

    ratio_movement.y = -(
      ratio_axis /
      0.25f
    );

    ratio_movement.x = (
      (
        0.25f -
        ratio_axis
      ) /
      0.25f
    );

    ratio_movement_strafe.y = -(
      (
        0.25f -
        ratio_axis
      ) /
      0.25f
    );

    ratio_movement_strafe.x = -(
      ratio_axis /
      0.25f
    );
  } else if (
    (
      ratio_axis >=
      0.5f
    ) &&
    (
      ratio_axis <=
      0.75f
    )
  ) {
    ratio_axis = (
      ratio_axis -
      0.5f
    );

    ratio_movement.y = -(
      (
        0.25f -
        ratio_axis
      ) /
      0.25f
    );

    ratio_movement.x = -(
      ratio_axis /
      0.25f
    );

    ratio_movement_strafe.y = (
      ratio_axis /
      0.25f
    );

    ratio_movement_strafe.x = -(
      (
        0.25f -
        ratio_axis
      ) /
      0.25f
    );
  } else if (
    ratio_axis >
    0.75f
  ) {
    ratio_axis = (
      ratio_axis -
      0.75f
    );

    ratio_movement.y = (
      ratio_axis /
      0.25f
    );

    ratio_movement.x = -(
      (
        0.25f -
        ratio_axis
      ) /
      0.25f
    );

    ratio_movement_strafe.y = (
      (
        0.25f -
        ratio_axis
      ) /
      0.25f
    );

    ratio_movement_strafe.x = (
      ratio_axis /
      0.25f
    );
  } else if (
    ratio_axis >=
    -0.25f
  ) {
    ratio_movement.y = (
      (
        -0.25f -
        ratio_axis
      ) /
      -0.25f
    );

    ratio_movement.x = (
      ratio_axis /
      0.25f
    );

    ratio_movement_strafe.y = -(
      ratio_axis /
      0.25f
    );

    ratio_movement_strafe.x = (
      (
        -0.25f -
        ratio_axis
      ) /
      -0.25f
    );
  } else if (
    (
      ratio_axis <=
      -0.25f
    ) &&
    (
      ratio_axis >=
      -0.5f
    )
  ) {
    ratio_axis = (
      ratio_axis +
      0.25f
    );

    ratio_movement.y = -(
      ratio_axis /
      -0.25f
    );

    ratio_movement.x = (
      (
        -0.25f -
        ratio_axis
      ) /
      0.25f
    );

    ratio_movement_strafe.y = -(
      (
        -0.25f -
        ratio_axis
      ) /
      0.25f
    );

    ratio_movement_strafe.x = -(
      ratio_axis /
      -0.25f
    );
  } else if (
    (
      ratio_axis <=
      -0.5f
    ) &&
    (
      ratio_axis >=
      -0.75f
    )
  ) {
    ratio_axis = (
      ratio_axis +
      0.5f
    );

    ratio_movement.y = -(
      (
        -0.25f -
        ratio_axis
      ) /
      -0.25f
    );

    ratio_movement.x = -(
      ratio_axis /
      0.25f
    );

    ratio_movement_strafe.y = (
      ratio_axis /
      0.25f
    );

    ratio_movement_strafe.x = -(
      (
        -0.25f -
        ratio_axis
      ) /
      -0.25f
    );
  } else {
    ratio_axis = (
      ratio_axis +
      0.75f
    );

    ratio_movement.y = (
      ratio_axis /
      -0.25f
    );

    ratio_movement.x = -(
      (
        -0.25f -
        ratio_axis
      ) /
      0.25f
    );

    ratio_movement_strafe.y = (
      (
        -0.25f -
        ratio_axis
      ) /
      0.25f
    );

    ratio_movement_strafe.x = (
      ratio_axis /
      -0.25f
    );
  }

  if (
    (
      metil->input.controller_state.available ==
      0x01
    ) &&
    (
      (
        metil->input.controller_state.left_stick.x >=
        metil_player->deadzone_stick
      ) ||
      (
        metil->input.controller_state.left_stick.x <=
        -metil_player->deadzone_stick
      ) ||
      (
        metil->input.controller_state.left_stick.y >=
        metil_player->deadzone_stick
      ) ||
      (
        metil->input.controller_state.left_stick.y <=
        -metil_player->deadzone_stick
      )
    )
  ) {
    movement.x = (
      (
        metil->input.controller_state.left_stick.y *
        ratio_movement.x
      ) +
      (
        metil->input.controller_state.left_stick.x *
        ratio_movement_strafe.x
      )
    );

    movement.z = (
      (
        metil->input.controller_state.left_stick.y *
        ratio_movement.y
      ) +
      (
        metil->input.controller_state.left_stick.x *
        ratio_movement_strafe.y
      )
    );
  } else {
    struct math_c_vector2_float direction_arrows = {
      .x = (
        (
          metil->input.keydown_map[
            metil_keycode_right_arrow
          ] ||
          metil->input.keydown_map[
            metil_keycode_d
          ] ||
          metil->input.keydown_map[
            metil_keycode_single_quote
          ]
        ) -
        (
          metil->input.keydown_map[
            metil_keycode_left_arrow
          ] ||
          metil->input.keydown_map[
            metil_keycode_a
          ] ||
          metil->input.keydown_map[
            metil_keycode_l
          ]
        )
      ),
      .y = (
        (
          metil->input.keydown_map[
            metil_keycode_up_arrow
          ] ||
          metil->input.keydown_map[
            metil_keycode_w
          ] ||
          metil->input.keydown_map[
            metil_keycode_p
          ]
        ) - (
          metil->input.keydown_map[
            metil_keycode_down_arrow
          ] ||
          metil->input.keydown_map[
            metil_keycode_s
          ] ||
          metil->input.keydown_map[
            metil_keycode_semi_colon
          ]
        )
      )
    };

    if (
      (
        direction_arrows.x !=
        0x00
      ) &&
      (
        direction_arrows.y !=
        0x00
      )
    ) {
      direction_arrows.x = (
        direction_arrows.x *
        0.82f
      );

      direction_arrows.y = (
        direction_arrows.y *
        0.82f
      );
    }

    movement.x = (
      direction_arrows.y *
      ratio_movement.x +
      direction_arrows.x *
      ratio_movement_strafe.x
    );

    movement.z = (
      direction_arrows.y *
      ratio_movement.y +
      direction_arrows.x *
      ratio_movement_strafe.y
    );
  }

  if (
    (
      metil->input.keydown_map[
        metil_keycode_q
      ] ==
      0x01
    ) ||
    (
      metil->input.keydown_map[
        metil_keycode_opening_square_bracket
      ] ==
      0x01
    ) ||
    (
      metil->input.keydown_map[
        metil_keycode_e
      ] ==
      0x01
    ) ||
    (
      metil->input.keydown_map[
        metil_keycode_o
      ] ==
      0x01
    )
  ) {
    movement.y = (
      -(
        (
          metil->input.keydown_map[
            metil_keycode_q
          ] ==
          0x01
        ) ||
        (
          metil->input.keydown_map[
            metil_keycode_opening_square_bracket
          ] ==
          0x01
        )
      ) +
      (
        (
          metil->input.keydown_map[
            metil_keycode_e
          ] ==
          0x01
        ) ||
        (
          metil->input.keydown_map[
            metil_keycode_o
          ] ==
          0x01
        )
      )
    );

    movement.y = (
      math_c_bound_float(
        movement.y,
        0x01,
        -0x01
      )
    );
  }

  if (
    (
      (
        metil->input.keydown_map[
          metil_keycode_space
        ] == 0x01
      ) ||
      (
        (
          metil->input.controller_state.available ==
          0x01
        ) &&
        (
          metil->input.controller_state.cross >=
          0.1f
        )
      )
    ) &&
    (
      metil_player->velocity.y ==
      0x00
    )
  ) {
    metil_player->velocity.y = (
      speed_original /
      1.25f
    );
  }

  metil_player->position.x = (
    metil_player->position.x +
    (
      movement.x *
      metil_player->speed_movement
    )
  );

  metil_player->position.y = (
    metil_player->position.y +
    (
      movement.y *
      metil_player->speed_movement
    ) +
    (
      metil_player->velocity.y *
      speed_delta
    )
  );

  metil_player->position.z = (
    metil_player->position.z +
    (
      movement.z *
      metil_player->speed_movement
    )
  );

  if (
    metil_player->position.y >
    metil_player->position_y_floor
  ) {
    metil_player->velocity.y = (
      metil_player->velocity.y -
      speed_original *
      speed_delta *
      0x05
    );
  }

  if (
    metil_player->position.y <
    metil_player->position_y_floor
  ) {
    metil_player->position.y = (
      metil_player->position_y_floor
    );

    metil_player->velocity.y = (
      0x00
    );
  }

  metil_player->speed_movement = (
    speed_original
  );
}

void metil_player_poll_input_null(
  struct metil* metil,
  struct metil_player* player,
  unsigned long int time,
  unsigned long int time_delta
) {}

void metil_player_poll(
  struct metil* metil,
  struct metil_player* player
) {}

void metil_player_destroy(
  struct metil* metil,
  struct metil_player* player
) {}
