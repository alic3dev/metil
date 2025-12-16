#if target_os_ios

#include <metil_audio/metil_audio_io_proc_ios.h>

#include <metil_audio/metil_audio_data.h>
#include <metil_audio/metil_audio_io_proc.h>

#include <AVFAudio/AVFAudio.h>

int metil_audio_output_io_proc(
  unsigned char silence,
  const AudioTimeStamp* _Nonnull timestamp,
  AVAudioFrameCount frame_count,
  AudioBufferList* _Nonnull output_data,
  void* cer0_data
) {
  if (
    metil_audio_data.muted == 1
  ) {
    return 0;
  }

  for (
    unsigned char index_io_proc = 0;
    index_io_proc < metil_audio_data.length_io_procs;
    ++index_io_proc
  ) {
    OSStatus status_io_proc = metil_audio_data.io_procs[
      index_io_proc
    ](
      silence,
      timestamp,
      frame_count,
      output_data,
      metil_audio_data.data_io_procs[
        index_io_proc
      ]
    );

    if (
      status_io_proc != 0
    ) {
      return status_io_proc;
    }
  }

  for (
    unsigned int index_frame = 0;
    index_frame < frame_count;
    ++index_frame
  ) {
    for (
      unsigned long int index_buffer = 0;
      index_buffer < output_data->mNumberBuffers;
      ++index_buffer
    ) {
      AudioBuffer audio_buffer_current = output_data->mBuffers[
        index_buffer
      ];

      float* buffer_out = (
        audio_buffer_current.mData
      );

      buffer_out[
        index_frame
      ] = (
        buffer_out[
          index_frame
        ] *
        metil_audio_data.volume
      );
    }
  }
  
  return 0;
}

#endif
