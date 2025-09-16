#include <metil_application/metil_application_delegate.h>

#include <metil_termination.h>

@implementation metil_application_delegate {}

- (void) applicationWillTerminate: (NSNotification*) notification {
  metil_termination_terminate();
}

@end
