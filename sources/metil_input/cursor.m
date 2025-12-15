#include <metil_input/cursor.h>

#if !target_os_ios
#include <AppKit/AppKit.h>
#endif

struct metil_input_cursor metil_input_cursor = {
  .clicked = 0,
  .down = 0,
  .delta = {
    .x = 0.0f,
    .y = 0.0f
  },
  .delta_down = {
    .x = 0.0f,
    .y = 0.0f
  },
  .lockable = 1,
  .locked = 0,
  .position_down_screen = {
    .x = 0.0f,
    .y = 0.0f
  },
  .position_down_window = {
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

#if !target_os_ios

void metil_input_cursor_lockable_set() {
  metil_input_cursor.lockable = 1;
}

void metil_input_cursor_lockable_unset() {
  metil_input_cursor.lockable = 0;
  metil_input_cursor.locked = 0;

  metil_input_cursor.delta.x = 0;
  metil_input_cursor.delta.y = 0;

  [NSCursor unhide];
}

#endif
