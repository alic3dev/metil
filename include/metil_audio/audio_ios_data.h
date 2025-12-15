#ifndef __metil_audio_audio_ios_data_h
#define __metil_audio_audio_ios_data_h

#if target_os_ios

#include <metil_audio/audio_io_proc.h>

#include <AVFAudio/AVFAudio.h>

struct metil_audio_data {
  AVAudioEngine* _Nonnull engine_audio;

  metil_audio_io_proc _Nonnull * _Nonnull io_procs;
  void* _Nonnull * _Nullable data_io_procs;
  unsigned char length_io_procs;

  float volume;

  unsigned char muted;
};

#endif

#endif
