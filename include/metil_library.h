#ifndef __metil_library_h
#define __metil_library_h

#include <MetalKit/MetalKit.h>

struct metil_library {
  id<MTLLibrary> library;

  id<MTLFunction> function_fragment;
  id<MTLFunction> function_vertex;

  id<MTLLibrary> library_fps_display;
  
  id<MTLFunction> function_fragment_fps_display;
  id<MTLFunction> function_vertex_fps_display;
};

extern struct metil_library metil_library;

#endif
