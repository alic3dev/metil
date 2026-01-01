#ifndef __metil_initialize_h
#define __metil_initialize_h

#include <metil_rendering/metil_renderer.h>

int metil_initialize(
  int,
  #if target_os_ios
  char**,
  #else
  const char**,
  #endif
  char*,
  metil_renderer_on_initialize_function
);

int metil_initialize_with_data(
  int,
  #if target_os_ios
  char**,
  #else
  const char**,
  #endif
  char*,
  metil_renderer_on_initialize_function,
  void*
);

#endif
