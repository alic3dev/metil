#include <metil_application/metil_window.h>

#if !target_os_ios

#include <metil_input/metil_cursor.h>
#include <metil_input/metil_input_map.h>

#include <AppKit/AppKit.h>
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
  if (
    event.keyCode < metil_input_map_keydown_length
  ) {
    self->metil->input.keydown_map[
      event.keyCode
    ] = self->metil->input.keydown_map[
      event.keyCode
    ] == 1 ? 0 : 1;
  }
}

- (void) keyDown: (NSEvent*) event {
  unsigned short int code_key = event.keyCode;

  if (
    event.keyCode < metil_input_map_keydown_length
  ) {
    self->metil->input.keydown_map[
      code_key
    ] = 1;
  }
}

- (void) keyUp: (NSEvent*) event {
  if (
    event.keyCode < metil_input_map_keydown_length
  ) {
    self->metil->input.keydown_map[
      event.keyCode
    ] = 0;
  }

  if (
    event.keyCode == metil_keycode_esc &&
    self->metil->input.cursor.lockable == 1
  ) {
    self->metil->input.cursor.locked = 0;

    [NSCursor unhide];
  }
}

- (void) mouseDown: (NSEvent*) event {
  self->metil->input.cursor.down = 1;

  self->metil->input.cursor.position_down_screen.x = NSEvent.mouseLocation.x;
  self->metil->input.cursor.position_down_screen.y = NSEvent.mouseLocation.y;

  self->metil->input.cursor.position_down_window.x = event.locationInWindow.x;
  self->metil->input.cursor.position_down_window.y = event.locationInWindow.y;

  self->metil->input.cursor.delta_down.x = event.deltaX;
  self->metil->input.cursor.delta_down.y = event.deltaY;

  if (
    self->metil->input.cursor.lockable == 1 &&
    self->metil->input.cursor.locked != 1
  ) {
    self->metil->input.cursor.locked = 1;

    self->metil->input.cursor.delta.x = 0;
    self->metil->input.cursor.delta.y = 0;

    moved_after_lock = 0;

    [NSCursor hide];

    [self center_mouse];
  }
}

- (void) mouseDragged: (NSEvent*) event {
  self->metil->input.cursor.dragging = 1;

  [self process_mouse_movement_event: event];
}

- (void) mouseMoved: (NSEvent*) event {
  [self process_mouse_movement_event: event];
}

- (void) mouseUp: (NSEvent*) event {
  self->metil->input.cursor.down = 0;
  self->metil->input.cursor.dragging = 0;
}

- (void) process_mouse_movement_event: (NSEvent*) event {
  self->metil->input.cursor.position_screen.x = NSEvent.mouseLocation.x;
  self->metil->input.cursor.position_screen.y = NSEvent.mouseLocation.y;

  self->metil->input.cursor.position_window.x = event.locationInWindow.x;
  self->metil->input.cursor.position_window.y = event.locationInWindow.y;

  if (
    self->metil->input.cursor.lockable == 1 &&
    self->metil->input.cursor.locked == 1
  ) {
    if (
      moved_after_lock == 2
    ) {
      self->metil->input.cursor.delta.x = (
        self->metil->input.cursor.delta.x +
        event.deltaX
      );

      self->metil->input.cursor.delta.y = (
        self->metil->input.cursor.delta.y +
        event.deltaY
      );
    } else {
      moved_after_lock = (
        moved_after_lock +
        1
      );
    }

    [self center_mouse];
  }
}

- (void) metil_set: (struct metil*) _metil {
  self->metil = _metil;
}

@end

#endif
