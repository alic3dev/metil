#include <metil_application/metil_application_delegate.h>

#include <metil_termination/metil_termination.h>

@implementation metil_application_delegate {}

- (void) applicationWillTerminate: (NSNotification*) notification {
  metil_termination_terminate(
    &self->metil->termination
  );
}

- (void) applicationDidResignActive: (NSNotification*) notification {
  if (
    self->metil->configuration.application.clear_input_on_deactivation !=
    0x00
  ) {
    metil_input_keydown_map_initialize(
      self->metil->input.keydown_map
    );
  }
}

@end
