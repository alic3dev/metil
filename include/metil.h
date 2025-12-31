#ifndef __metil_h
#define __metil_h

#include <metil_library.h>
#include <metil_rendering/metil_renderer_interface.h>
#include <metil_rendering/metil_rendering_properties.h>
#include <metil_system_information.h>
#include <metil_termination/metil_termination.h>

struct metil {
  struct metil_termination termination;
  struct metil_library library;
  struct metil_renderer_interface renderer_interface;
  struct metil_rendering_properties rendering_properties;
  struct metil_system_information system_information;
};

void metil_destroy(
  void* _Nonnull
);

#endif
