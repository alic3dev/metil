#ifndef __metil_h
#define __metil_h

#include <metil_audio/metil_audio_data.h>
#include <metil_configuration/metil_configuration.h>
#include <metil_input/metil_input.h>
#include <metil_library.h>
#include <metil_rendering/metil_renderer_interface.h>
#include <metil_rendering/metil_rendering_properties.h>

#include <metil_system_information.h>
#include <metil_termination/metil_termination.h>

struct metil;

typedef void (*metil_destroy_function)(struct metil* _Nonnull);

struct metil {
  struct metil_audio_data audio;
  struct metil_configuration configuration;
  struct metil_input input;
  struct metil_library library;
  struct metil_renderer_interface renderer_interface;
  struct metil_rendering_properties rendering_properties;
  void* _Nonnull scene_controller;
  struct metil_system_information system_information;
  struct metil_termination termination;

  void* _Nullable data;

  metil_destroy_function _Nullable destroy;
};

void metil_structure_initialize(
  struct metil* _Nonnull
);

void metil_destroy(
  void* _Nonnull
);

#endif
