#ifndef __metil_example_audio_output_io_proc_data_h
#define __metil_example_audio_output_io_proc_data_h

#include <cer0_synthesizer.h>

#include <pthread.h>

#define metil_example_audio_output_io_proc_data_octave_minimum 0x01
#define metil_example_audio_output_io_proc_data_octave_maximum 0x06

struct metil_example_audio_output_io_proc_data {
  float* note_table;
  unsigned int length_note_table;

  struct cer0_synthesizer synthesizer;
  struct cer0_synthesizer synthesizer_secondary;
  struct cer0_synthesizer* synthesizers;

  unsigned char length_synthesizers;
  unsigned int index_synth;

  float frequency_last;

  unsigned char* buffer;

  unsigned int length_buffer;
  unsigned short int index_buffer;

  unsigned char exiting;

  pthread_mutex_t mutex;
};

#endif
