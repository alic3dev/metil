#ifndef __metil_debug_metil_debug_log_h
#define __metil_debug_metil_debug_log_h

#include <metil_debug/metil_debug_log_level.h>

#include <stdarg.h>
#include <stdio.h>

void metil_debug_log(
  unsigned char,
  char*
);

void metil_debug_log_parameters(
  unsigned char,
  char*,
  unsigned int,
  ...
);

void metil_debug_log_error(
  unsigned char,
  char*
);

void metil_debug_log_parameters_error(
  unsigned char,
  char*,
  unsigned int,
  ...
);

void metil_debug_log_print(
  FILE*,
  char*
);

void metil_debug_log_print_parameters(
  FILE*,
  char*,
  va_list
);

#endif
