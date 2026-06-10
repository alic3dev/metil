#include <metil_application/metil_window_controller.h>

#include <metil_application/metil_application.h>
#include <metil_application/metil_application_mapping.h>
#include <metil_application/metil_window.h>

#if !target_os_ios

#include <AppKit/AppKit.h>

@implementation metil_window_controller {}

- (void) windowDidLoad {
  metil_window* _window = (
    (metil_window*)
    self.window
  );

  metil_application* metil_application_shared = (
    (metil_application*)
    [
      metil_application
      sharedApplication
    ]
  );

  [
    _window
    metil_set: (
      metil_application_shared->metil
    )
  ];
  
  struct metil_application_mapping* metil_application_mapping = (
    metil_application_shared->metil->application_mapping
  );
  
  metil_application_mapping->window = (
    _window
  );
  
  metil_application_mapping->window_controller = (
    self
  );
}

@end

#endif
