#ifndef __metil_cursor_h
#define __metil_cursor_h

#include <clic3_vector.h>

struct metil_input_cursor {
  unsigned char locked;
  unsigned char dragging;

  struct clic3_vector2_float delta;
  struct clic3_vector2_float position_screen;
  struct clic3_vector2_float position_window;
};

extern struct metil_input_cursor metil_input_cursor;

#endif
