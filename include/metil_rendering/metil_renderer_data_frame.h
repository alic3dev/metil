#ifndef __metil_rendering_metil_renderer_data_frame_h
#define __metil_rendering_metil_renderer_data_frame_h

#ifndef __METAL_VERSION__
#include <metil.h>
#endif

#include <math_c_vector.h>

struct metil_renderer_data_frame {
  unsigned int frame;

  unsigned long int time;
  unsigned long int time_elapsed;
  unsigned long int time_delta;

  struct math_c_vector3_float rotation_camera;
  struct math_c_vector3_float position_player;

  float brightness;
  float brightness_text;

  struct math_c_vector2_float size_viewport;
};

#ifndef __METAL_VERSION__
typedef void (*metil_renderer_data_frame_poll_function)(
  struct metil*,
  void*,
  unsigned int
);

void metil_renderer_data_frame_poll(
  struct metil*,
  void*,
  unsigned int
);
#endif

#endif
