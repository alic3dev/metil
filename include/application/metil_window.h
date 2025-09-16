#ifndef __application_metil_application_h
#define __application_metil_application_h

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
