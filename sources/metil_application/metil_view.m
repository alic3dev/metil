#include <metil_application/metil_view.h>

#if target_os_ios
#include <clic3_bytes.h>

#include <UIKit/UIEvent.h>
#include <UIKit/UITouch.h>
#endif

@implementation metil_view {}

#if target_os_ios
- (char) isMultipleTouchEnabled {
  return (
    0x01
  );
}

- (char) isExclusiveTouch {
  return (
    0x01
  );
}

- (void) touchesBegan: (NSSet<UITouch*>*) touches withEvent: (UIEvent*) event {
  NSArray<UITouch*>* touches_array = [
    touches
    allObjects
  ];

  UITouch* touch = [
    touches
    anyObject
  ];

  CGPoint position = [
    touch
    preciseLocationInView: self
  ];

  self->metil->input.touch.touching = (
    0x01
  );

  self->metil->input.touch.pressure = (
    touch.force
  );

  self->metil->input.touch.maximum_pressure = (
    touch.maximumPossibleForce
  );

  self->metil->input.touch.position.x = (
    position.x
  );

  self->metil->input.touch.position.y = (
    position.y
  );

  self->metil->input.touch.delta.x = (
    0.0f
  );

  self->metil->input.touch.delta.y = (
    0.0f
  );

  unsigned char length_touches = (
    touches_array.count
  );

  for (
    unsigned char index_touches = (
      0x00
    );
    (
      index_touches <
      length_touches
    );
    ++index_touches
  ) {
    self->metil->input.touch.length_touches = (
      self->metil->input.touch.length_touches +
      0x01
    );

    unsigned char index_touch;

    if (
      self->metil->input.touch.length_touches >
      0x05
    ) {
      self->metil->input.touch.length_touches = (
        0x05
      );

      index_touch = (
        0x00
      );
    } else {
      index_touch = (
        self->metil->input.touch.length_touches -
        0x01
      );
    }

    [
      self
      touch_update: touch
      index_touch: index_touch
    ];

    struct metil_touch_item* metil_touch_item = &(
      metil->input.touch.touches[
        index_touch
      ]
    );

    metil_touch_item->index_touch = (
      self->metil->input.touch.index_touch
    );

    self->metil->input.touch.index_touch = (
      self->metil->input.touch.index_touch +
      0x01
    );

    metil_touch_item->delta.x = (
      0x00
    );

    metil_touch_item->delta.y = (
      0x00
    );
  }
}

- (void) touch_update: (UITouch*) touch index_touch: (unsigned char) index_touch {
  struct metil_touch_item* metil_touch_item = &(
    self->metil->input.touch.touches[
      index_touch
    ]
  );

  metil_touch_item->touch = (
    touch
  );

  metil_touch_item->touching = (
    0x01
  );

  metil_touch_item->pressure = (
    touch.force
  );

  metil_touch_item->maximum_pressure = (
    touch.maximumPossibleForce
  );

  CGPoint position = [
    touch
    preciseLocationInView: self
  ];

  metil_touch_item->delta.x = (
    metil_touch_item->delta.x +
    (
      position.x -
      metil_touch_item->position.x
    )
  );

  metil_touch_item->delta.y = (
    metil_touch_item->delta.y +
    (
      position.y -
      metil_touch_item->position.y
    )
  );

  metil_touch_item->position.x = (
    position.x
  );

  metil_touch_item->position.y = (
    position.y
  );
}

- (unsigned char) touch_index_get: (void*) touch {
  unsigned char index_touch = (
    0xff
  );

  for (
    unsigned char index_touches = (
      0x00
    );
    (
      index_touches <
      self->metil->input.touch.length_touches
    );
    ++index_touches
  ) {
    if (
      self->metil->input.touch.touches[
        index_touches
      ].touch ==
      touch
    ) {
      index_touch = (
        index_touches
      );
    }
  }

  if (
    index_touch ==
    0xff
  ) {
    self->metil->input.touch.length_touches = (
      self->metil->input.touch.length_touches +
      0x01
    );

    if (
      self->metil->input.touch.length_touches >
      0x05
    ) {
      self->metil->input.touch.length_touches = (
        0x05
      );

      index_touch = (
        0x00
      );
    } else {
      index_touch = (
        self->metil->input.touch.length_touches -
        0x01
      );
    }
  }

  return (
    index_touch
  );
}

- (void) touchesMoved: (NSSet<UITouch*>*) touches withEvent: (UIEvent*) event {
  UITouch* touch = [
    touches
    anyObject
  ];

  NSArray<UITouch*>* touches_array = [
    touches
    allObjects
  ];

  unsigned char length_touches = (
    touches_array.count
  );

  self->metil->input.touch.length_touches = (
    length_touches
  );

  CGPoint position = [
    touch
    preciseLocationInView: self
  ];

  self->metil->input.touch.pressure = (
    touch.force
  );

  self->metil->input.touch.delta.x = (
    self->metil->input.touch.delta.x +
    (
      position.x -
      self->metil->input.touch.position.x
    )
  );

  self->metil->input.touch.delta.y = (
    self->metil->input.touch.delta.y +
    (
      position.y -
      self->metil->input.touch.position.y
    )
  );

  self->metil->input.touch.position.x = (
    position.x
  );

  self->metil->input.touch.position.y = (
    position.y
  );

  for (
    unsigned char index_touches_array = (
      0x00
    );
    (
      index_touches_array <
      length_touches
    );
    ++index_touches_array
  ) {
    touch = (
      touches_array[
        index_touches_array
      ]
    );

    unsigned char index_touch = [
      self
      touch_index_get: touch
    ];

    [
      self
      touch_update: touch
      index_touch: index_touch
    ];
  }
}

- (void) touchesEnded: (NSSet<UITouch*>*) touches withEvent: (UIEvent*) event {
  [
    self
    touchesCancelled: touches
    withEvent: event
  ];
}

- (void) touchesCancelled: (NSSet<UITouch*>*) touches withEvent: (UIEvent*) event {
  NSArray<UITouch*>* touches_array = [
    touches
    allObjects
  ];

  unsigned char length_touches = (
    touches_array.count
  );

  for (
    unsigned char index_touches_array = (
      0x00
    );
    (
      index_touches_array <
      length_touches
    );
    ++index_touches_array
  ) {
    UITouch* touch = (
      touches_array[
        index_touches_array
      ]
    );

    unsigned char index_touch = (
      0xff
    );

    for (
      unsigned char index_touches = (
        0x00
      );
      (
        index_touches <
        self->metil->input.touch.length_touches
      );
      ++index_touches
    ) {
      if (
        self->metil->input.touch.touches[
          index_touches
        ].touch ==
        touch
      ) {
        index_touch = (
          index_touches
        );

        break;
      }
    }

    if (
      index_touch ==
      0xff
    ) {
      self->metil->input.touch.length_touches = (
        self->metil->input.touch.length_touches +
        0x01
      );

      continue;
    }

    for (
      unsigned char index_touches = (
        index_touch
      );
      (
        index_touches <
        0x04
      );
      ++index_touches
    ) {
      clic3_bytes_copy(
        &self->metil->input.touch.touches[
          index_touches
        ],
        &self->metil->input.touch.touches[
          index_touches +
          0x01
        ],
        sizeof(
          struct metil_touch_item
        )
      );
    }

    self->metil->input.touch.touches[
      0x04
    ].touch = (
      0x00
    );

    self->metil->input.touch.touches[
      0x04
    ].touching = (
      0x00
    );       }

  self->metil->input.touch.length_touches = (
    self->metil->input.touch.length_touches -
    length_touches
  );

  self->metil->input.touch.touching = (
    self->metil->input.touch.length_touches > 0x00
    ? 0x01
    : 0x00
  );
}

#endif

@end
