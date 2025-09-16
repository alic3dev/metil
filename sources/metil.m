#include <metil.h>

#include <application/metil_application.h>
#include <application/metil_application_delegate.h>
#include <audio/audio.h>
#include <configuration/configuration.h>
#include <input/input.h>
#include <paths/paths.h>
#include <scenes/scene_controller.h>
#include <termination.h>
#include <text/text.h>
#include <utilities/time.h>

#include <interrupt_handler.h>

#include <limits.h>

#include <AppKit/AppKit.h>

void terminate_on_signal(int _) {
  [[NSApplication sharedApplication] terminate: 0];
}

int metil_initialize(
  int length_parameters,
  const char** parameters,
  char* name
) {
  srand(time_milliseconds_get() % UINT_MAX);
  
  paths_initialize(
    (char*) parameters[0],
    name
  );

  unsigned char status_configuration_load = (
    configuration_load()
  );

  if (
    status_configuration_load != 0
  ) {
    paths_destroy();
    [[NSApplication sharedApplication] terminate: 0];
    return status_configuration_load;
  }

  termination_initialize();
  interrupt_handler_initialize();
  input_initialize();
  scene_controller_initialize();
  audio_initialize();
  text_initialize();

  configuration_values_set();

  termination_on_function_add(
    scene_controller_destroy,
    (void*)0
  );
  
  termination_on_function_add(
    interrupt_handler_destroy,
    (void*)0
  );

  termination_on_function_add(
    paths_destroy,
    (void*)0
  );

  termination_on_function_add(
    audio_destroy,
    (void*)0
  );

  termination_on_function_add(
    text_destroy,
    (void*)0
  );

  termination_on_function_add(
    configuration_destroy,
    (void*)0
  );

  metil_application* application = [metil_application sharedApplication];
  application.delegate = [metil_application_delegate alloc];

  interrupt_handler_interrupt_function_add(
    terminate_on_signal
  );
  
  return NSApplicationMain(
    length_parameters,
    parameters
  );
}
