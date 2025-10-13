#include <metil_application/metil_window.h>

#include <metil_input/cursor.h>
#include <metil_input/map.h>

#include <CoreGraphics/CoreGraphics.h>

@implementation metil_window {}

- (char) acceptsMouseMovedEvents {
  return 1;
}

- (char) canBecomeKeyWindow {
  return 1;
}

- (void) center_mouse {
  CGRect rect = [self contentLayoutRect];

  CGPoint point_mouse = {
    .x = rect.origin.x + (
      rect.size.width / 2.0f
    ),
    .y = rect.origin.y + (
      rect.size.height / 2.0f
    )
  };

  CGWarpMouseCursorPosition(
    point_mouse
  );
}

- (void) flagsChanged: (NSEvent*) event {
  // TODO: Find what determines if this is a keyup or keydown
  if (event.keyCode < metil_input_map_keydown_length) {
    metil_input_map_keydown[
      event.keyCode
    ] = metil_input_map_keydown[
      event.keyCode
    ] == 1 ? 0 : 1;
  }
}

- (void) keyDown: (NSEvent*) event {
  unsigned short int code_key = event.keyCode;

  if (
    event.keyCode < metil_input_map_keydown_length
  ) {
    metil_input_map_keydown[
      code_key
    ] = 1;
  }
}

- (void) keyUp: (NSEvent*) event {
  if (
    event.keyCode < metil_input_map_keydown_length
  ) {
    metil_input_map_keydown[
      event.keyCode
    ] = 0;
  }

  if (
    event.keyCode == metil_keycode_esc
  ) {
    metil_input_cursor.locked = 0;

    [NSCursor unhide];
  }
}

- (void) mouseDown: (NSEvent*) event {
  if (
    metil_input_cursor.locked != 1
  ) {
    metil_input_cursor.locked = 1;

    metil_input_cursor.delta.x = 0;
    metil_input_cursor.delta.y = 0;

    moved_after_lock = 0;

    [NSCursor hide];

    [self center_mouse];
  }
}

- (void) mouseDragged: (NSEvent*) event {
  metil_input_cursor.dragging = 1;

  [self process_mouse_movement_event: event];
}

- (void) mouseMoved: (NSEvent*) event {
  [self process_mouse_movement_event: event];
}

- (void) mouseUp: (NSEvent*) event {
  metil_input_cursor.dragging = 0;
}

- (void) process_mouse_movement_event: (NSEvent*) event {
  metil_input_cursor.position_screen.x = NSEvent.mouseLocation.x;
  metil_input_cursor.position_screen.y = NSEvent.mouseLocation.y;

  metil_input_cursor.position_window.x = event.locationInWindow.x;
  metil_input_cursor.position_window.y = event.locationInWindow.y;

  if (
    metil_input_cursor.locked == 1 &&
    moved_after_lock == 0
  ) {
    moved_after_lock = 1;
  } else {
    metil_input_cursor.delta.x = (
      metil_input_cursor.delta.x +
      event.deltaX
    );

    metil_input_cursor.delta.y = (
      metil_input_cursor.delta.y +
      event.deltaY
    );
  }

  if (
    metil_input_cursor.locked == 1
  ) {
    [self center_mouse];
  }
}

@end
