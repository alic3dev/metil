#ifndef __metil_input_controller_h
#define __metil_input_controller_h

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

  float button_directional_down;
  float button_directional_right;
  float button_directional_left;
  float button_directional_up;

  float button_cross;
  float button_circle;
  float button_square;
  float button_triangle;

  unsigned char available;
};

extern struct metil_controller_state metil_controller_state;

void metil_controller_poll();

#endif
