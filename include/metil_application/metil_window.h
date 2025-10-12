#ifndef __metil_application_metil_window_h
#define __metil_application_metil_window_h

#include <AppKit/AppKit.h>

@interface metil_window: NSWindow {
  unsigned char moved_after_lock;
}

- (char) acceptsMouseMovedEvents;
- (char) canBecomeKeyWindow;
- (void) center_mouse;
- (void) flagsChanged: (NSEvent*) event;
- (void) keyDown: (NSEvent*) event;
- (void) keyUp: (NSEvent*) event;
- (void) mouseDown: (NSEvent*) event;
- (void) mouseDragged: (NSEvent*) event;
- (void) mouseMoved: (NSEvent*) event;
- (void) mouseUp: (NSEvent*) event;

@end

#endif
