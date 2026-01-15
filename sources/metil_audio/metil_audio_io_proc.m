#include <metil_audio/metil_audio_io_proc.h>

#include <metil_audio/metil_audio_data.h>

#include <clic3_memory.h>

void metil_io_proc_initialize(
  struct metil_audio_data* metil_audio_data
) {
  metil_audio_data->length_io_procs = 0;

  clic3_memory_allocate(
    &metil_audio_data->io_procs,
    sizeof(
      metil_audio_io_proc
    ) *
    metil_audio_data->length_io_procs
  );

  clic3_memory_allocate(
    &metil_audio_data->data_io_procs,
    (
      sizeof(
        void*
      ) *
      metil_audio_data->length_io_procs
    )
  );
}

void metil_audio_io_proc_add(
  struct metil_audio_data* metil_audio_data,
  metil_audio_io_proc io_proc
) {
  metil_audio_data->length_io_procs = (
    metil_audio_data->length_io_procs + 1
  );

  clic3_memory_allocate(
    &metil_audio_data->io_procs,
    (
      sizeof(
        metil_audio_io_proc
      ) *
      metil_audio_data->length_io_procs
    )
  );

  metil_audio_data->io_procs[
    metil_audio_data->length_io_procs - 1
  ] = io_proc;

  clic3_memory_allocate(
    &metil_audio_data->data_io_procs,
    (
      sizeof(
        void*
      ) *
      metil_audio_data->length_io_procs
    )
  );

  metil_audio_data->data_io_procs[
    metil_audio_data->length_io_procs - 1
  ] = (void*)0;
}

void metil_audio_io_proc_add_with_data(
  struct metil_audio_data* metil_audio_data,
  metil_audio_io_proc io_proc,
  void* data
) {
  metil_audio_data->length_io_procs = (
    metil_audio_data->length_io_procs + 1
  );

  clic3_memory_allocate(
    &metil_audio_data->io_procs,
    (
      sizeof(
        metil_audio_io_proc
      ) *
      metil_audio_data->length_io_procs
    )
  );

  metil_audio_data->io_procs[
    metil_audio_data->length_io_procs - 1
  ] = io_proc;

  metil_audio_data->io_procs[
    metil_audio_data->length_io_procs - 1
  ] = io_proc;

  clic3_memory_allocate(
    &metil_audio_data->data_io_procs,
    (
      sizeof(
        void*
      ) *
      metil_audio_data->length_io_procs
    )
  );

  metil_audio_data->data_io_procs[
    metil_audio_data->length_io_procs - 1
  ] = data;
}

unsigned char metil_audio_io_proc_remove(
  struct metil_audio_data* metil_audio_data,
  metil_audio_io_proc io_proc
) {
  signed short int index_io_proc_remove = -1;

  for (
    unsigned char index_io_proc = 0;
    index_io_proc < metil_audio_data->length_io_procs;
    ++index_io_proc
  ) {
    if (
      metil_audio_data->io_procs[
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
    index_io_proc < metil_audio_data->length_io_procs - 1;
    ++index_io_proc
  ) {
    metil_audio_data->io_procs[
      index_io_proc
    ] = metil_audio_data->io_procs[
      index_io_proc + 1
    ];

    metil_audio_data->data_io_procs[
      index_io_proc
    ] = metil_audio_data->data_io_procs[
      index_io_proc + 1
    ];
  }

  metil_audio_data->length_io_procs = (
    metil_audio_data->length_io_procs - 1
  );

  clic3_memory_allocate(
    &metil_audio_data->io_procs,
    (
      sizeof(
        metil_audio_io_proc
      ) *
      metil_audio_data->length_io_procs
    )
  );

  clic3_memory_allocate(
    &metil_audio_data->data_io_procs,
    (
      sizeof(
        void*
      ) *
      metil_audio_data->length_io_procs
    )
  );

  return 0;
}

void metil_audio_io_proc_destroy(
  struct metil_audio_data* metil_audio_data
) {
  clic3_memory_free(
    metil_audio_data->io_procs
  );

  clic3_memory_free(
    metil_audio_data->data_io_procs
  );

  metil_audio_data->length_io_procs = 0;
}
