#include <metil_configuration/metil_configuration_application.h>

void metil_configuration_application_initialize(
  struct metil_configuration_application* metil_configuration_application
) {
  metil_configuration_application->clear_input_on_deactivation = (
    0x01
  );
}
