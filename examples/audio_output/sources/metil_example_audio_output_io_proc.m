#include <metil_example_audio_output_io_proc.h>

#include <metil_example_audio_output_io_proc_data.h>

#include <cer0_synthesizer.h>

#include <math_c_absolute.h>
#include <math_c_minimum.h>
#include <math_c_maximum.h>

#include <metil_audio/metil_audio_io_proc_data.h>

#include <pthread.h>

metil_audio_io_proc_macro_definition(metil_example_audio_output_io_proc) {
  metil_audio_io_proc_macro_definition_initializer;

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

    pthread_mutex_unlock(
      &metil_example_audio_output_io_proc_data->mutex
    );

    return (
      0x00
    );
  }

  struct cer0_synthesizer* synthesizer = &(
    metil_example_audio_output_io_proc_data->synthesizer
  );

  struct cer0_synthesizer* synthesizer_secondary = &(
    metil_example_audio_output_io_proc_data->synthesizer_secondary
  );

  float value_frame = (
    0x00
  );

  metil_audio_io_proc_macro_definition_frame_loop {
    metil_audio_io_proc_macro_definition_index_channel;

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

      float value_synthesizers = (
        0x00
      );

      for (
       unsigned int index_synthesizer = (
         0x00
       );
       (
         index_synthesizer <
         metil_example_audio_output_io_proc_data->length_synthesizers
       );
       ++index_synthesizer
      ) {
        value_synthesizers = (
          value_synthesizers +
          cer0_synthesizer_poll(
            &metil_example_audio_output_io_proc_data->synthesizers[
              index_synthesizer
            ]
          )
        );
      }

      value_frame = (
        value_synthesizer /
        0x02 *
        0.6f +
        value_synthesizers /
        math_c_maximum_float(
          metil_example_audio_output_io_proc_data->length_synthesizers,
          0x01
        ) *
        0.4f
      );

      metil_example_audio_output_io_proc_data->buffer[
        metil_example_audio_output_io_proc_data->index_buffer
      ] = (
        math_c_minimum_float(
          math_c_absolute_float(
            value_frame
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
    }

    metil_audio_io_proc_macro_definition_frame_set(
      value_frame
    );
  }

  metil_audio_io_proc_macro_definition_return;
}
