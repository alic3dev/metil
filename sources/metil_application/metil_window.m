#include <metil_application/metil_window.h>

#if !target_os_ios

#include <metil_input/metil_cursor.h>
#include <metil_input/metil_input_map.h>

#include <AppKit/AppKit.h>
#include <CoreGraphics/CoreGraphics.h>

@implementation metil_window {}

- (char) acceptsMouseMovedEvents {
  return (
    0x01
  );
}

- (char) canBecomeKeyWindow {
  return (
    0x01
  );
}

- (void) center_mouse {
  NSScreen* screen = [
    NSScreen
    mainScreen
  ];

  NSRect frame_screen = [
    screen
    frame
  ];

  NSRect frame_window = [
    self
    frame
  ];

  CGPoint point_center_window_in_screen = {
    .x = (
      frame_window.origin.x +
      (
        frame_window.size.width /
        0x02
      )
    ),
    .y = (
      frame_screen.size.height -
      (
        frame_window.origin.y +
        (
          frame_window.size.height /
          0x02
        )
      )
    )
  };

  CGWarpMouseCursorPosition(
    point_center_window_in_screen
  );
}

- (void) flagsChanged: (NSEvent*) event {
  unsigned char down_lock_capitals = (
    (
      event.modifierFlags &
      0x10000
    ) ==
    0x00
    ? 0x00
    : 0x01
  );

  unsigned char down_shift = (
    (
      event.modifierFlags &
      0x20000
    ) ==
    0x00
    ? 0x00
    : 0x01
  );

  unsigned char down_control = (
    (
      event.modifierFlags &
      0x40000
    ) ==
    0x00
    ? 0x00
    : 0x01
  );

  unsigned char down_option = (
    (
      event.modifierFlags &
      0x80000
    ) ==
    0x00
    ? 0x00
    : 0x01
  );

  unsigned char down_command = (
    (
      event.modifierFlags &
      0x100000
    ) ==
    0x00
    ? 0x00
    : 0x01
  );

  metil->input.keydown_map[
    metil_keycode_caps_lock
  ] = (
    down_lock_capitals
  );

  metil->input.keydown_map[
    metil_keycode_control
  ] = (
    down_control
  );

  unsigned char flip_key = (
    0x00
  );

  switch (
    event.keyCode
  ) {
    case metil_keycode_shift_left:
    case metil_keycode_shift_right: {
      if (
        down_shift ==
        0x01
      ) {
        flip_key = (
          0x01
        );
      } else {
        metil->input.keydown_map[
          metil_keycode_shift_left
        ] = (
          0x00
        );

        metil->input.keydown_map[
          metil_keycode_shift_right
        ] = (
          0x00
        );
      }
      break;
    }
    case metil_keycode_option_left:
    case metil_keycode_option_right: {
      if (
        down_option ==
        0x01
      ) {
        flip_key = (
          0x01
        );
      } else {
        metil->input.keydown_map[
          metil_keycode_option_left
        ] = (
          0x00
        );

        metil->input.keydown_map[
          metil_keycode_option_right
        ] = (
          0x00
        );
      }

      break;
    }
    case metil_keycode_command_left:
    case metil_keycode_command_right: {
      if (
        down_command ==
        0x01
      ) {
        flip_key = (
          0x01
        );
      } else {
        metil->input.keydown_map[
          metil_keycode_command_left
        ] = (
          0x00
        );

        metil->input.keydown_map[
          metil_keycode_command_right
        ] = (
          0x00
        );
      }

      break;
    }
    default: {
      break;
    }
  }

  if (
    flip_key ==
    0x01
  ) {
    self->metil->input.keydown_map[
      event.keyCode
    ] = (
      (
        self->metil->input.keydown_map[
          event.keyCode
        ] ==
        0x00
      )
      ? 0x01
      : 0x00
    );
  }
}

- (void) keyDown: (NSEvent*) event {
  unsigned short int code_key = (
    event.keyCode
  );

  if (
    event.keyCode <
    metil_input_map_keydown_length
  ) {
    self->metil->input.keydown_map[
      code_key
    ] = (
      0x01
    );
  }
}

- (void) keyUp: (NSEvent*) event {
  if (
    event.keyCode <
    metil_input_map_keydown_length
  ) {
    self->metil->input.keydown_map[
      event.keyCode
    ] = (
      0x00
    );
  }
  if (
    (
      event.keyCode ==
      metil_keycode_esc
    ) &&
    (
      self->metil->input.cursor.lockable ==
      0x01
    )
  ) {
    self->metil->input.cursor.locked = (
      0x00
    );

    [
      NSCursor
      unhide
    ];
  }
}

- (void) mouseDown: (NSEvent*) event {
  self->metil->input.cursor.down = (
    0x01
  );

  self->metil->input.cursor.position_down_screen.x = (
    NSEvent.mouseLocation.x
  );

  self->metil->input.cursor.position_down_screen.y = (
    NSEvent.mouseLocation.y
  );

  self->metil->input.cursor.position_down_window.x = (
    event.locationInWindow.x
  );

  self->metil->input.cursor.position_down_window.y = (
    event.locationInWindow.y
  );

  self->metil->input.cursor.delta_down.x = (
    event.deltaX
  );

  self->metil->input.cursor.delta_down.y = (
    event.deltaY
  );

  [
    self
    process_mouse_movement_event: (
      event
    )
  ];

  if (
    (
      self->metil->input.cursor.lockable ==
      0x01
    ) &&
    (
      self->metil->input.cursor.locked !=
      0x01
    )
  ) {
    self->metil->input.cursor.locked = (
      0x01
    );

    self->metil->input.cursor.delta.x = (
      0x00
    );

    self->metil->input.cursor.delta.y = (
      0x00
    );

    moved_after_lock = (
      0x00
    );

    [
      NSCursor
      hide
    ];

    [
      self
      center_mouse
    ];
  }
}

- (void) mouseDragged: (NSEvent*) event {
  self->metil->input.cursor.dragging = (
    0x01
  );

  [
    self
    process_mouse_movement_event: (
      event
    )
  ];
}

- (void) mouseMoved: (NSEvent*) event {
  [
    self
    process_mouse_movement_event: (
      event
    )
  ];
}

- (void) mouseUp: (NSEvent*) event {
  self->metil->input.cursor.down = (
    0x00
  );

  self->metil->input.cursor.dragging = (
    0x00
  );
}

- (void) process_mouse_movement_event: (NSEvent*) event {
  self->metil->input.cursor.position_screen.x = (
    NSEvent.mouseLocation.x
  );

  self->metil->input.cursor.position_screen.y = (
    NSEvent.mouseLocation.y
  );

  self->metil->input.cursor.position_window.x = (
    event.locationInWindow.x
  );

  self->metil->input.cursor.position_window.y = (
    event.locationInWindow.y
  );

  if (
    (
      self->metil->input.cursor.lockable ==
      0x01
    ) &&
    (
      self->metil->input.cursor.locked ==
      0x01
    )
  ) {
    if (
      moved_after_lock ==
      0x02
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
        0x01
      );
    }

    [
      self
      center_mouse
    ];
  }
}

- (void) metil_set: (struct metil*) _metil {
  self->metil = (
    _metil
  );
}

- (void) allow_recording {
  self.sharingType = (
    NSWindowSharingReadOnly
  );
}

- (void) prevent_recording {
  self.sharingType = (
    NSWindowSharingNone
  );
}

@end

#endif
