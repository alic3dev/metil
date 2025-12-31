#ifndef __metil_system_information_h
#define __metil_system_information_h

struct metil_system_information {
  unsigned int cores_cpu;
};

void metil_system_information_initialize(
  struct metil_system_information*
);

#endif
