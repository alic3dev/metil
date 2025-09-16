#include <application/metil_application_delegate.h>

#include <termination.h>

@implementation metil_application_delegate {}

- (void) applicationWillTerminate: (NSNotification*) notification {
  termination_terminate();
}

@end
