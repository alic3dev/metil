#include <metil_application/metil_application.h>

@implementation metil_application {}

#if target_os_ios
- (char) isIdleTimerDisabled {
  return (
    0x01
  );
}
#endif

@end
