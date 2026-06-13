#include <metil_configuration/metil_configuration_audio.h>

void metil_configuration_audio_initialize(
  struct metil_configuration_audio* metil_configuration_audio
) {
  metil_configuration_audio->volume = (
    metil_configuration_default_audio_volume
  );
}
