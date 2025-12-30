#include <metil_debug/metil_log.h>

#include <stdio.h>

enum metil_debug_log_level metil_debug_log_level = (
  metil_debug_log_level_error
);

void metil_debug_log(
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
