#ifndef __metil_audio_metil_audio_io_proc_ios_h
#define __metil_audio_metil_audio_io_proc_ios_h

#if target_os_ios

#include <AVFAudio/AVFAudio.h>

OSStatus metil_audio_output_io_proc(
  unsigned char,
  const AudioTimeStamp* _Nonnull,
  unsigned int,
  AudioBufferList* _Nonnull,
  void* _Nullable
);

#endif

#endif
