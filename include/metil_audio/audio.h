#ifndef __metil_audio_audio_h
#define __metil_audio_audio_h

#include <cer0_audio_output.h>

#include <CoreAudio/CoreAudio.h>

struct metil_audio_data;

extern struct cer0_audio_output audio_output;
extern struct metil_audio_data metil_audio_data;

struct metil_audio_data {
  cer0_audio_output_io_proc* io_procs;
  unsigned char length_io_procs;

  float volume;

  unsigned char muted;
};

void metil_audio_initialize();

void metil_audio_io_proc_add(
  cer0_audio_output_io_proc
);

unsigned char metil_audio_io_proc_remove(
  cer0_audio_output_io_proc
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
