#ifndef __metil_example_audio_output_io_proc_data_h
#define __metil_example_audio_output_io_proc_data_h

#include <cer0_synthesizer.h>

#include <math_c_vector.h>

#include <pthread.h>

struct metil_example_audio_output_io_proc_data {
  float* note_table;
  unsigned int length_note_table;

  struct cer0_synthesizer synthesizer;
  struct cer0_synthesizer synthesizer_secondary;
  struct cer0_synthesizer* synthesizers;
  
  unsigned char length_synthesizers;
  unsigned int index_synth;
  
  unsigned char* buffer;
  
  float frequency_last;
  
  unsigned int length_buffer;  unsigned short int index_buffer;
  
  unsigned char exiting;
  
pthread_mutex_t mutex;};

#endif
