#ifndef __metil_renderer_on_initialize_h
#define __metil_renderer_on_initialize_h

#include <metil.h>

struct metil;

typedef void (*metil_renderer_on_initialize_function)(
  struct metil* _Nonnull,
  void* _Nullable
);

#endif
