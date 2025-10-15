#include <metil_initialize.h>

#include <metil_application/metil_application.h>
#include <metil_application/metil_application_delegate.h>
#include <metil_audio/audio.h>
#include <metil_configuration/configuration.h>
#include <metil_input/input.h>
#include <metil_library.h>
#include <metil_paths/paths.h>
#include <metil_rendering/metil_renderer.h>
#include <metil_scenes/scene_controller.h>
#include <metil_system_information.h>
#include <metil_termination.h>
#include <metil_text/text.h>
#include <metil_utilities/time.h>

#include <interrupt_handler.h>

#include <limits.h>

#include <AppKit/AppKit.h>

void metil_terminate_on_signal(int _) {
  [[NSApplication sharedApplication] terminate: 0];
}

int metil_initialize(
  int length_parameters,
  const char** parameters,
  char* name,
  metil_renderer_on_initialize_function metil_renderer_on_initialize_function
) {
  return metil_initialize_with_data(
    length_parameters,
    parameters,
    name,
    metil_renderer_on_initialize_function,
    (void*)0
  );
}

int metil_initialize_with_data(
  int length_parameters,
  const char** parameters,
  char* name,
  metil_renderer_on_initialize_function metil_renderer_on_initialize_function,
  void* metil_renderer_on_initialize_function_data
) {
  metil_system_information_initialize();

  srand(metil_time_milliseconds_get() % UINT_MAX);

  metil_renderer_on_initialize = metil_renderer_on_initialize_function;
  metil_renderer_on_initialize_data = metil_renderer_on_initialize_function_data;

  metil_paths_initialize(
    (char*) parameters[0],
    name
  );

  unsigned char status_configuration_load = (
    metil_configuration_load()
  );

  if (
    status_configuration_load != 0
  ) {
    metil_paths_destroy();
    [[NSApplication sharedApplication] terminate: 0];
    return status_configuration_load;
  }

  metil_termination_initialize();
  interrupt_handler_initialize();
  metil_input_initialize();
  metil_scene_controller_initialize();
  metil_audio_initialize();
  metil_text_initialize();

  metil_configuration_values_set();

  metil_termination_on_function_add(
    metil_scene_controller_destroy,
    (void*)0
  );

  metil_termination_on_function_add(
    interrupt_handler_destroy,
    (void*)0
  );

  metil_termination_on_function_add(
    metil_paths_destroy,
    (void*)0
  );

  metil_termination_on_function_add(
    metil_audio_destroy,
    (void*)0
  );

  metil_termination_on_function_add(
    metil_text_destroy,
    (void*)0
  );

  metil_termination_on_function_add(
    metil_configuration_destroy,
    (void*)0
  );

  metil_application* application = [metil_application sharedApplication];
  application.delegate = [metil_application_delegate alloc];

  interrupt_handler_interrupt_function_add(
    metil_terminate_on_signal
  );

  return NSApplicationMain(
    length_parameters,
    parameters
  );
}
