#ifndef __metil_object_metil_object_text_h
#define __metil_object_metil_object_text_h

#include <metil_object/metil_object.h>

#include <Metal/MTLDevice.h>

extern unsigned char metil_object_text_index_pipeline_render_default;

void metil_object_text_initialize(
  struct metil_object* _Nonnull metil_object,
  char* _Nonnull metil_object_text_char_array,
  id<MTLDevice> _Nonnull metal_device
);

#endif
