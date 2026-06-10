#include <metil_utilities/metil_time.h>

#include <sys/time.h>

unsigned long int metil_time_milliseconds_get() {
  struct timeval timeval;

  gettimeofday(
    &timeval,
    0x00
  );

  return (
    metil_time_seconds_to_milliseconds(
      timeval.tv_sec
    ) +
    metil_time_microseconds_to_milliseconds(
      timeval.tv_usec
    )
  );
}
