#ifndef __metil_h
#define __metil_h

#include <metil_audio/metil_audio_data.h>
#include <metil_configuration/metil_configuration.h>
#include <metil_initialize/metil_initialization_parameters.h>
#include <metil_input/metil_input.h>
#include <metil_library.h>
#include <metil_parameters.h>
#include <metil_paths/metil_paths.h>
#include <metil_paths/metil_paths_foundation.h>
#include <metil_player/metil_player_defaults.h>
#include <metil_rendering/metil_renderer_interface.h>
#include <metil_rendering/metil_renderer_on_initialize.h>
#include <metil_rendering/metil_rendering_properties.h>
#include <metil_system_information.h>
#include <metil_termination/metil_termination.h>
#include <metil_text/metil_text_characters.h>
#include <metil_text/metil_text_defaults.h>
#include <metil_texture_store.h>

struct metil;

typedef void (*metil_destroy_function)(
  struct metil* _Nonnull
);

struct metil {
  struct metil_audio_data audio;
  struct metil_configuration configuration;
  struct metil_initialization_parameters initialization_parameters;
  struct metil_input input;
  struct metil_library library;
  struct metil_parameters parameters;
  struct metil_paths paths;
  struct metil_paths_foundation paths_foundation;
  struct metil_renderer_interface renderer_interface;
  struct metil_rendering_properties rendering_properties;
  void* _Nonnull scene_controller;
  struct metil_system_information system_information;
  struct metil_termination termination;

  struct metil_player_defaults player_defaults;
  struct metil_text_characters text_characters_default;
  struct metil_text_defaults text_defaults;

  struct metil_texture_store texture_store;

  void* _Nullable data;

  metil_destroy_function _Nullable destroy;

  _Nullable metil_renderer_on_initialize_function renderer_on_initialize;
  void* _Nullable renderer_on_initialize_data;
};

void metil_structure_initialize(
  struct metil* _Nonnull
);

void metil_destroy(
  void* _Nonnull
);

#endif
