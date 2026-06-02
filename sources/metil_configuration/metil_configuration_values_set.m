#include <metil_configuration/metil_configuration_values_set.h>

void metil_configuration_values_set(
  struct metil* metil,
  struct metil_configuration* metil_configuration
) {
  metil->audio.volume = (
    metil_configuration->audio.volume
  );
}
