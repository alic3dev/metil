#include <metil_library.h>

#include <Metal/MTLDevice.h>

struct metil_library metil_library = {
  .library = (void*)0,
  .function_fragment = (void*)0,
  .function_vertex = (void*)0,

  .library_fps_display = (void*)0,
  .function_fragment_fps_display = (void*)0,
  .function_vertex_fps_display = (void*)0,

  .library_wireframe = (void*)0,
  .function_fragment_wireframe = (void*)0,
  .function_vertex_wireframe = (void*)0
};

void metil_library_initialize(
  id<MTLDevice> metal_device,
  NSString* name_function_fragment,
  NSString* name_function_vertex
) {
  if (
    metil_library.library == (void*)0
  ) {
    metil_library.library = [metal_device newDefaultLibrary];
  }

  metil_library.function_fragment = [
    metil_library.library
    newFunctionWithName: name_function_fragment
  ];

  metil_library.function_vertex = [
    metil_library.library
    newFunctionWithName: name_function_vertex
  ];

  metil_library_fps_display_initialize(
    metal_device,
    metil_library.library
  );

  metil_library_wireframe_initialize(
    metal_device,
    metil_library.library
  );
}

void metil_library_fps_display_initialize(
  id<MTLDevice> metal_device,
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
    metil_library.library_fps_display = [metal_device newDefaultLibrary];
  }

  metil_library.function_fragment_fps_display = [
    metil_library.library_fps_display
    newFunctionWithName: @"metil_fps_display_fragment"
  ];

  metil_library.function_vertex_fps_display = [
    metil_library.library_fps_display
    newFunctionWithName: @"metil_fps_display_vertex"
  ];
}

void metil_library_wireframe_initialize(
  id<MTLDevice> metal_device,
  id<MTLLibrary> library_wireframe
) {
  if (
    library_wireframe != (void*)0
  ) {
    metil_library.library_wireframe = library_wireframe;
  } else if (
    metil_library.library != (void*)0
  ) {
    metil_library.library_wireframe = (
      metil_library.library
    );
  } else {
    metil_library.library_wireframe = [metal_device newDefaultLibrary];
  }

  metil_library.function_fragment_wireframe = [
    metil_library.library_wireframe
    newFunctionWithName: @"metil_wireframe_fragment"
  ];

  metil_library.function_vertex_wireframe = [
    metil_library.library_wireframe
    newFunctionWithName: @"metil_wireframe_vertex"
  ];
}
