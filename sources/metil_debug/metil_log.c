#include <metil_debug/metil_debug_log.h>

#include <stdarg.h>
#include <stdio.h>

void metil_debug_log(
  unsigned char metil_debug_log_level,
  char* buffer_output
) {
  switch (
    metil_debug_log_level
  ) {
    case metil_debug_log_level_all:
    case metil_debug_log_level_info: {
      break;    }
    default: {
      return;
    }
  }

  metil_debug_log_print(
    stdout,
    buffer_output
  );
}

void metil_debug_log_parameters(
  unsigned char metil_debug_log_level,
  char* format,
  unsigned int length_parameters,
  ...
) {
  switch (
    metil_debug_log_level
  ) {
    case metil_debug_log_level_all:
    case metil_debug_log_level_info:
{      break;
    }
    default: {
      return;
    }
  }

  va_list parameters;

  va_start(
    parameters,
    length_parameters
  );

  metil_debug_log_print_parameters(
    stdout,
    format,
    parameters
  );

  va_end(
    parameters
  );
}

void metil_debug_log_error(
  unsigned char metil_debug_log_level,
  char* buffer_output
) {
  switch (
    metil_debug_log_level
  ) {
    case metil_debug_log_level_all:
    case metil_debug_log_level_info: {
      break;
    }
    default: {
      return;
    }
  }

  metil_debug_log_print(
    stdout,
    buffer_output
  );
}

void metil_debug_log_parameters_error(
  unsigned char metil_debug_log_level,
  char* format,
  unsigned int length_parameters,
  ...
) {
  if (
    metil_debug_log_level ==
    metil_debug_log_level_none
  ) {
    return;
  }

  va_list parameters;

  va_start(
    parameters,
    length_parameters
  );

  metil_debug_log_print_parameters(
    stderr,
    format,
    parameters
  );

  va_end(
    parameters
  );
}

void metil_debug_log_print(
  FILE* stream_output,
  char* buffer_output
) {
  fprintf(
    stream_output,
    "%s",
    buffer_output
  );
}

void metil_debug_log_print_parameters(
  FILE* stream_output,
  char* format,
  va_list parameters
) {
 vfprintf(
   stream_output,
   format,
   parameters
 );
}
