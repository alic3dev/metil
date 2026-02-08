#include <metil_parameters.h>

#include <clic3_bytes.h>
#include <clic3_char_arrays.h>
#include <clic3_memory.h>

void metil_parameters_initialize(
  struct metil_parameters* metil_parameters,
  int length_parameters,
  #if target_os_ios
  char** parameters
  #else
  const char** parameters
  #endif
) {
  metil_parameters->length_parameters = (
    length_parameters
  );

  metil_parameters->parameters = (
    parameters
  );


  metil_parameters->length_parameters_proxied = (
    1
  );

  metil_parameters->parameters_proxied = (
    clic3_memory_allocate_raw(
      sizeof(
        void*
      ) *
      metil_parameters->length_parameters_proxied
    )
  );

  unsigned int length_parameter_entry_point = (
    clic3_char_array_length(
      (char*) metil_parameters->parameters[
        0
      ]
    ) +
    1
  );

  metil_parameters->parameters_proxied[
    0
  ] = (
    clic3_memory_allocate_raw(
      length_parameter_entry_point
    )
  );

  clic3_bytes_copy(
    (
      (void*)
      metil_parameters->parameters_proxied[
        0
      ]
    ),
    (
      (void*)
      metil_parameters->parameters[
        0
      ]
    ),
    length_parameter_entry_point
  );
}

void metil_parameters_destroy(
  struct metil_parameters* metil_parameters
) {
  for (
    unsigned int index_parameter_proxied = 0;
    index_parameter_proxied < metil_parameters->length_parameters_proxied;
    ++index_parameter_proxied
  ) {
    clic3_memory_free_raw(
      (void*)
      metil_parameters->parameters_proxied[
        index_parameter_proxied
      ]
    );
  }

  clic3_memory_free_raw(
    metil_parameters->parameters_proxied
  );
}
