#ifndef __metil_input_controller_state_h
#define __metil_input_controller_state_h

#include <clic3_vector.h>

struct metil_controller_state {
  float l1;
  float l2;
  float l3;

  float r1;
  float r2;
  float r3;

  float create;
  float options;

  struct clic3_vector2_float left_stick;
  struct clic3_vector2_float right_stick;

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

extern struct metil_controller_state metil_controller_state;

void metil_controller_state_poll();

#endif
