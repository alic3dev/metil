#ifndef __metil_library_h
#define __metil_library_h

#include <Metal/MTLLibrary.h>

struct metil_library {
  _Nonnull id<MTLLibrary> library;
  _Nonnull id<MTLFunction> function_fragment;
  _Nonnull id<MTLFunction> function_vertex;

  _Nonnull id<MTLLibrary> library_fps_display;
  _Nullable id<MTLFunction> function_fragment_fps_display;
  _Nullable id<MTLFunction> function_vertex_fps_display;

  _Nonnull id<MTLLibrary> library_wireframe;
  _Nullable id<MTLFunction> function_fragment_wireframe;
  _Nullable id<MTLFunction> function_vertex_wireframe;
};

void metil_library_initialize(
  struct metil_library* _Nonnull,
  _Nonnull id<MTLDevice>,
  NSString* _Nonnull,
  NSString* _Nonnull
);

void metil_library_fps_display_initialize(
  struct metil_library* _Nonnull,
  _Nonnull id<MTLDevice>,
  _Nullable id<MTLLibrary>
);

void metil_library_wireframe_initialize(
  struct metil_library* _Nonnull,
  _Nonnull id<MTLDevice>,
  _Nullable id<MTLLibrary>
);

#endif
