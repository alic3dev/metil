#include <metil_audio/audio.h>

#include <metil_debug/log.h>

#include <cer0_audio_output.h>

#include <CoreAudio/CoreAudio.h>

struct cer0_audio_output audio_output;
struct metil_audio_data metil_audio_data;

void metil_audio_initialize() {
  metil_audio_data.length_io_procs = 0;
  metil_audio_data.io_procs = malloc(
    sizeof(cer0_audio_output_io_proc) *
    metil_audio_data.length_io_procs
  );

  metil_audio_data.data_io_procs = malloc(
    sizeof(void*) *
    metil_audio_data.length_io_procs
  );

  metil_audio_data.muted = 1;
  metil_audio_data.volume = 0.2f;

  cer0_audio_output_initialize(
    &audio_output,
    metil_audio_output_io_proc,
    (void*)0
  );
}

void metil_audio_io_proc_add(
  cer0_audio_output_io_proc io_proc
) {
  metil_audio_data.length_io_procs = (
    metil_audio_data.length_io_procs + 1
  );

  metil_audio_data.io_procs = realloc(
    metil_audio_data.io_procs,
    sizeof(cer0_audio_output_io_proc) *
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
  cer0_audio_output_io_proc io_proc,
  void* data
) {
  metil_audio_data.length_io_procs = (
    metil_audio_data.length_io_procs + 1
  );

  metil_audio_data.io_procs = realloc(
    metil_audio_data.io_procs,
    sizeof(cer0_audio_output_io_proc) *
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
  cer0_audio_output_io_proc io_proc
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
    sizeof(cer0_audio_output_io_proc) *
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
  unsigned char status_audio_destory = cer0_audio_output_destroy(
    &audio_output
  );

  free(metil_audio_data.io_procs);
  free(metil_audio_data.data_io_procs);
  metil_audio_data.length_io_procs = 0;

  if (status_audio_destory != 0) {
    metil_debug_log_error("failed_to_destory_audio\n");
  }
}

OSStatus metil_audio_output_io_proc(
  AudioObjectID id_audio_object,
  const AudioTimeStamp* time_stamp_audio,
  const AudioBufferList* list_buffer_audio_in,
  const AudioTimeStamp* time_stamp_audio_in,
  AudioBufferList* list_buffer_audio_out,
  const AudioTimeStamp* time_stamp_audio_out,
  void* data
) {
  if (metil_audio_data.muted == 1) {
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
      id_audio_object,
      time_stamp_audio,
      list_buffer_audio_in,
      time_stamp_audio_in,
      list_buffer_audio_out,
      time_stamp_audio_out,
      metil_audio_data.data_io_procs[
        index_io_proc
      ]
    );

    if (status_io_proc != 0) {
      return status_io_proc;
    }
  }

  for (
    unsigned long int index_buffer = 0;
    index_buffer < list_buffer_audio_out->mNumberBuffers;
    ++index_buffer
  ) {
    AudioBuffer audio_buffer_current = list_buffer_audio_out->mBuffers[index_buffer];

    float* buffer_out = audio_buffer_current.mData;
    unsigned long int size_buffer_out = audio_buffer_current.mDataByteSize / sizeof(float);
    
    for (
      unsigned long int index_buffer_out = 0;
      index_buffer_out < size_buffer_out;
      ++index_buffer_out
    ) {
      buffer_out[index_buffer_out] = (
        buffer_out[index_buffer_out] *
        metil_audio_data.volume
      );
    }
  }

  return 0;
}
