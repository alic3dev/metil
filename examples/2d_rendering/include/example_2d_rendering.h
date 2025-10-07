#ifndef __example_2d_rendering_h
#define __example_2d_rendering_h

#include <metil_rendering/rendering_properties.h>

#include <Metal/MTLDevice.h>

int main(
  int,
  const char**
);

void example_2d_rendering_renderer_on_initialize(
  id<MTLDevice>,
  struct metil_rendering_properties*,
  void*
);

#endif
