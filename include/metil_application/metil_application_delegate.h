#ifndef __metil_application_metil_application_delegate_h
#define __metil_application_metil_application_delegate_h

#if target_os_ios
#import <UIKit/UIKit.h>

@interface metil_application_delegate: UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow* window;

#else
#include <AppKit/AppKit.h>

@interface metil_application_delegate: NSObject<NSApplicationDelegate>

#endif

- (void) applicationWillTerminate: (NSNotification*) notification;

@end

#endif
