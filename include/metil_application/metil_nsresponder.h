#ifndef __metil_application_metil_nsresponder_h
#define __metil_application_metil_nsresponder_h

#if target_os_ios
#include <UIKit/UIKit.h>

@interface metil_nsresponder: UIResponder
@end
#else
#include <AppKit/AppKit.h>

@interface metil_nsresponder: NSResponder
@end
#endif

#endif
