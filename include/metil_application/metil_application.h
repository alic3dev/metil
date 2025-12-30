#ifndef __metil_application_metil_application_h
#define __metil_application_metil_application_h

#include <metil.h>

#if target_os_ios
#include <UIKit/UIKit.h>

@interface metil_application: UIApplication
#else
#include <AppKit/AppKit.h>

@interface metil_application: NSApplication
#endif

{
  @public struct metil* metil;
}

@end

#endif
