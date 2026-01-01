#include <metil.h>

#include <metil_audio/metil_audio.h>
#include <metil_configuration/metil_configuration.h>
#include <metil_paths/metil_paths.h>
#include <metil_scenes/metil_scene_controller.h>
#include <metil_text/metil_text.h>

#include <interrupt_handler.h>

void metil_structure_initialize(
  struct metil* metil
) {
  metil->data = (
    (void*) 0
  );

  metil->destroy = (
    (void*) 0
  );
}

void metil_destroy(
  void* metil_pointer
) {
  struct metil* metil = (
    metil_pointer
  );

  metil_scene_controller_destroy(
    metil
  );

  interrupt_handler_destroy();
  
  metil_paths_destroy();
  
  metil_audio_destroy(
    &metil->audio,
    &metil->configuration
  );
  
  metil_text_destroy();

  metil_configuration_destroy(
    &metil->configuration
  );

  if (
    metil->destroy != (void*) 0
  ) {
    metil->destroy(
      metil
    );
  }
}
