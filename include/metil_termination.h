#ifndef __termination_h
#define __termination_h

typedef void(*metil_termination_on_function)(void*);

extern metil_termination_on_function* metil_termination_on_functions;
extern void** metil_termination_on_functions_data;
extern unsigned short int metil_termination_length_on_functions;

void metil_termination_initialize();

void metil_termination_on_function_add(
  metil_termination_on_function,
  void*
);

void metil_termination_on_function_remove(
  metil_termination_on_function
);

void metil_termination_terminate();

#endif
