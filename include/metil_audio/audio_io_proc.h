#ifndef __metil_audio_audio_io_proc_h
#define __metil_audio_audio_io_proc_h

#if target_os_ios

#include <AVFAudio/AVFAudio.h>

typedef OSStatus (*metil_audio_io_proc)(
  BOOL* _Nonnull,
  const AudioTimeStamp* _Nonnull,
  AVAudioFrameCount,
  AudioBufferList* _Nonnull,
  void* _Nullable
);

#else

#include <cer0_audio_output.h>

typedef cer0_audio_output_io_proc metil_audio_io_proc;

#endif

#endif
