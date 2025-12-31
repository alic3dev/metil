#ifndef __metil_debug_metil_debug_log_h
#define __metil_debug_metil_debug_log_h

#include <metil_debug/metil_debug_log_level.h>

void metil_debug_log(
  enum metil_debug_log_level,
  char*
);

void metil_debug_log_error(
  enum metil_debug_log_level,
  char*
);

#endif
