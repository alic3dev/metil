#ifndef __metil_application_metil_window_h
#define __metil_application_metil_window_h

#include <AppKit/AppKit.h>

@interface metil_window: NSWindow {
  unsigned char locked_cursor;
  unsigned char moved_after_lock;
}

- (void) keyDown:(NSEvent*) event;
- (void) keyUp:(NSEvent*) event;
- (void) mouseDown:(NSEvent *) event;
- (void) mouseMoved: (NSEvent*) event;
- (void) flagsChanged:(NSEvent*) event;

- (void) center_mouse;

- (BOOL) canBecomeKeyWindow;

@end

#endif
