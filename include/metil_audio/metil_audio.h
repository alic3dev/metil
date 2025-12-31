#ifndef __metil_audio_metil_audio_h
#define __metil_audio_metil_audio_h

#include <metil.h>
#include <metil_audio/metil_audio_data.h>
#include <metil_configuration/metil_configuration.h>

void metil_audio_initialize(
  struct metil*,
  struct metil_audio_data*
);

void metil_audio_destroy(
  struct metil_audio_data*,
  struct metil_configuration*
);

#endif
