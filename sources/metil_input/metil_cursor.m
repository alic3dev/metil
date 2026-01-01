#include <metil_input/metil_cursor.h>

#if !target_os_ios
#include <AppKit/AppKit.h>
#endif

void metil_cursor_initialize(
  struct metil_cursor* metil_cursor
) {
  metil_cursor->clicked = 0;
  metil_cursor->down = 0;
  metil_cursor->delta.x = 0.0f;
  metil_cursor->delta.y = 0.0f;

  metil_cursor->delta_down.x = 0.0f;
  metil_cursor->delta_down.y = 0.0f;

  metil_cursor->lockable = 1;
  metil_cursor->locked = 0;

  metil_cursor->position_down_screen.x = 0.0f;
  metil_cursor->position_down_screen.y = 0.0f;

  metil_cursor->position_down_window.x = 0.0f;
  metil_cursor->position_down_window.y = 0.0f;

  metil_cursor->position_screen.x = 0.0f;
  metil_cursor->position_screen.y = 0.0f;

  metil_cursor->position_window.x = 0.0f;
  metil_cursor->position_window.y = 0.0f;
}

#if !target_os_ios

void metil_cursor_lockable_set(
  struct metil_cursor* metil_cursor
) {
  metil_cursor->lockable = 1;
}

void metil_cursor_lockable_unset(
  struct metil_cursor* metil_cursor
) {
  metil_cursor->lockable = 0;
  metil_cursor->locked = 0;

  metil_cursor->delta.x = 0;
  metil_cursor->delta.y = 0;

  [NSCursor unhide];
}

#endif
