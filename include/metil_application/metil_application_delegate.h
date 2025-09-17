#ifndef __metil_application_metil_application_delegate_h
#define __metil_application_metil_application_delegate_h

#include <AppKit/AppKit.h>

@interface metil_application_delegate: NSObject<NSApplicationDelegate>

- (void) applicationWillTerminate:(NSNotification*) notification;

@end

#endif
