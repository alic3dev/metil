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

void metil_library_initialize_fps_display(
  id<MTLDevice> metal_kit_device,
  id<MTLLibrary> library_fps_display
) {
  if (
    library_fps_display != (void*)0
  ) {
    metil_library.library_fps_display = library_fps_display;
  } else if (
    metil_library.library != (void*)0
  ) {
    metil_library.library_fps_display = (
      metil_library.library
    );
  } else {
    metil_library.library_fps_display = [metal_kit_device newDefaultLibrary];
  }

  metil_library.function_vertex = [
    metil_library.library_fps_display
    newFunctionWithName: @"metil_fps_display_vertex"
  ];

  metil_library.function_fragment = [
    metil_library.library_fps_display
    newFunctionWithName: @"metil_fps_display_fragment"
  ];
}
