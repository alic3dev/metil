#ifndef __metil_system_information_h
#define __metil_system_information_h

#include <metil_configuration/metil_configuration.h>

struct metil_system_information {
  unsigned int cores_cpu;
};

void metil_system_information_initialize(
  struct metil_system_information*,
  struct metil_configuration*
);

#endif
