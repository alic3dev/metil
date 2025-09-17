#ifndef __metil_player_h
#define __metil_player_h

#include <clic3_vector.h>

struct metil_player {
  struct clic3_vector3_float position;
  struct clic3_vector3_float rotation;
  struct clic3_vector3_float velocity;

  float speed_movement;
  float speed_rotation;

  void* data;
};

void metil_player_initialize(
  struct metil_player*
);

void metil_player_poll_input(
  struct metil_player*
);

void metil_player_poll(
  struct metil_player*
);

void metil_player_destroy(
  struct metil_player*
);

#endif
