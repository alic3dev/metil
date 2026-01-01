#ifndef __metil_application_metil_window_h
#define __metil_application_metil_window_h

#if !target_os_ios

#include <metil.h>

#include <AppKit/AppKit.h>

@interface metil_window: NSWindow {
  unsigned char moved_after_lock;
  struct metil* _Nonnull metil;
}

- (char) acceptsMouseMovedEvents;
- (char) canBecomeKeyWindow;
- (void) center_mouse;
- (void) flagsChanged: (NSEvent* _Nonnull) event;
- (void) keyDown: (NSEvent* _Nonnull) event;
- (void) keyUp: (NSEvent* _Nonnull) event;
- (void) mouseDown: (NSEvent* _Nonnull) event;
- (void) mouseDragged: (NSEvent* _Nonnull) event;
- (void) mouseMoved: (NSEvent* _Nonnull) event;
- (void) mouseUp: (NSEvent* _Nonnull) event;
- (void) process_mouse_movement_event: (NSEvent* _Nonnull) event;

- (void) metil_set: (struct metil* _Nonnull) metil;

@end

#endif
#endif
