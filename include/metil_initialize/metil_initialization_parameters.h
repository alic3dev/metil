#ifndef __metil_initialize_metil_initialization_parameters_h
#define __metil_initialize_metil_initialization_parameters_h

struct metil_initialization_parameters {
  unsigned char disabled_audio;
};

void metil_initialization_parameters_initialize(
  struct metil_initialization_parameters*
);

void metil_initialization_parameters_clone(
  struct metil_initialization_parameters*,
  struct metil_initialization_parameters*
);

#endif
