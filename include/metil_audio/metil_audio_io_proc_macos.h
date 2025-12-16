#ifndef __metil_audio_metil_audio_io_proc_macos_h
#define __metil_audio_metil_audio_io_proc_macos_h

#if !target_os_ios

#include <CoreAudio/CoreAudio.h>

OSStatus metil_audio_output_io_proc(
  AudioObjectID,
  const AudioTimeStamp*,
  const AudioBufferList*,
  const AudioTimeStamp*,
  AudioBufferList*,
  const AudioTimeStamp*,
  void*
);

#endif

#endif
