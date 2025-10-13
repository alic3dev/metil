#include <metil_termination.h>

#include <stdlib.h>

metil_termination_on_function* metil_termination_on_functions = (void*)0;
void** metil_termination_on_functions_data = (void*)0;
unsigned short int metil_termination_length_on_functions = 0;

void metil_termination_initialize() {
  metil_termination_on_functions = malloc(
    sizeof(metil_termination_on_function) *
    metil_termination_length_on_functions
  );

  metil_termination_on_functions_data = malloc(
    sizeof(metil_termination_on_function) *
    metil_termination_length_on_functions
  );
}

void metil_termination_on_function_add(
  metil_termination_on_function on,
  void* data
) {
  metil_termination_length_on_functions = (
    metil_termination_length_on_functions + 1
  );

  metil_termination_on_functions = realloc(
    metil_termination_on_functions,
    sizeof(metil_termination_on_function) *
    metil_termination_length_on_functions
  );

  metil_termination_on_functions[
    metil_termination_length_on_functions - 1
  ] = on;

  metil_termination_on_functions_data = realloc(
    metil_termination_on_functions_data,
    sizeof(void*) *
    metil_termination_length_on_functions
  );

  metil_termination_on_functions_data[
    metil_termination_length_on_functions - 1
  ] = data;
}

void metil_termination_on_function_remove(
  metil_termination_on_function on
) {
  for (
    signed int index_termination_on = 0;
    index_termination_on < metil_termination_length_on_functions;
    ++index_termination_on
  ) {
    if (
      on == metil_termination_on_functions[index_termination_on]
    ) {
      metil_termination_length_on_functions = (
        metil_termination_length_on_functions - 1
      );

      for (
        unsigned short int index_termination_on_offset = index_termination_on;
        index_termination_on_offset < metil_termination_length_on_functions;
        ++index_termination_on_offset
      ) {
        metil_termination_on_functions[
          index_termination_on_offset
        ] = metil_termination_on_functions[
          index_termination_on_offset + 1
        ];

        metil_termination_on_functions_data[
          index_termination_on_offset
        ] = metil_termination_on_functions_data[
          index_termination_on_offset + 1
        ];
      }

      metil_termination_on_functions = realloc(
        metil_termination_on_functions,
        sizeof(metil_termination_on_function) *
        metil_termination_length_on_functions
      );

      metil_termination_on_functions_data = realloc(
        metil_termination_on_functions_data,
        sizeof(void*) *
        metil_termination_length_on_functions
      );

      index_termination_on = (
        index_termination_on - 1
      );
    }
  }
}

void metil_termination_terminate() {
  for (
    unsigned short int index_termination_on = 0;
    index_termination_on < metil_termination_length_on_functions;
    ++index_termination_on
  ) {
    metil_termination_on_functions[index_termination_on](
      metil_termination_on_functions_data[index_termination_on]
    );
  }

  free(metil_termination_on_functions);
}
