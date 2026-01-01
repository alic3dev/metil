#include <metil_initialize.h>

#include <metil.h>
#include <metil_application/metil_application.h>
#include <metil_application/metil_application_delegate.h>
#include <metil_audio/metil_audio.h>
#include <metil_configuration/metil_configuration.h>
#include <metil_configuration/metil_configuration_values_set.h>
#include <metil_input/metil_input.h>
#include <metil_library.h>
#include <metil_paths/metil_paths.h>
#include <metil_rendering/metil_renderer.h>
#include <metil_scenes/metil_scene_controller.h>
#include <metil_system_information.h>
#include <metil_termination/metil_termination.h>
#include <metil_termination/metil_terminate_on_signal.h>
#include <metil_text/metil_text.h>
#include <metil_utilities/metil_time.h>

#include <interrupt_handler.h>

#if target_os_ios
#include <UIKit/UIKit.h>
#else
#include <AppKit/AppKit.h>
#endif

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
  static struct metil metil;

  metil_structure_initialize(
    &metil
  );

  metil.renderer_interface.rendering_properties = &(
    metil.rendering_properties
  );

  metil_renderer_on_initialize = metil_renderer_on_initialize_function;
  metil_renderer_on_initialize_data = metil_renderer_on_initialize_function_data;

  metil_paths_initialize(
    (char*) parameters[0],
    name
  );

  #if target_os_ios
  metil_configuration_initialize(
    &metil.configuration
  );
  #else
  unsigned char status_configuration_load = (
    metil_configuration_load(
      &metil.configuration
    )
  );

  if (
    status_configuration_load != 0
  ) {
    metil_paths_destroy();
    #if target_os_ios
    exit(
      status_configuration_load
    );
    #else
    [[NSApplication sharedApplication] terminate: 0];
    #endif
    return status_configuration_load;
  }
  #endif

  metil_system_information_initialize(
    &metil.system_information,
    &metil.configuration
  );

  metil_termination_initialize(
    &metil.termination
  );

  interrupt_handler_initialize();
  
  metil_input_initialize();
  
  metil_scene_controller_initialize(
    &metil
  );

  metil_audio_initialize(
    &metil,
    &metil.audio
  );

  metil_text_initialize(
    &metil.configuration
  );

  metil_configuration_values_set(
    &metil,
    &metil.configuration
  );

  metil_rendering_properties_initialize(
    &metil.rendering_properties,
    &metil.configuration.rendering_properties
  );

  metil_termination_on_function_add(
    &metil.termination,
    metil_destroy,
    &metil
  );

  interrupt_handler_interrupt_function_add_with_data(
    metil_terminate_on_signal,
    &metil
  );

  metil_application* application = (metil_application*) [metil_application sharedApplication];

  application->metil = &metil;

  #if !target_os_ios
  application.delegate = [metil_application_delegate alloc];
  #endif

  metil_application_delegate* _metil_application_delegate = (metil_application_delegate*) application.delegate;

  _metil_application_delegate->metil = &metil;

  #if target_os_ios
  return 0;
  #else
  return NSApplicationMain(
    length_parameters,
    parameters
  );
  #endif
}
