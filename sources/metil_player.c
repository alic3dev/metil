#include <metil_player.h>

#include <clic3_vector.h>

#include <metil_input/controller_state.h>
#include <metil_input/cursor.h>
#include <metil_input/keycodes.h>
#include <metil_input/map.h>

#include <math.h>

float metil_player_speed_movement_default = __metil_player_speed_movement_default;
float metil_player_speed_rotation_default = __metil_player_speed_rotation_default;

struct clic3_vector3_float metil_player_size_default = {
  .x = __metil_player_size_default_x,
  .y = __metil_player_size_default_y,
  .z = __metil_player_size_default_z
};

void metil_player_initialize(
  struct metil_player* player
) {
  player->position.x = 0.0f;
  player->position.y = 0.0f;
  player->position.z = 0.0f;

  player->rotation.x = 0.0f;
  player->rotation.y = 0.0f;
  player->rotation.z = 0.0f;

  player->size.x = metil_player_size_default.x;
  player->size.y = metil_player_size_default.y;
  player->size.z = metil_player_size_default.z;

  player->speed_movement = metil_player_speed_movement_default;
  player->speed_rotation = metil_player_speed_rotation_default;

  player->velocity.x = 0.0f;
  player->velocity.y = 0.0f;
  player->velocity.z = 0.0f;

  player->poll_input = metil_player_poll_input;
  player->poll = metil_player_poll;
  player->destroy = metil_player_destroy;

  player->data = (void*)0;
}

void metil_player_poll_input(
  struct metil_player* player,
  unsigned long int time,
  unsigned long int time_delta
) {
  float speed_original = player->speed_movement;
  float speed_delta = (float) time_delta / 1000.0f;

  player->speed_movement = (
    player->speed_movement *
    speed_delta
  );

  if (
    metil_controller_state.available == 1 &&
    metil_controller_state.l2 >= 0.1f &&
    metil_controller_state.l3 == 0.0f
  ) {
    player->speed_movement = (
      player->speed_movement *
      (metil_controller_state.l2 + 1.0f)
    );
  } else if (
    metil_controller_state.available == 1 &&
    metil_controller_state.l2 < 0.1f &&
    metil_controller_state.l3 >= 0.1f
  ) {
    player->speed_movement = (
      player->speed_movement / (
        metil_controller_state.l3 + 1.0f
      )
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
    player->rotation.x - (
      metil_input_delta_cursor.y / 50.0f *
      player->speed_rotation
    )
  );

  if (metil_controller_state.available == 1) {
    if (
      metil_controller_state.right_stick.x >= 0.1f || 
      metil_controller_state.right_stick.x <= -0.1f
    ) {
      player->rotation.y = (
        player->rotation.y + (
          metil_controller_state.right_stick.x *
          player->speed_rotation
        )
      );
    }

    if (
      metil_controller_state.right_stick.y >= 0.1f || 
      metil_controller_state.right_stick.y <= -0.1f
    ) {
      player->rotation.x = (
        player->rotation.x + (
          metil_controller_state.right_stick.y *
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

  player->rotation.y = fmod(
    player->rotation.y,
    (M_PI * 2.0f)
  );

  metil_input_delta_cursor.x = 0;
  metil_input_delta_cursor.y = 0;
  
  float ratio_axis = player->rotation.y / (M_PI * 2.0f);

  if (
    ratio_axis >= 0.0f &&
    ratio_axis <= 0.25f
  ) {
    ratio_movement.y = (0.25f - ratio_axis) / 0.25f;
    ratio_movement.x = (ratio_axis / 0.25f);

    ratio_movement_strafe.y = -(ratio_axis / 0.25f);
    ratio_movement_strafe.x = (0.25f - ratio_axis) / 0.25f;
  } else if (
    ratio_axis >= 0.25f &&
    ratio_axis <= 0.5f 
  ) {
    ratio_axis = ratio_axis - 0.25f;

    ratio_movement.y = -(ratio_axis / 0.25f);
    ratio_movement.x = (0.25f - ratio_axis) / 0.25f;

    ratio_movement_strafe.y = -(0.25f - ratio_axis) / 0.25f;
    ratio_movement_strafe.x = -(ratio_axis / 0.25f);
  } else if (
    ratio_axis >= 0.5f &&
    ratio_axis <= 0.75f 
  ) {
    ratio_axis = ratio_axis - 0.5f;

    ratio_movement.y = -(0.25f - ratio_axis) / 0.25f;
    ratio_movement.x = -(ratio_axis / 0.25f);

    ratio_movement_strafe.y = (ratio_axis / 0.25f);
    ratio_movement_strafe.x = -(0.25f - ratio_axis) / 0.25f;
  } else if (
    ratio_axis > 0.75f
  ) {
    ratio_axis = ratio_axis - 0.75f;

    ratio_movement.y = (ratio_axis / 0.25f);
    ratio_movement.x = -(0.25f - ratio_axis) / 0.25f;

    ratio_movement_strafe.y = (0.25f - ratio_axis) / 0.25f;
    ratio_movement_strafe.x = (ratio_axis / 0.25f);
  } else if (
    ratio_axis >= -0.25f
  ) {
    ratio_movement.y = (-0.25f - ratio_axis) / -0.25f;
    ratio_movement.x = (ratio_axis / 0.25f);

    ratio_movement_strafe.y = -(ratio_axis / 0.25f);
    ratio_movement_strafe.x = (-0.25f - ratio_axis) / -0.25f;
  } else if (
    ratio_axis <= -0.25f &&
    ratio_axis >= -0.5f
  ) {
    ratio_axis = ratio_axis + 0.25f;

    ratio_movement.y = -(ratio_axis / -0.25f);
    ratio_movement.x = (-0.25f - ratio_axis) / 0.25f;

    ratio_movement_strafe.y = -(-0.25f - ratio_axis) / 0.25f;
    ratio_movement_strafe.x = -(ratio_axis / -0.25f);
  } else if (
    ratio_axis <= -0.5f &&
    ratio_axis >= -0.75f 
  ) {
    ratio_axis = ratio_axis + 0.5f;

    ratio_movement.y = -(-0.25f - ratio_axis) / -0.25f;
    ratio_movement.x = -(ratio_axis / 0.25f);

    ratio_movement_strafe.y = (ratio_axis / 0.25f);
    ratio_movement_strafe.x = -(-0.25f - ratio_axis) / -0.25f;
  } else {
    ratio_axis = ratio_axis + 0.75f;

    ratio_movement.y = (ratio_axis / -0.25f);
    ratio_movement.x = -(-0.25f - ratio_axis) / 0.25f;

    ratio_movement_strafe.y = (-0.25f - ratio_axis) / 0.25f;
    ratio_movement_strafe.x = (ratio_axis / -0.25f);
  }

  if (
    metil_controller_state.available == 1 &&
    metil_controller_state.left_stick.x != 0.0f ||
    metil_controller_state.left_stick.y != 0.0f
  ) {
    movement.x = (
      (metil_controller_state.left_stick.y * ratio_movement.x) +
      (metil_controller_state.left_stick.x * ratio_movement_strafe.x)
    );

    movement.z = (
      (metil_controller_state.left_stick.y * ratio_movement.y) +
      (metil_controller_state.left_stick.x * ratio_movement_strafe.y)
    );
  } else {
    struct clic3_vector2_float direction_arrows = {
      .x = (
        (
          metil_input_map_keydown[
            metil_keycode_right_arrow
          ] || metil_input_map_keydown[
            metil_keycode_d
          ]
        ) - (
          metil_input_map_keydown[
            metil_keycode_left_arrow
          ] || metil_input_map_keydown[
            metil_keycode_a
          ]
        )
      ),
      .y = (
        (
          metil_input_map_keydown[
            metil_keycode_up_arrow
          ] || metil_input_map_keydown[
            metil_keycode_w
          ]
        ) - (
          metil_input_map_keydown[
            metil_keycode_down_arrow
          ] || 
          metil_input_map_keydown[
            metil_keycode_s
          ]
        )
      )
    };

    if (
      direction_arrows.x != 0.0f &&
      direction_arrows.y != 0.0f
    ) {
      direction_arrows.x = (
        direction_arrows.x * 0.82f
      );

      direction_arrows.y = (
        direction_arrows.y * 0.82f
      );
    }

    movement.x = (
      direction_arrows.y * ratio_movement.x +
      direction_arrows.x * ratio_movement_strafe.x
    );

    movement.z = (
      direction_arrows.y * ratio_movement.y +
      direction_arrows.x * ratio_movement_strafe.y
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
    (metil_input_map_keydown[
      metil_keycode_space
    ] == 1 ||(
      metil_controller_state.available == 1 &&
      metil_controller_state.cross >= 0.1f
    )) &&
    player->velocity.y == 0.0f
  ) {
    player->velocity.y = (
      speed_original /
      1.25f
    );
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
    ) + (
      player->velocity.y *
      speed_delta
    )
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
        speed_original
      ) * speed_delta * 5.0f
    );
  }

  if (player->position.y < 0.0f) {
    player->position.y = 0.0f;
    player->velocity.y = 0.0f;
  }

  player->speed_movement = speed_original;
}

void metil_player_poll_input_null(
  struct metil_player* player,
  unsigned long int time,
  unsigned long int time_delta
) {}

void metil_player_poll(
  struct metil_player* player
) {}

void metil_player_destroy(
  struct metil_player* player
) {}
