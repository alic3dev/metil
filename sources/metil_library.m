#include <metil_library.h>

#include <Metal/MTLDevice.h>

struct metil_library metil_library = {
  .library = (void*)0,
  .function_fragment = (void*)0,
  .function_vertex = (void*)0,

  .library_fps_display = (void*)0,
  .function_fragment_fps_display = (void*)0,
  .function_vertex_fps_display = (void*)0
};
