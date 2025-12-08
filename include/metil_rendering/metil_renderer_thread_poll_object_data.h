#ifndef __metil_renderer_thread_poll_object_data_h
#define __metil_renderer_thread_poll_object_data_h

#include <metil_rendering/camera/camera.h>

struct metil_renderer_thread_poll_object_data {
  struct metil_renderable* _Nonnull renderables;
  unsigned int length_renderables;
  matrix_float3x4* _Nonnull matrix_static_projection;
  matrix_float4x4* _Nonnull matrix_object_projection;
  matrix_float4x4* _Nonnull matrix_player_projection;
  struct metil_camera* _Nonnull camera;
};

#endif
