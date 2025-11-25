#ifndef __metil_application_metil_application_delegate_h
#define __metil_application_metil_application_delegate_h

#if target_device == 1
#include <UIKit/UIKit.h>

@interface metil_application_delegate: NSObject<UIApplicationDelegate>

#else
#include <AppKit/AppKit.h>

@interface metil_application_delegate: NSObject<NSApplicationDelegate>

#endif

- (void) applicationWillTerminate: (NSNotification*) notification;

@end

#endif
