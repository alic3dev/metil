#ifndef __metil_object_metil_object_text_h
#define __metil_object_metil_object_text_h

#include <metil_object/metil_object.h>

#include <Metal/MTLDevice.h>

extern unsigned char metil_object_text_index_pipeline_render_default;

void metil_object_text_initialize(
  struct metil_object* _Nonnull,
  char* _Nonnull,
  id<MTLDevice> _Nonnull
);

void metil_object_text_destroy(
  struct metil_object* _Nonnull
);

#endif
