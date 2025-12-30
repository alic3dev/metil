#include <metil_utilities/stopwatch.h>
#include <metil_utilities/time.h>

#include <sys/time.h>

void metil_stopwatch_start(
  struct metil_stopwatch* stopwatch
) {
  gettimeofday(
    &stopwatch->timeval,
    (void*)0
  );
}

unsigned long int metil_stopwatch_elapsed(
  struct metil_stopwatch* stopwatch
) {
  return metil_time_milliseconds_get() - (
    metil_time_seconds_to_milliseconds(stopwatch->timeval.tv_sec) +
    metil_time_microseconds_to_milliseconds(stopwatch->timeval.tv_usec)
  );
}
