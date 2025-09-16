#ifndef __metil_configuration_configuration_h
#define __metil_configuration_configuration_h

#include <metil_configuration/configuration_audio.h>
#include <metil_configuration/configuration_rendering_properties.h>

struct metil_configuration {
  struct metil_configuration_audio audio;
  struct metil_configuration_rendering_properties rendering_properties;
};

extern struct metil_configuration configuration;

void metil_configuration_initialize();

unsigned char metil_configuration_load();

void metil_configuration_values_set();

float metil_configuration_value_float_parse(
  char*,
  char*,
  unsigned short int
);

void metil_configuration_destroy();

#endif
