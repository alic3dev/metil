#ifndef __metil_input_metil_cursor_h
#define __metil_input_metil_cursor_h

#include <clic3_vector.h>

struct metil_cursor {
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

void metil_cursor_initialize(
  struct metil_cursor* _Nonnull
);

#if !target_os_ios
void metil_cursor_lockable_set(
  struct metil_cursor* _Nonnull
);

void metil_cursor_lockable_unset(
  struct metil_cursor* _Nonnull
);
#endif

#endif
