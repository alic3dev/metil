#ifndef __metil_example_audio_output_io_proc_h
#define __metil_example_audio_output_io_proc_h

#include <CoreAudio/CoreAudio.h>

OSStatus metil_example_audio_output_io_proc(
  AudioObjectID,
  const AudioTimeStamp* _Nonnull,
  const AudioBufferList* _Nonnull,
  const AudioTimeStamp* _Nonnull,
  AudioBufferList* _Nonnull,
  const AudioTimeStamp* _Nonnull,
  void* _Nonnull
);

#endif
