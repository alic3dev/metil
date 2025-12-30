#include <metil_audio/metil_audio.h>

#include <metil_audio/metil_audio_data.h>
#include <metil_audio/metil_audio_io_proc.h>
#if target_os_ios
#include <metil_audio/metil_audio_io_proc_ios.h>
#else
#include <metil_audio/metil_audio_io_proc_macos.h>
#endif

#include <metil_debug/metil_log.h>

#include <cer0_audio_output.h>

void metil_audio_initialize() {
  metil_io_proc_initialize();

  cer0_audio_output_initialize(
    &metil_audio_data.audio_output,
    metil_audio_output_io_proc,
    (void*)0
  );
}

void metil_audio_destroy() {
  unsigned char status_audio_destory = cer0_audio_output_destroy(
    &metil_audio_data.audio_output
  );

  if (
    status_audio_destory != 0
  ) {
    metil_debug_log_error(
      "failed_to_destory_audio\n"
    );
  }

  metil_audio_io_proc_destroy();
}
