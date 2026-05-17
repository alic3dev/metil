#ifndef __metil_object_metil_object_text_h
#define __metil_object_metil_object_text_h

#include <metil.h>
#include <metil_object/metil_object.h>
#include <metil_text/metil_text_render_parameters.h>

#include <Metal/MTLDevice.h>

void metil_object_text_initialize(
  struct metil* _Nonnull,
  struct metil_object* _Nonnull,
  char* _Nonnull
);

void metil_object_text_initialize_with_parameters(
  struct metil* _Nonnull,
  struct metil_object* _Nonnull,
  struct metil_text_render_parameters* _Nonnull,
  char* _Nonnull
);

void metil_object_text_destroy(
  struct metil_object* _Nonnull
);

#endif
