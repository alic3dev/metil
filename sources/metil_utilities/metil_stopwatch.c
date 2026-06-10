#include <metil_utilities/metil_stopwatch.h>
#include <metil_utilities/metil_time.h>

#include <sys/time.h>

void metil_stopwatch_start(
  struct metil_stopwatch* metil_stopwatch
) {
  gettimeofday(
    &metil_stopwatch->timeval,
    0x00
  );
}

unsigned long int metil_stopwatch_elapsed(
  struct metil_stopwatch* metil_stopwatch
) {
  return (
    metil_time_milliseconds_get() -
    (
      metil_time_seconds_to_milliseconds(
        metil_stopwatch->timeval.tv_sec
      ) +
      metil_time_microseconds_to_milliseconds(
        metil_stopwatch->timeval.tv_usec
      )
    )
  );
}
