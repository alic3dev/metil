#ifndef __metil_metil_configuration_metil_configuration_application_h
#define __metil_metil_configuration_metil_configuration_application_h

struct metil_configuration_application {
  unsigned char clear_input_on_deactivation;
};

void metil_configuration_application_initialize(
  struct metil_configuration_application*
);

#endif
