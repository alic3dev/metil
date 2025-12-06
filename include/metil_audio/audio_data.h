#ifndef __metil_audio_audio_data_h
#define __metil_audio_audio_data_h

#if target_device != 1

#include <metil_audio/audio_io_proc.h>

struct metil_audio_data {
  metil_audio_io_proc* io_procs;
  void** data_io_procs;
  unsigned char length_io_procs;

  float volume;

  unsigned char muted;
};

#endif

#endif
