#ifndef __metil_input_controller_h
#define __metil_input_controller_h

struct metil_controller_state {
  float l1;
  float l2;
  float r1;
  float r2;

  float thumbstick_axis_x_left;
  float thumbstick_axis_y_left;

  float input_axis_x_right;
  float thumbstick_axis_y_right;

  float thumbstick_button_left;
  float thumbstick_button_right;

  float button_directional_pad_down;
  float button_directional_pad_right;
  float button_directional_pad_left;
  float button_directional_pad_up;

  float button_cross;
  float button_circle;
  float button_square;
  float button_triangle;

  unsigned char available;
};

extern struct metil_controller_state metil_controller_state;

void metil_controller_poll();

#endif
