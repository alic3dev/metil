#if target_os_ios

#include <metil_audio/audio_ios.h>
#include <metil_audio/audio_io_proc.h>

#include <cer0_audio_output.h>

#include <AVFAudio/AVFAudio.h>

struct cer0_audio_output metil_audio_output;
struct metil_audio_data metil_audio_data;

void metil_audio_initialize() {
  metil_audio_data.length_io_procs = 0;
  metil_audio_data.io_procs = malloc(
    sizeof(metil_audio_io_proc) *
    metil_audio_data.length_io_procs
  );

  metil_audio_data.data_io_procs = malloc(
    sizeof(void*) *
    metil_audio_data.length_io_procs
  );

  metil_audio_data.muted = 1;
  metil_audio_data.volume = 1.0f;
  
  cer0_audio_output_initialize(
    &metil_audio_output,
    metil_audio_output_io_proc,
    (void*)0
  );
}

void metil_audio_io_proc_add(
  metil_audio_io_proc io_proc
) {
  metil_audio_data.length_io_procs = (
    metil_audio_data.length_io_procs + 1
  );

  metil_audio_data.io_procs = realloc(
    metil_audio_data.io_procs,
    sizeof(metil_audio_io_proc) *
    metil_audio_data.length_io_procs
  );

  metil_audio_data.io_procs[
    metil_audio_data.length_io_procs - 1
  ] = io_proc;

  metil_audio_data.data_io_procs = realloc(
    metil_audio_data.data_io_procs,
    sizeof(void*) *
    metil_audio_data.length_io_procs
  );

  metil_audio_data.data_io_procs[
    metil_audio_data.length_io_procs - 1
  ] = (void*)0;
}

void metil_audio_io_proc_add_with_data(
  metil_audio_io_proc io_proc,
  void* data
) {
  metil_audio_data.length_io_procs = (
    metil_audio_data.length_io_procs + 1
  );

  metil_audio_data.io_procs = realloc(
    metil_audio_data.io_procs,
    sizeof(metil_audio_io_proc) *
    metil_audio_data.length_io_procs
  );

  metil_audio_data.io_procs[
    metil_audio_data.length_io_procs - 1
  ] = io_proc;

  metil_audio_data.io_procs[
    metil_audio_data.length_io_procs - 1
  ] = io_proc;

  metil_audio_data.data_io_procs = realloc(
    metil_audio_data.data_io_procs,
    sizeof(void*) *
    metil_audio_data.length_io_procs
  );

  metil_audio_data.data_io_procs[
    metil_audio_data.length_io_procs - 1
  ] = data;
}

unsigned char metil_audio_io_proc_remove(
  metil_audio_io_proc io_proc
) {
  signed short int index_io_proc_remove = -1;

  for (
    unsigned char index_io_proc = 0;
    index_io_proc < metil_audio_data.length_io_procs;
    ++index_io_proc
  ) {
    if (
      metil_audio_data.io_procs[
        index_io_proc
      ] == io_proc
    ) {
      index_io_proc_remove = index_io_proc;
      break;
    }
  }

  if (
    index_io_proc_remove == -1
  ) {
    return 1;
  }

  for (
    unsigned char index_io_proc = index_io_proc_remove;
    index_io_proc < metil_audio_data.length_io_procs - 1;
    ++index_io_proc
  ) {
    metil_audio_data.io_procs[
      index_io_proc
    ] = metil_audio_data.io_procs[
      index_io_proc + 1
    ];

    metil_audio_data.data_io_procs[
      index_io_proc
    ] = metil_audio_data.data_io_procs[
      index_io_proc + 1
    ];
  }

  metil_audio_data.length_io_procs = (
    metil_audio_data.length_io_procs - 1
  );

  metil_audio_data.io_procs = realloc(
    metil_audio_data.io_procs,
    sizeof(metil_audio_io_proc) *
    metil_audio_data.length_io_procs
  );

  metil_audio_data.data_io_procs = realloc(
    metil_audio_data.data_io_procs,
    sizeof(void*) *
    metil_audio_data.length_io_procs
  );

  return 0;
}

void metil_audio_destroy() {
  [metil_audio_data.engine_audio stop];

  metil_audio_data.length_io_procs = 0;

  free(metil_audio_data.io_procs);
  free(metil_audio_data.data_io_procs);
}

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

    if (status_io_proc != 0) {
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

      float* buffer_out = audio_buffer_current.mData;

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
