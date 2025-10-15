#ifndef __metil_system_information_h
#define __metil_system_information_h

struct metil_system_information {
  unsigned int cores_cpu;
};

extern struct metil_system_information metil_system_information;

void metil_system_information_initialize();

#endif
