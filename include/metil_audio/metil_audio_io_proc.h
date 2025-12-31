#ifndef __metil_audio_metil_audio_io_proc_h
#define __metil_audio_metil_audio_io_proc_h

#include <cer0_audio_output.h>

typedef cer0_audio_output_io_proc metil_audio_io_proc;
struct metil_audio_data;

#include <metil_audio/metil_audio_data.h>

void metil_io_proc_initialize(
  struct metil_audio_data*
);

void metil_audio_io_proc_add(
  struct metil_audio_data*,
  metil_audio_io_proc
);

void metil_audio_io_proc_add_with_data(
  struct metil_audio_data*,
  metil_audio_io_proc,
  void*
);

unsigned char metil_audio_io_proc_remove(
  struct metil_audio_data*,
  metil_audio_io_proc
);

void metil_audio_io_proc_destroy(
  struct metil_audio_data*
);

#endif
