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

#if target_os_ios
#include <UIKit/UIKit.h>
#else
#include <AppKit/AppKit.h>
#endif

void metil_terminate_on_signal(int _) {
  #if target_os_ios
  [[UIApplication sharedApplication] terminate: 0];
  #else
  [[NSApplication sharedApplication] terminate: 0];
  #endif
}

int metil_initialize(
  int length_parameters,
  #if target_os_ios
  char** parameters,
  #else
  const char** parameters,
  #endif
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
  #if target_os_ios
  char** parameters,
  #else
  const char** parameters,
  #endif
  char* name,
  metil_renderer_on_initialize_function metil_renderer_on_initialize_function,
  void* metil_renderer_on_initialize_function_data
) {
  metil_system_information_initialize();

  metil_renderer_on_initialize = metil_renderer_on_initialize_function;
  metil_renderer_on_initialize_data = metil_renderer_on_initialize_function_data;

  metil_paths_initialize(
    (char*) parameters[0],
    name
  );

  #if target_os_ios
  metil_configuration_initialize();
  #else
  unsigned char status_configuration_load = (
    metil_configuration_load()
  );

  if (
    status_configuration_load != 0
  ) {
    metil_paths_destroy();
    #if target_os_ios
    [[UIApplication sharedApplication] terminate: 0];
    #else
    [[NSApplication sharedApplication] terminate: 0];
    #endif
    return status_configuration_load;
  }
  #endif

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

  #if !target_os_ios
  metil_termination_on_function_add(
    metil_audio_destroy,
    (void*)0
  );
  #endif

  metil_termination_on_function_add(
    metil_text_destroy,
    (void*)0
  );

  metil_termination_on_function_add(
    metil_configuration_destroy,
    (void*)0
  );

  interrupt_handler_interrupt_function_add(
    metil_terminate_on_signal
  );

  #if target_os_ios
  return 0;
  #else
  metil_application* application = [metil_application sharedApplication];
  application.delegate = [metil_application_delegate alloc];

  return NSApplicationMain(
    length_parameters,
    parameters
  );
  #endif
}
