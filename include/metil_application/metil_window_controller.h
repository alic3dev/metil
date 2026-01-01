#ifndef __metil_application_metil_window_controller_h
#define __metil_application_metil_window_controller_h

#if !target_os_ios

#include <AppKit/AppKit.h>

@interface metil_window_controller: NSWindowController {}

- (void) windowDidLoad;

@end

#endif
#endif
