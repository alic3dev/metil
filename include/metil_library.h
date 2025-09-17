#ifndef __metil_library_h
#define __metil_library_h

#include <MetalKit/MetalKit.h>

struct metil_library {
  id<MTLLibrary> library;
  id<MTLFunction> function_fragment;
  id<MTLFunction> function_vertex;
};

extern struct metil_library metil_library;

#endif
