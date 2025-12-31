#include <metil_audio/metil_audio_data.h>

void metil_audio_data_initialize(
  struct metil_audio_data* metil_audio_data
) {
  metil_audio_data->muted = 1;
  metil_audio_data->volume = 1.0f;
}
