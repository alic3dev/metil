#include <metil_library.h>

#include <Metal/MTLDevice.h>

void metil_library_pre_initialize(
  struct metil_library* metil_library
) {
  metil_library->library = (
    0x00
  );
  
  metil_library->function_fragment = (
    0x00
  );
  
  metil_library->function_vertex = (
    0x00
  );

  metil_library->library_fps_display = (
    0x00
  );
  
  metil_library->function_fragment_fps_display = (
    0x00
  );
  
  metil_library->function_vertex_fps_display = (
    0x00
  );

  metil_library->library_wireframe = (
    0x00
  );
  
  metil_library->function_fragment_wireframe = (
    0x00
  );
  
  metil_library->function_vertex_wireframe = (
    0x00
  );
}

void metil_library_initialize(
  struct metil_library* metil_library,
  id<MTLDevice> metal_device,
  NSString* name_function_fragment,
  NSString* name_function_vertex
) {
  if (
    metil_library->library ==
    0x00
  ) {
    metil_library->library = [
      metal_device
      newDefaultLibrary
    ];
  }

  metil_library->function_fragment = [
    metil_library->library
    newFunctionWithName: name_function_fragment
  ];

  metil_library->function_vertex = [
    metil_library->library
    newFunctionWithName: name_function_vertex
  ];

  metil_library_fps_display_initialize(
    metil_library,
    metal_device,
    metil_library->library
  );

  metil_library_wireframe_initialize(
    metil_library,
    metal_device,
    metil_library->library
  );
}

void metil_library_fps_display_initialize(
  struct metil_library* metil_library,
  id<MTLDevice> metal_device,
  id<MTLLibrary> library_fps_display
) {
  if (
    library_fps_display !=
    0x00
  ) {
    metil_library->library_fps_display = (
      library_fps_display
    );
  } else if (
    metil_library->library !=
    0x00
  ) {
    metil_library->library_fps_display = (
      metil_library->library
    );
  } else {
    metil_library->library_fps_display = [
      metal_device
      newDefaultLibrary
    ];
  }

  metil_library->function_fragment_fps_display = [
    metil_library->library_fps_display
    newFunctionWithName: (
      @"metil_fps_display_fragment"
    )
  ];

  metil_library->function_vertex_fps_display = [
    metil_library->library_fps_display
    newFunctionWithName: (
      @"metil_fps_display_vertex"
    )
  ];
}

void metil_library_wireframe_initialize(
  struct metil_library* metil_library,
  id<MTLDevice> metal_device,
  id<MTLLibrary> library_wireframe
) {
  if (
    library_wireframe !=
    0x00
  ) {
    metil_library->library_wireframe = (
      library_wireframe
    );
  } else if (
    metil_library->library !=
    0x00
  ) {
    metil_library->library_wireframe = (
      metil_library->library
    );
  } else {
    metil_library->library_wireframe = [
      metal_device
      newDefaultLibrary
    ];
  }

  metil_library->function_fragment_wireframe = [
    metil_library->library_wireframe
    newFunctionWithName: (
      @"metil_wireframe_fragment"
    )
  ];

  metil_library->function_vertex_wireframe = [
    metil_library->library_wireframe
    newFunctionWithName: (
      @"metil_wireframe_vertex"
    )
  ];
}
