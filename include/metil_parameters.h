#ifndef __metil_metil_parameters_h
#define __metil_metil_parameters_h

struct metil_parameters {
  int length_parameters;
  const char** parameters;

  int length_parameters_proxied;
  const char** parameters_proxied;
};

void metil_parameters_initialize(
  struct metil_parameters*,
  int,
  const char**
);

void metil_parameters_destroy(
  struct metil_parameters*
);

#endif
