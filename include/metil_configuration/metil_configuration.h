#ifndef __metil_configuration_metil_configuration_h
#define __metil_configuration_metil_configuration_h

#include <metil_configuration/metil_configuration_audio.h>
#include <metil_configuration/metil_configuration_rendering_properties.h>

struct metil_configuration {
  struct metil_configuration_audio audio;
  struct metil_configuration_rendering_properties rendering_properties;
};

void metil_configuration_initialize(
  struct metil_configuration*
);

unsigned char metil_configuration_load(
  struct metil_configuration*
);

void metil_configuration_values_set(
  struct metil_configuration*
);

int metil_configuration_value_int_parse(
  char*,
  char*
);

float metil_configuration_value_float_parse(
  char*,
  char*
);

void metil_configuration_debug_log_parameter_invalid(
  char*,
  char*
);

void metil_configuration_destroy(
  struct metil_configuration*
);

#endif
