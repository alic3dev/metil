#ifndef __metil_audio_audio_h
#define __metil_audio_audio_h

#if target_device == 1
#include <metil_audio/audio_ios.h>
#else

#include <metil_audio/audio_data.h>
#include <metil_audio/audio_io_proc.h>

#include <cer0_audio_output.h>

#include <CoreAudio/CoreAudio.h>

extern struct cer0_audio_output audio_output;
extern struct metil_audio_data metil_audio_data;

void metil_audio_initialize();

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

void metil_audio_destroy();

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
