#ifndef __metil_player_metil_player_h
#define __metil_player_metil_player_h

#include <clic3_vector.h>

#include <metil.h>
#include <metil_player/metil_player_defaults.h>

struct metil_player;

typedef void (*metil_player_poll_input_function)(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull,
  unsigned long int,
  unsigned long int
);

typedef void (*metil_player_poll_function)(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull
);

typedef void (*metil_player_destroy_function)(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull
);

struct metil_player {
  struct clic3_vector3_float position;
  struct clic3_vector3_float rotation;
  struct clic3_vector3_float size;
  struct clic3_vector3_float velocity;

  float position_y_floor;

  float deadzone_stick;

  float speed_movement;
  float speed_rotation;

  metil_player_poll_input_function _Nonnull poll_input;
  metil_player_poll_function _Nonnull poll;
  metil_player_destroy_function _Nonnull destroy;

  void* _Nullable data;
};

void metil_player_initialize(
  struct metil_player* _Nonnull,
  struct metil_player_defaults* _Nonnull
);

void metil_player_poll_input(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull,
  unsigned long int,
  unsigned long int
);

void metil_player_poll_input_null(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull,
  unsigned long int,
  unsigned long int
);

void metil_player_poll(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull
);

void metil_player_destroy(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull
);

#endif
