#include <metil_audio/metil_audio_io_proc.h>

#include <metil_audio/metil_audio_data.h>

#include <stdlib.h>

void metil_io_proc_initialize() {
  metil_audio_data.length_io_procs = 0;

  metil_audio_data.io_procs = malloc(
    sizeof(
      metil_audio_io_proc
    ) *
    metil_audio_data.length_io_procs
  );

  metil_audio_data.data_io_procs = malloc(
    sizeof(void*) *
    metil_audio_data.length_io_procs
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

void metil_audio_io_proc_destroy() {
  free(
    metil_audio_data.io_procs
  );

  free(
    metil_audio_data.data_io_procs
  );

  metil_audio_data.length_io_procs = 0;
}
