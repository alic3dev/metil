#include <metil_application/metil_view.h>

#if target_os_ios
#include <UIKit/UIEvent.h>
#include <UIKit/UITouch.h>
#endif

@implementation metil_view {}

#if target_os_ios
- (void) touchesBegan: (NSSet<UITouch*>*) touches withEvent: (UIEvent*) event {
  self->metil->input.touch.index_touch = (
    self->metil->input.touch.index_touch +
    0x01
  );  

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
}

- (void) touchesMoved: (NSSet<UITouch*>*) touches withEvent: (UIEvent*) event {
  UITouch* touch = [
    touches
    anyObject
  ];

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
}

- (void) touchesEnded: (NSSet<UITouch*>*) touches withEvent: (UIEvent*) event {
  [
    self
    touchesCancelled: touches
    withEvent: event
  ];
}

- (void) touchesCancelled: (NSSet<UITouch*>*) touches withEvent: (UIEvent*) event {
  self->metil->input.touch.touching = (
    0x00
  );
}

#endif

@end
