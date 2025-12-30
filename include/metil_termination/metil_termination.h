#ifndef __metil_termination_metil_termination_h
#define __metil_termination_metil_termination_h

typedef void(*metil_termination_on_function)(void*);

struct metil_termination {
  metil_termination_on_function* on_functions;
  void** on_functions_data;
  unsigned short int length_on_functions;
};

void metil_termination_initialize(
  struct metil_termination*
);

void metil_termination_on_function_add(
  struct metil_termination*,
  metil_termination_on_function,
  void*
);

void metil_termination_on_function_remove(
  struct metil_termination*,
  metil_termination_on_function
);

void metil_termination_terminate(
  struct metil_termination*
);

#endif
