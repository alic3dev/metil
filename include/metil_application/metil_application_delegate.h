#ifndef __metil_application_metil_application_delegate_h
#define __metil_application_metil_application_delegate_h

#if target_device == 1
#include <UIKit/UIKit.h>

@interface metil_application_delegate: NSObject<UIApplicationDelegate>

- (void) applicationWillTerminate: (NSNotification*) notification;

@end
#else
#include <AppKit/AppKit.h>

@interface metil_application_delegate: NSObject<NSApplicationDelegate>

- (void) applicationWillTerminate: (NSNotification*) notification;

@end
#endif

#endif
