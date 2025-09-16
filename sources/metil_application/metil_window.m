#include <metil_application/metil_window.h>

#include <metil_input/cursor.h>
#include <metil_input/map.h>

#include <CoreGraphics/CoreGraphics.h>

@implementation metil_window {}

- (void) keyDown: (NSEvent*) event {
  unsigned short int code_key = event.keyCode;

  if (event.keyCode < metil_input_map_keydown_length) {
    metil_input_map_keydown[
      code_key
    ] = 1;
  }
}

- (void) mouseDown:(NSEvent *) event {
  if (locked_cursor != 1) {
    locked_cursor = 1;
    moved_after_lock = 0;
    [NSCursor hide];
    [self center_mouse];
  }
}

- (void) mouseMoved: (NSEvent*) event {
  if (moved_after_lock == 0) {
    moved_after_lock = 1;
    return;
  }

  if (
    locked_cursor == 1
  ) {
    metil_input_delta_cursor.x = (
      metil_input_delta_cursor.x + 
      event.deltaX
    );

    metil_input_delta_cursor.y = (
      metil_input_delta_cursor.y + 
      event.deltaY
    );

    [self center_mouse];
  }
}

- (void) center_mouse {
  CGRect rect = [self contentLayoutRect];
  CGPoint point_mouse = {
    .x = rect.origin.x + (rect.size.width / 2),
    .y = rect.origin.y + (rect.size.height / 2)
  };

  CGWarpMouseCursorPosition(
    point_mouse
  );
}

- (void) keyUp: (NSEvent*) event {
  if (
    event.keyCode < metil_input_map_keydown_length
  ) {
    metil_input_map_keydown[
      event.keyCode
    ] = 0;
  }

  if (event.keyCode == metil_keycode_esc) {
    locked_cursor = 0;
    [NSCursor unhide];
  }
}

- (void) flagsChanged:(NSEvent*) event {
  // TODO: Find whatever flag determines if this is a keyup or keydown
  if (event.keyCode < metil_input_map_keydown_length) {
    metil_input_map_keydown[
      event.keyCode
    ] = metil_input_map_keydown[
      event.keyCode
    ] == 1 ? 0 : 1;
  }
}

- (BOOL) acceptsMouseMovedEvents {
  return 1;
}

- (BOOL) canBecomeKeyWindow {
  return 1;
}

@end
