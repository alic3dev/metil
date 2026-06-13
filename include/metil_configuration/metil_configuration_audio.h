#ifndef __metil_configuration_metil_configuration_audio_h
#define __metil_configuration_metil_configuration_audio_h

#define metil_configuration_default_audio_volume 0x01

struct metil_configuration_audio {
  float volume;
};

void metil_configuration_audio_initialize(
  struct metil_configuration_audio*
);

#endif
