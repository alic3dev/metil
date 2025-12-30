#ifndef __metil_input_metil_cursor_h
#define __metil_input_metil_cursor_h

#include <clic3_vector.h>

struct metil_input_cursor {
  unsigned char clicked;
  unsigned char down;
  unsigned char dragging;
  unsigned char lockable;
  unsigned char locked;

  struct clic3_vector2_float delta;
  struct clic3_vector2_float position_screen;
  struct clic3_vector2_float position_window;

  struct clic3_vector2_float delta_down;
  struct clic3_vector2_float position_down_screen;
  struct clic3_vector2_float position_down_window;
};

extern struct metil_input_cursor metil_input_cursor;


#if !target_os_ios
void metil_input_cursor_lockable_set();
void metil_input_cursor_lockable_unset();
#endif

#endif
