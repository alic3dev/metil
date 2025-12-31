#include <metil_audio/metil_audio.h>

#include <metil.h>
#include <metil_audio/metil_audio_data.h>
#include <metil_audio/metil_audio_io_proc.h>
#if target_os_ios
#include <metil_audio/metil_audio_io_proc_ios.h>
#else
#include <metil_audio/metil_audio_io_proc_macos.h>
#endif

#include <metil_debug/metil_debug_log.h>

#include <cer0_audio_output.h>

void metil_audio_initialize(
  struct metil* metil,
  struct metil_audio_data* metil_audio_data
) {
  metil_io_proc_initialize(
    metil_audio_data
  );

  cer0_audio_output_initialize(
    &metil_audio_data->audio_output,
    metil_audio_output_io_proc,
    metil
  );
}

void metil_audio_destroy(
  struct metil_audio_data* metil_audio_data,
  struct metil_configuration* metil_configuration
) {
  unsigned char status_audio_destory = cer0_audio_output_destroy(
    &metil_audio_data->audio_output
  );

  if (
    status_audio_destory != 0
  ) {
    metil_debug_log_error(
      metil_configuration->debug_log_level,
      "failed_to_destory_audio\n"
    );
  }

  metil_audio_io_proc_destroy(
    metil_audio_data
  );
}
