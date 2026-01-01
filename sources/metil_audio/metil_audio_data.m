#include <metil_audio/metil_audio_data.h>

#include <metil_audio/metil_audio_io_proc.h>

void metil_audio_data_initialize(
  struct metil_audio_data* metil_audio_data
) {
  metil_audio_data->muted = 1;
  metil_audio_data->volume = 1.0f;

  metil_io_proc_initialize(
    metil_audio_data
  );
}

void metil_audio_data_destroy(
  struct metil_audio_data* metil_audio_data
) {
  metil_audio_io_proc_destroy(
    metil_audio_data
  );
}
