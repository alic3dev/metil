#include <metil_debug/metil_debug_log.h>

#include <stdio.h>

void metil_debug_log(
  enum metil_debug_log_level metil_debug_log_level,
  char* buffer_output
) {
  if (
    metil_debug_log_level != metil_debug_log_level_all
  ) {
    return;
  }

  fprintf(
    stdout,
    "%s",
    buffer_output
  );
}

void metil_debug_log_error(
  enum metil_debug_log_level metil_debug_log_level,
  char* buffer_output
) {
  if (
    metil_debug_log_level == metil_debug_log_level_none
  ) {
    return;
  }

  fprintf(
    stderr,
    "%s",
    buffer_output
  );
}
