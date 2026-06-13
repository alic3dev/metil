#ifndef __metil_configuration_metil_configuration_h
#define __metil_configuration_metil_configuration_h

#include <metil_configuration/metil_configuration_application.h>
#include <metil_configuration/metil_configuration_audio.h>
#include <metil_configuration/metil_configuration_rendering_properties.h>
#include <metil_debug/metil_debug_log_level.h>
#include <metil_paths/metil_paths.h>

struct metil_configuration {
  struct metil_configuration_application application;
  struct metil_configuration_audio audio;
  struct metil_configuration_rendering_properties rendering_properties;
  enum metil_debug_log_level debug_log_level;
};

void metil_configuration_initialize(
  struct metil_configuration* _Nonnull
);

unsigned char metil_configuration_load(
  struct metil_configuration* _Nonnull,
  struct metil_paths* _Nonnull
);

int metil_configuration_value_int_parse(
  struct metil_configuration* _Nonnull,
  char* _Nonnull,
  char* _Nonnull
);

float metil_configuration_value_float_parse(
  struct metil_configuration* _Nonnull,
  char* _Nonnull,
  char* _Nonnull
);

void metil_configuration_debug_log_parameter_invalid(
  struct metil_configuration* _Nonnull,
  char* _Nonnull,
  char* _Nonnull
);

void metil_configuration_destroy(
  struct metil_configuration* _Nonnull
);

#endif
