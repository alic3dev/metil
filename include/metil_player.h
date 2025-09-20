#ifndef __metil_player_h
#define __metil_player_h

#include <clic3_vector.h>

#include <metil_rendering/camera/camera.h>

struct metil_player;

typedef void (*metil_player_poll_input_function)(
  struct metil_player*,
  unsigned long int,
  unsigned long int
);
typedef void (*metil_player_poll_function)(struct metil_player*);
typedef void (*metil_player_destroy_function)(struct metil_player*);

#define __metil_player_speed_movement_default 16.5f
#define __metil_player_speed_rotation_default 0.2f

extern float metil_player_speed_movement_default;
extern float metil_player_speed_rotation_default;

#define __metil_player_size_default_x 0.36f
#define __metil_player_size_default_y __metil_camera_height_default
#define __metil_player_size_default_z 0.3f

extern struct clic3_vector3_float metil_player_size_default;

struct metil_player {
  struct clic3_vector3_float position;
  struct clic3_vector3_float rotation;
  struct clic3_vector3_float size;
  struct clic3_vector3_float velocity;

  float speed_movement;
  float speed_rotation;

  metil_player_poll_input_function poll_input;
  metil_player_poll_function poll;
  metil_player_destroy_function destroy;

  void* data;
};

void metil_player_initialize(
  struct metil_player*
);

void metil_player_poll_input(
  struct metil_player*,
  unsigned long int,
  unsigned long int
);

void metil_player_poll_input_null(
  struct metil_player*,
  unsigned long int,
  unsigned long int
);

void metil_player_poll(
  struct metil_player*
);

void metil_player_destroy(
  struct metil_player*
);

#endif
