#ifndef __metil_metil_parameters_h
#define __metil_metil_parameters_h

struct metil_parameters {
  int length_parameters;
  #if target_os_ios
  char** parameters;
  #else
  const char** parameters;
  #endif

  int length_parameters_proxied;
  #if target_os_ios
  char** parameters_proxied;
  #else
  const char** parameters_proxied;
  #endif
};

void metil_parameters_initialize(
  struct metil_parameters*,
  int,
  #if target_os_ios
  char** parameters
  #else
  const char** parameters
  #endif
);

void metil_parameters_destroy(
  struct metil_parameters*
);

#endif
