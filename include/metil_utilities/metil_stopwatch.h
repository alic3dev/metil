#ifndef __metil_utilities_stopwatch_h
#define __metil_utilities_stopwatch_h

#include <sys/time.h>

struct metil_stopwatch {
  struct timeval timeval;
};

void metil_stopwatch_start(
  struct metil_stopwatch*
);

unsigned long int metil_stopwatch_elapsed(
  struct metil_stopwatch*
);

#endif
