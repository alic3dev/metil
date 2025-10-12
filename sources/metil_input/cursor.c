#include <metil_input/cursor.h>

unsigned char metil_input_locked_cursor = 0;
unsigned char metil_input_dragging_cursor = 0;

struct clic3_vector2_float metil_input_delta_cursor = {
  .x = 0.0f,
  .y = 0.0f
};

struct clic3_vector2_float metil_input_position_cursor_screen = {
  .x = 0.0f,
  .y = 0.0f
};

struct clic3_vector2_float metil_input_position_cursor_window = {
  .x = 0.0f,
  .y = 0.0f
};
