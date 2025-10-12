#include <metil_input/cursor.h>

struct metil_input_cursor metil_input_cursor = {
  .locked = 0,
  .dragging = 0,
  .delta = {
    .x = 0.0f,
    .y = 0.0f
  },
  .position_screen = {
    .x = 0.0f,
    .y = 0.0f
  },
  .position_window = {
    .x = 0.0f,
    .y = 0.0f
  }
};
