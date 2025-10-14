#ifndef __metil_initialize_h
#define __metil_initialize_h

#include <metil_rendering/metil_renderer.h>

void metil_terminate_on_signal(int);

int metil_initialize(
  int,
  const char**,
  char*,
  metil_renderer_on_initialize_function
);

int metil_initialize_with_data(
  int,
  const char**,
  char*,
  metil_renderer_on_initialize_function,
  void*
);

#endif
