#include <metil_input/metil_controller_state/metil_controller_state_structure.h>

void metil_controller_state_initialize(
  struct metil_controller_state* metil_controller_state
) {
  metil_controller_state->l1 = 0.0f;
  metil_controller_state->l2 = 0.0f;
  metil_controller_state->l3 = 0.0f;

  metil_controller_state->r1 = 0.0f;
  metil_controller_state->r2 = 0.0f;
  metil_controller_state->r3 = 0.0f;

  metil_controller_state->create = 0.0f;
  metil_controller_state->options = 0.0f;

  metil_controller_state->left_stick.x = 0.0f;
  metil_controller_state->left_stick.y = 0.0f;

  metil_controller_state->right_stick.x = 0.0f;
  metil_controller_state->right_stick.y = 0.0f;

  metil_controller_state->directional_down = 0.0f;
  metil_controller_state->directional_right = 0.0f;
  metil_controller_state->directional_left = 0.0f;
  metil_controller_state->directional_up = 0.0f;

  metil_controller_state->cross = 0.0f;
  metil_controller_state->circle = 0.0f;
  metil_controller_state->square = 0.0f;
  metil_controller_state->triangle = 0.0f;

  metil_controller_state->available = 0;
}
