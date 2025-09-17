#ifndef __metil_player_h
#define __metil_player_h

#include <clic3_vector.h>

struct metil_player;

typedef void (*metil_player_poll_input_function)(
  struct metil_player*,
  unsigned long int
);
typedef void (*metil_player_poll_function)(struct metil_player*);
typedef void (*metil_player_destroy_function)(struct metil_player*);

extern const float metil_player_speed_movement_default;
extern const float metil_player_speed_rotation_default;

struct metil_player {
  struct clic3_vector3_float position;
  struct clic3_vector3_float rotation;
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
  unsigned long int
);

void metil_player_poll(
  struct metil_player*
);

void metil_player_destroy(
  struct metil_player*
);

#endif
