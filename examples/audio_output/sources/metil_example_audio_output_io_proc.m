#include <metil_example_audio_output_io_proc.h>

#include <metil_example_audio_output_io_proc_data.h>

#include <cer0_synthesizer.h>

#include <math_c_absolute.h>
#include <math_c_minimum.h>
#include <math_c_maximum.h>

#include <metil_audio/metil_audio_io_proc_data.h>

#include <pthread.h>

metil_audio_io_proc_macro_definition(metil_example_audio_output_io_proc) {
  struct metil_audio_io_proc_data* metil_audio_io_proc_data = (
    data
  );

  struct metil* metil = (
    metil_audio_io_proc_data->metil
  );

  struct metil_example_audio_output_io_proc_data* metil_example_audio_output_io_proc_data = (
    metil_audio_io_proc_data->data
  );

if (
metil_example_audio_output_io_proc_data->exiting ==
0x01
) {
metil_audio_io_proc_remove(
    &metil->audio,
    metil_example_audio_output_io_proc
  );

  
pthread_mutex_unlock(&metil_example_audio_output_io_proc_data->mutex);

return 0x00;}

  struct cer0_synthesizer* synthesizer = &(
    metil_example_audio_output_io_proc_data->synthesizer
  );

  struct cer0_synthesizer* synthesizer_secondary = &(
    metil_example_audio_output_io_proc_data->synthesizer_secondary
  );


  for (
    unsigned long int index_buffer = (
      0x00
    );
    (
      index_buffer <
      list_buffer_audio_out->mNumberBuffers
    );
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

    unsigned long int length_buffer_out = (
      audio_buffer_current.mDataByteSize /
      sizeof(
        float
      )
    );

    unsigned long int length_channels = (
      audio_buffer_current.mNumberChannels
    );

    for (
      unsigned long int index_buffer_out = (
        0x00
      );
      (
        index_buffer_out <
        length_buffer_out
      );
      ++index_buffer_out
    ) {
      unsigned long int index_channel = (
        index_buffer_out %
        length_channels
      );

      if (
        index_channel ==
        0x00
      ) {
        float value_synthesizer = (
          cer0_synthesizer_poll(
            synthesizer
          ) +
          cer0_synthesizer_poll(
            synthesizer_secondary
          )
         );
         
         float synthies = 0x00;
         
        for (
         unsigned int index_synth = 0; index_synth < metil_example_audio_output_io_proc_data->length_synthesizers; ++index_synth
        ) {
          synthies = (
            synthies +
            cer0_synthesizer_poll(
              &metil_example_audio_output_io_proc_data->synthesizers[index_synth]
            )
          );
          }

          
        buffer_out[
          index_buffer_out
        ] = (
          (value_synthesizer /
          (float) (0x02)
          ) * 0.6f +
          (synthies /
          (float) math_c_maximum_float(0x01,metil_example_audio_output_io_proc_data->length_synthesizers)) * 0.4f 
        );
        
        metil_example_audio_output_io_proc_data->buffer[
          metil_example_audio_output_io_proc_data->index_buffer
        ] = (
          math_c_minimum_float(
            math_c_absolute_float(
              buffer_out[
                index_buffer_out
              ]
            ),
            0x01
          ) *
          0xff
        );

        metil_example_audio_output_io_proc_data->index_buffer = (
          (
            metil_example_audio_output_io_proc_data->index_buffer +
            0x01
          ) %
          metil_example_audio_output_io_proc_data->length_buffer
        );
      } else {
        buffer_out[
          index_buffer_out
        ] = (
          buffer_out[
            index_buffer_out -
            index_channel
          ]
        );
      }
    }
  }

  return (
    0x00
  );
}
