#include <metil_player/metil_player_defaults.h>

void metil_player_defaults_initialize(
  struct metil_player_defaults* metil_player_defaults
) {
  metil_player_defaults->speed_movement = (
    metil_player_defaults_speed_movement_default
  );

  metil_player_defaults->speed_rotation = (
    metil_player_defaults_speed_rotation_default
  );

  metil_player_defaults->deadzone_stick = (
    metil_player_defaults_deadzone_stick_default
  );

  metil_player_defaults->size.x = (
    metil_player_defaults_size_default_x
  );

  metil_player_defaults->size.y = (
    metil_player_defaults_size_default_y
  );

  metil_player_defaults->size.z = (
    metil_player_defaults_size_default_z
  );
}
