#ifndef __metil_configuration_metil_configuration_h
#define __metil_configuration_metil_configuration_h

#include <metil_configuration/metil_configuration_audio.h>
#include <metil_configuration/metil_configuration_rendering_properties.h>

struct metil_configuration {
  struct metil_configuration_audio audio;
  struct metil_configuration_rendering_properties rendering_properties;
};

extern struct metil_configuration metil_configuration;

void metil_configuration_initialize();

unsigned char metil_configuration_load();

void metil_configuration_values_set();

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

void metil_configuration_destroy();

#endif
