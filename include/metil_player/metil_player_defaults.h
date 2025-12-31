#ifndef __metil_player_metil_player_defaults_h
#define __metil_player_metil_player_defaults_h

#include <metil_rendering/metil_camera/metil_camera.h>

#define metil_player_defaults_speed_movement_default 16.5f
#define metil_player_defaults_speed_rotation_default 0.2f
#define metil_player_defaults_deadzone_stick_default 0.01f

#define metil_player_defaults_size_default_x 0.36f
#define metil_player_defaults_size_default_y metil_camera_height_default
#define metil_player_defaults_size_default_z 0.3f

struct metil_player_defaults {
  float speed_movement;
  float speed_rotation;
  float deadzone_stick;

  struct clic3_vector3_float size;

  unsigned char initialized;
};

void metil_player_defaults_initialize(
  struct metil_player_defaults*
);

#endif
