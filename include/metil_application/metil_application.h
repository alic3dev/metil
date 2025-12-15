#ifndef __metil_application_metil_application_h
#define __metil_application_metil_application_h

#if target_os_ios
#include <UIKit/UIKit.h>

@interface metil_application: UIApplication
@end
#else
#include <AppKit/AppKit.h>

@interface metil_application: NSApplication
@end
#endif

#endif
