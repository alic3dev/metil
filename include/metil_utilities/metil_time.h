#ifndef __metil_utilities_metil_time_h
#define __metil_utilities_metil_time_h

#define metil_time_microseconds_to_milliseconds(x) ((x) / 1000)
#define metil_time_microseconds_to_seconds(x) ((x) / 1000000)
#define metil_time_microseconds_to_minutes(x) ((x) / 60000000)

#define metil_time_milliseconds_to_microseconds(x) ((x) * 1000)
#define metil_time_milliseconds_to_seconds(x) ((x) / 1000)
#define metil_time_milliseconds_to_minutes(x) ((x) / 60000)

#define metil_time_seconds_to_microseconds(x) ((x) * 1000000)
#define metil_time_seconds_to_milliseconds(x) ((x) * 1000)
#define metil_time_seconds_to_minutes(x) ((x) / 60)

unsigned long int metil_time_milliseconds_get();

#endif
