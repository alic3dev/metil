#ifndef __metil_audio_audio_ios_h
#define __metil_audio_audio_ios_h

#if target_device == 1

#include <metil_audio/audio_ios_data.h>
#include <metil_audio/audio_io_proc.h>

#include <AVFAudio/AVFAudio.h>

extern struct metil_audio_data metil_audio_data;

void metil_audio_initialize();

void metil_audio_io_proc_add(
  metil_audio_io_proc _Nonnull
);

void metil_audio_io_proc_add_with_data(
  metil_audio_io_proc _Nonnull,
  void* _Nullable
);

unsigned char metil_audio_io_proc_remove(
  metil_audio_io_proc _Nonnull
);

void metil_audio_destroy();

OSStatus metil_audio_output_io_proc(
  BOOL* _Nonnull,
  const AudioTimeStamp* _Nonnull,
  AVAudioFrameCount,
  AudioBufferList* _Nonnull
);

#endif

#endif
