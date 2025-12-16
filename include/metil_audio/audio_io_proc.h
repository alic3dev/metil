#ifndef __metil_audio_audio_io_proc_h
#define __metil_audio_audio_io_proc_h

#if target_os_ios

#include <AVFAudio/AVFAudio.h>

typedef int (*metil_audio_io_proc)(
  unsigned char,
  const struct AudioTimeStamp* _Nonnull,
  unsigned int,
  struct AudioBufferList* _Nonnull,
  void* _Nullable
);

#else

#include <cer0_audio_output.h>

typedef cer0_audio_output_io_proc metil_audio_io_proc;

#endif

#endif
