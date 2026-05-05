#ifndef __metil_audio_metil_audio_io_proc_h
#define __metil_audio_metil_audio_io_proc_h

#include <cer0_audio_output.h>

typedef cer0_audio_output_io_proc metil_audio_io_proc;
struct metil_audio_data;

#include <metil_audio/metil_audio_data.h>

void metil_io_proc_initialize(
  struct metil_audio_data*
);

void metil_audio_io_proc_add(
  struct metil_audio_data*,
  metil_audio_io_proc
);

void metil_audio_io_proc_add_with_data(
  struct metil_audio_data*,
  metil_audio_io_proc,
  void*
);

unsigned char metil_audio_io_proc_remove(
  struct metil_audio_data*,
  metil_audio_io_proc
);

void metil_audio_io_proc_destroy(
  struct metil_audio_data*
);

#if target_os_ios
#define metil_audio_io_proc_macro_type(name_metil_audio_io_proc)\
  int name_metil_audio_io_proc(\
    unsigned char,\
    const AudioTimeStamp* _Nonnull,\
    unsigned int,\
    AudioBufferList* _Nonnull,\
    void* _Nonnull\
  );
#else
#define metil_audio_io_proc_macro_type(name_metil_audio_io_proc)\
  OSStatus name_metil_audio_io_proc(\
    AudioObjectID,\
    const AudioTimeStamp* _Nonnull,\
    const AudioBufferList* _Nonnull,\
    const AudioTimeStamp* _Nonnull,\
    AudioBufferList* _Nonnull,\
    const AudioTimeStamp* _Nonnull,\
    void* _Nonnull\
  );
#endif

#if target_os_ios
#define metil_audio_io_proc_macro_definition(name_metil_audio_io_proc)\
  int name_metil_audio_io_proc(\
    unsigned char silence,\
    const AudioTimeStamp* _Nonnull timestamp,\
    AVAudioFrameCount length_frames,\
    AudioBufferList* _Nonnull output_data,\
    void* data\
  )
#else
#define metil_audio_io_proc_macro_definition(name_metil_audio_io_proc)\
  OSStatus name_metil_audio_io_proc(\
    AudioObjectID id_audio_object,\
    const AudioTimeStamp* time_stamp_audio,\
    const AudioBufferList* list_buffer_audio_in,\
    const AudioTimeStamp* time_stamp_audio_in,\
    AudioBufferList* list_buffer_audio_out,\
    const AudioTimeStamp* time_stamp_audio_out,\
    void* data\
  )
#endif

#define metil_audio_io_proc_macro_definition_initializer\
  struct metil_audio_io_proc_data* metil_audio_io_proc_data = (\
    data\
  );\
\
  struct metil* metil = (\
    metil_audio_io_proc_data->metil\
  );

#if target_os_ios
#define metil_audio_io_proc_macro_definition_frame_loop\
  unsigned long int length_channels = (\
    output_data->mNumberBuffers\
  );\
\
  for (\
    unsigned long int index_buffer = (\
      0x00\
    );\
    (\
      index_buffer <\
      output_data->mNumberBuffers\
    );\
    ++index_buffer\
  ) {\
    AudioBuffer audio_buffer_current = (\
      output_data->mBuffers[\
        index_buffer\
      ]\
    );\
\
    float* buffer_out = (\
      audio_buffer_current.mData\
    );\
\
    for (\
      unsigned int index_frame = (\
        0x00\
      );\
      (\
        index_frame <\
        length_frames\
      );\
      ++index_frame\
    )

#else
#define metil_audio_io_proc_macro_definition_frame_loop\
  for (\
    unsigned long int index_buffer = (\
      0x00\
    );\
    (\
      index_buffer <\
      list_buffer_audio_out->mNumberBuffers\
    );\
    ++index_buffer\
  ) {\
    AudioBuffer audio_buffer_current = (\
      list_buffer_audio_out->mBuffers[\
        index_buffer\
      ]\
    );\
\
    float* buffer_out = (\
      audio_buffer_current.mData\
    );\
\
    unsigned long int length_frames = (\
      audio_buffer_current.mDataByteSize /\
      sizeof(\
        float\
      )\
    );\
\
    unsigned long int length_channels = (\
      audio_buffer_current.mNumberChannels\
    );\
\
    for (\
      unsigned long int index_frame = (\
        0x00\
      );\
      (\
        index_frame <\
        length_frames\
      );\
      ++index_frame\
    )

#endif

#if target_os_ios
#define metil_audio_io_proc_macro_definition_index_channel\
  unsigned long int index_channel = (\
    index_buffer\
  );
#else
#define metil_audio_io_proc_macro_definition_index_channel\
  unsigned long int index_channel = (\
    index_frame %\
    length_channels\
  );
#endif

#define metil_audio_io_proc_macro_definition_frame_set(metil_audio_io_proc_macro_definition_value_frame)\
  buffer_out[\
    index_frame\
  ] = (\
    metil_audio_io_proc_macro_definition_value_frame\
  );

#define metil_audio_io_proc_macro_definition_return\
  }\
\
  return (\
    0x00\
  );

#endif
