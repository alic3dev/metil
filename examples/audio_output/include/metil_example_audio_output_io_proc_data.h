#ifndef __metil_example_audio_output_io_proc_data_h
#define __metil_example_audio_output_io_proc_data_h

#include <cer0_synthesizer.h>

#include <math_c_vector.h>

#define metil_example_audio_output_io_proc_data_length_buffer 0x1337

struct metil_example_audio_output_io_proc_data {
  struct cer0_synthesizer synthesizer;
  struct cer0_synthesizer synthesizer_secondary;

  struct math_c_vector4_float* vertices;
  struct math_c_vector4_float* vertices_secondary;

  unsigned short int index_vertex;  unsigned short int index_vertex_secondary;
};

#endif
