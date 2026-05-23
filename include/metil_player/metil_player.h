#ifndef __metil_player_metil_player_h
#define __metil_player_metil_player_h

#include <math_c_vector.h>

#include <metil.h>
#include <metil_player/metil_player_defaults.h>

struct metil_player;

typedef void (*metil_player_poll_input_function)(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull,
  unsigned long int,
  unsigned long int
);

typedef void (*metil_player_poll_input_function_rotation)(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull
);

typedef void (*metil_player_poll_input_function_rotation_ratio)(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull,
  struct math_c_vector2_float* _Nonnull,
  struct math_c_vector2_float* _Nonnull
);

typedef void (*metil_player_poll_input_function_movement)(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull,
  struct math_c_vector2_float* _Nonnull,
  struct math_c_vector2_float* _Nonnull,
  float,
  float
);

typedef void (*metil_player_poll_input_function_speed_movement)(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull,
  float
);

typedef void (*metil_player_poll_input_function_movement_y)(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull,
  struct math_c_vector2_float* _Nonnull,
  struct math_c_vector2_float* _Nonnull,
  float,
  float
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
  struct math_c_vector3_float position;
  struct math_c_vector3_float rotation;
  struct math_c_vector3_float size;
  struct math_c_vector3_float velocity;

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

void metil_player_poll_input_free_flying_locked(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull,
  unsigned long int,
  unsigned long int
);

void metil_player_poll_input_free_flying_unlocked(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull,
  unsigned long int,
  unsigned long int
);

void metil_player_poll_input_with_functions(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull,
  unsigned long int,
  unsigned long int,
  metil_player_poll_input_function_speed_movement _Nonnull,
  metil_player_poll_input_function_rotation _Nonnull,
  metil_player_poll_input_function_rotation_ratio _Nonnull,
  metil_player_poll_input_function_movement _Nonnull,
  metil_player_poll_input_function_movement_y _Nonnull
);

void metil_player_poll_input_rotation(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull
);

void metil_player_poll_input_rotation_ratio(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull,
  struct math_c_vector2_float* _Nonnull,
  struct math_c_vector2_float* _Nonnull
);

void metil_player_poll_input_movement(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull,
  struct math_c_vector2_float* _Nonnull,
  struct math_c_vector2_float* _Nonnull,
  float,
  float
);

void metil_player_poll_input_speed_movement(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull,
  float
);

void metil_player_poll_input_movement_y_jumpable(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull,
  struct math_c_vector2_float* _Nonnull,
  struct math_c_vector2_float* _Nonnull,
  float,
  float
);

void metil_player_poll_input_movement_y_free_flying_locked(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull,
  struct math_c_vector2_float* _Nonnull,
  struct math_c_vector2_float* _Nonnull,
  float,
  float
);

void metil_player_poll_input_movement_y_free_flying_unlocked(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull,
  struct math_c_vector2_float* _Nonnull,
  struct math_c_vector2_float* _Nonnull,
  float,
  float
);

float metil_player_poll_input_movement_y_free_flying_movement_y_get(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull
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
