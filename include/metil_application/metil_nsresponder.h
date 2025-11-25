#ifndef __metil_application_metil_nsresponder_h
#define __metil_application_metil_nsresponder_h

#if target_device == 1
#include <UIKit/UIKit.h>

@interface metil_nsresponder: UIResponder
@end
#else
#include <AppKit/AppKit.h>

@interface metil_nsresponder: NSResponder
@end
#endif

#endif
