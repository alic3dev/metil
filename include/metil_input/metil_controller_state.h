#ifndef __metil_input_metil_controller_state_h
#define __metil_input_metil_controller_state_h

#include <metil_input/metil_controller.h>

#include <math_c_vector.h>

struct metil_controller_state {
  float l1;
  float l2;
  float l3;

  float r1;
  float r2;
  float r3;

  float create;
  float options;

  struct math_c_vector2_float left_stick;
  struct math_c_vector2_float right_stick;

  float directional_down;
  float directional_right;
  float directional_left;
  float directional_up;

  float cross;
  float circle;
  float square;
  float triangle;

  unsigned char available;
};

void metil_controller_state_initialize(
  struct metil_controller_state* _Nonnull
);

void metil_controller_state_poll(
  struct metil_controller* _Nonnull,
  struct metil_controller_state* _Nonnull
);

#endif
