#ifndef __metil_player_h
#define __metil_player_h

#include <clic3_vector.h>

#include <metil_player/metil_player_defaults.h>

struct metil_player;

typedef void (*metil_player_poll_input_function)(
  struct metil_player*,
  unsigned long int,
  unsigned long int
);

typedef void (*metil_player_poll_function)(
  struct metil_player*
);

typedef void (*metil_player_destroy_function)(
  struct metil_player*
);

struct metil_player {
  struct clic3_vector3_float position;
  struct clic3_vector3_float rotation;
  struct clic3_vector3_float size;
  struct clic3_vector3_float velocity;

  float deadzone_stick;

  float speed_movement;
  float speed_rotation;

  metil_player_poll_input_function poll_input;
  metil_player_poll_function poll;
  metil_player_destroy_function destroy;

  struct metil_player_defaults defaults;

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
