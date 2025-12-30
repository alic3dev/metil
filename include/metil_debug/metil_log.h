#ifndef __metil_debug_log_h
#define __metil_debug_log_h

enum metil_debug_log_level {
  metil_debug_log_level_none,
  metil_debug_log_level_error,
  metil_debug_log_level_all
};

extern enum metil_debug_log_level metil_debug_log_level;

void metil_debug_log(
  char*
);

void metil_debug_log_error(
  char*
);

#endif
