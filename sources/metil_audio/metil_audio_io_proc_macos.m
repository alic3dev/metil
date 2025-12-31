#if !target_os_ios

#include <metil_audio/metil_audio_io_proc_macos.h>

#include <metil.h>
#include <metil_audio/metil_audio_data.h>
#include <metil_audio/metil_audio_io_proc.h>

#include <CoreAudio/CoreAudio.h>

OSStatus metil_audio_output_io_proc(
  AudioObjectID id_audio_object,
  const AudioTimeStamp* time_stamp_audio,
  const AudioBufferList* list_buffer_audio_in,
  const AudioTimeStamp* time_stamp_audio_in,
  AudioBufferList* list_buffer_audio_out,
  const AudioTimeStamp* time_stamp_audio_out,
  void* data
) {
  struct metil* metil = (
    data
  );

  if (
    metil->audio.muted == 1
  ) {
    for (
      unsigned long int index_buffer = 0;
      index_buffer < list_buffer_audio_out->mNumberBuffers;
      ++index_buffer
    ) {
      AudioBuffer audio_buffer_current = (
        list_buffer_audio_out->mBuffers[
          index_buffer
        ]
      );

      float* buffer_out = (
        audio_buffer_current.mData
      );

      unsigned long int size_buffer_out = (
        audio_buffer_current.mDataByteSize /
        sizeof(float)
      );

      for (
        unsigned long int index_buffer_out = 0;
        index_buffer_out < size_buffer_out;
        ++index_buffer_out
      ) {
        buffer_out[
          index_buffer_out
        ] = (
          0.0f
        );
      }
    }

    return 0;
  }

  for (
    unsigned char index_io_proc = 0;
    index_io_proc < metil->audio.length_io_procs;
    ++index_io_proc
  ) {
    OSStatus status_io_proc = metil->audio.io_procs[
      index_io_proc
    ](
      id_audio_object,
      time_stamp_audio,
      list_buffer_audio_in,
      time_stamp_audio_in,
      list_buffer_audio_out,
      time_stamp_audio_out,
      metil->audio.data_io_procs[
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
    unsigned long int index_buffer = 0;
    index_buffer < list_buffer_audio_out->mNumberBuffers;
    ++index_buffer
  ) {
    AudioBuffer audio_buffer_current = (
      list_buffer_audio_out->mBuffers[
        index_buffer
      ]
    );

    float* buffer_out = (
      audio_buffer_current.mData
    );

    unsigned long int size_buffer_out = (
      audio_buffer_current.mDataByteSize /
      sizeof(float)
    );

    for (
      unsigned long int index_buffer_out = 0;
      index_buffer_out < size_buffer_out;
      ++index_buffer_out
    ) {
      buffer_out[
        index_buffer_out
      ] = (
        buffer_out[
          index_buffer_out
        ] *
        metil->audio.volume
      );
    }
  }

  return 0;
}

#endif
