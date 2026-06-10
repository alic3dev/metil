#include <metil_input/metil_cursor.h>

#if !target_os_ios
#include <AppKit/AppKit.h>
#endif

void metil_cursor_initialize(
  struct metil_cursor* metil_cursor
) {
  metil_cursor->clicked = (
    0x00
  );

  metil_cursor->down = (
    0x00
  );

  metil_cursor->delta.x = (
    0x00
  );

  metil_cursor->delta.y = (
    0x00
  );

  metil_cursor->delta_down.x = (
    0x00
  );

  metil_cursor->delta_down.y = (
    0x00
  );

  metil_cursor->lockable = (
    0x01
  );

  metil_cursor->locked = (
    0x00
  );

  metil_cursor->position_down_screen.x = (
    0x00
  );

  metil_cursor->position_down_screen.y = (
    0x00
  );

  metil_cursor->position_down_window.x = (
    0x00
  );

  metil_cursor->position_down_window.y = (
    0x00
  );

  metil_cursor->position_screen.x = (
    0x00
  );

  metil_cursor->position_screen.y = (
    0x00
  );

  metil_cursor->position_window.x = (
    0x00
  );

  metil_cursor->position_window.y = (
    0x00
  );
}

#if !target_os_ios

void metil_cursor_lockable_set(
  struct metil_cursor* metil_cursor
) {
  metil_cursor->lockable = (
    0x01
  );
}

void metil_cursor_lockable_unset(
  struct metil_cursor* metil_cursor
) {
  metil_cursor->lockable = (
    0x00
  );

  metil_cursor->locked = (
    0x00
  );

  metil_cursor->delta.x = (
    0x00
  );

  metil_cursor->delta.y = (
    0x00
  );

  [
    NSCursor
    unhide
  ];
}

#endif
