#ifndef __metil_application_metil_application_delegate_h
#define __metil_application_metil_application_delegate_h

#include <metil.h>

#if target_os_ios
#import <UIKit/UIKit.h>

@interface metil_application_delegate: UIResponder <UIApplicationDelegate>
#else
#include <AppKit/AppKit.h>

@interface metil_application_delegate: NSObject<NSApplicationDelegate>
#endif

{
  @public struct metil* metil;
}

#if target_os_ios
@property (strong, nonatomic) UIWindow* window;
#endif

- (void) applicationWillTerminate: (NSNotification*) notification;

@end

#endif
