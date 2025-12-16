#ifndef __metil_audio_metil_audio_io_proc_h
#define __metil_audio_metil_audio_io_proc_h

#include <cer0_audio_output.h>

typedef cer0_audio_output_io_proc metil_audio_io_proc;

void metil_io_proc_initialize();

void metil_audio_io_proc_add(
  metil_audio_io_proc
);

void metil_audio_io_proc_add_with_data(
  metil_audio_io_proc,
  void*
);

unsigned char metil_audio_io_proc_remove(
  metil_audio_io_proc
);

void metil_audio_io_proc_destroy();

#endif
