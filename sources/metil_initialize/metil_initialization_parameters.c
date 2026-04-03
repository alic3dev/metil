#include <metil_initialize/metil_initialization_parameters.h>

#include <clic3_bytes.h>

void metil_initialization_parameters_initialize(
  struct metil_initialization_parameters* metil_initialization_parameters
) {
  metil_initialization_parameters->disabled_audio = (
    0x00
  );
}

void metil_initialization_parameters_clone(
  struct metil_initialization_parameters* metil_initialization_parameters_target,
  struct metil_initialization_parameters* metil_initialization_parameters_source
) {
  clic3_bytes_copy(
    metil_initialization_parameters_target,
    metil_initialization_parameters_source,
    sizeof(
      struct metil_initialization_parameters
    )
  );
}
