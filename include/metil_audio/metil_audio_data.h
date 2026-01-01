#ifndef __metil_audio_metil_audio_data_h
#define __metil_audio_metil_audio_data_h

#include <metil_audio/metil_audio_io_proc.h>

#include <cer0_audio_output.h>

struct metil_audio_data {
  struct cer0_audio_output audio_output;

  metil_audio_io_proc* io_procs;
  void** data_io_procs;
  unsigned char length_io_procs;

  float volume;

  unsigned char muted;
};

void metil_audio_data_initialize(
  struct metil_audio_data*
);

void metil_audio_data_destroy(
  struct metil_audio_data*
);

#endif
