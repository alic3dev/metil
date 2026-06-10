#include <metil_termination/metil_terminate_on_signal.h>

#include <metil.h>
#include <metil_termination/metil_termination.h>

#if !target_os_ios
#include <AppKit/AppKit.h>
#endif

void metil_terminate_on_signal(
  int signal,
  void* data
) {
  struct metil* metil = (
    data
  );

  #if target_os_ios
  metil_termination_terminate(
    &metil->termination
  );
  exit(
    0x00
  );
  #else
  [
    [
      NSApplication
      sharedApplication
    ]
    terminate: (
      0x00
    )
  ];
  #endif
}
