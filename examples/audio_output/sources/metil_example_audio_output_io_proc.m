#include <metil_example_audio_output_io_proc.h>

#include <metil_example_audio_output_io_proc_data.h>

#include <cer0_synthesizer.h>

#include <metil_audio/metil_audio_io_proc_data.h>

OSStatus metil_example_audio_output_io_proc(
  AudioObjectID id_audio_object,
  const AudioTimeStamp* time_stamp_audio,
  const AudioBufferList* list_buffer_audio_in,
  const AudioTimeStamp* time_stamp_audio_in,
  AudioBufferList* list_buffer_audio_out,
  const AudioTimeStamp* time_stamp_audio_out,
  void* data
) {
  struct metil_audio_io_proc_data* metil_audio_io_proc_data = (
    data
  );

  struct metil* metil = (
    metil_audio_io_proc_data->metil
  );

  struct metil_example_audio_output_io_proc_data* metil_example_audio_output_io_proc_data = (
    metil_audio_io_proc_data->data
  );

  struct cer0_synthesizer* synthesizer = &(
    metil_example_audio_output_io_proc_data->synthesizer
  );

  struct cer0_synthesizer* synthesizer_secondary = &(
    metil_example_audio_output_io_proc_data->synthesizer_secondary
  );

  float value_total = (
    0.0f
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

        value_total = (
          value_total +
          value_synthesizer
        );

        buffer_out[
          index_buffer_out
        ] = (
          value_synthesizer /
          0x02
        );

        metil_example_audio_output_io_proc_data->vertices[
          metil_example_audio_output_io_proc_data->index_vertex
        ]. y = (
          value_synthesizer
        );

        metil_example_audio_output_io_proc_data->index_vertex = (
          (
            metil_example_audio_output_io_proc_data->index_vertex +
            0x01
          ) %
          metil_example_audio_output_io_proc_data_length_buffer
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
  
    value_total = (
      value_total /
      (float)
      (
        length_buffer_out /
        length_channels
      )
    );
  }

  metil_example_audio_output_io_proc_data->vertices_secondary[
    metil_example_audio_output_io_proc_data->index_vertex_secondary
  ].y = (
    value_total
  );

  metil_example_audio_output_io_proc_data->index_vertex_secondary = (
    (
      metil_example_audio_output_io_proc_data->index_vertex_secondary +
      0x01
    ) %
    metil_example_audio_output_io_proc_data_length_buffer
  );

  return (
    0x00
  );
}
