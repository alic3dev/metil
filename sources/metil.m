#include <metil.h>

#include <metil_audio/metil_audio.h>
#include <metil_configuration/metil_configuration.h>
#include <metil_parameters.h>
#include <metil_paths/metil_paths.h>
#include <metil_player/metil_player_defaults.h>
#include <metil_rendering/metil_renderer.h>
#include <metil_scenes/metil_scene_controller.h>
#include <metil_text/metil_text.h>
#include <metil_texture_store.h>

#include <clic3_memory.h>

#include <interrupt_handler.h>

void metil_structure_initialize(
  struct metil* metil
) {
  metil->text_defaults.object_text_index_pipeline_render = (
    0x00
  );

  metil_player_defaults_initialize(
    &metil->player_defaults
  );

  metil->scene_controller = (
    clic3_memory_allocate_raw(
      sizeof(
        struct metil_scene_controller
      )
    )
  );

  metil->data = (
    0x00
  );

  metil->destroy = (
    0x00
  );
}

void metil_destroy(
  void* metil_pointer
) {
  struct metil* metil = (
    metil_pointer
  );

  metil->renderer_interface.renderer->destroying = (
    0x01
  );

  pthread_mutex_lock(
    &metil->renderer_interface.renderer->mutex_destroying
  );

  pthread_mutex_unlock(
    &metil->renderer_interface.renderer->mutex_destroying
  );

  metil_scene_controller_destroy(
    metil,
    metil->scene_controller
  );

  interrupt_handler_destroy();

  metil_paths_destroy(
    &metil->paths
  );

  if (
    metil->initialization_parameters.disabled_audio ==
    0x00
  ) {
    metil_audio_destroy(
      &metil->audio,
      &metil->configuration
    );
  }

  metil_text_defaults_destroy(
    &metil->text_defaults
  );

  metil_configuration_destroy(
    &metil->configuration
  );

  metil_parameters_destroy(
    &metil->parameters
  );
  
  metil_texture_store_destroy(
    &metil->texture_store
  );

  if (
    metil->destroy !=
    0x00
  ) {
    metil->destroy(
      metil
    );
  }

  clic3_memory_free_raw(
    metil->scene_controller
  );
}
