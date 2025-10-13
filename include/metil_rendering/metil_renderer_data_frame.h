#ifndef __metil_renderer_data_frame_h
#define __metil_renderer_data_frame_h

#include <clic3_vector.h>

struct metil_renderer_data_frame {
  unsigned int frame;

  struct clic3_vector3_float rotation_camera;
  struct clic3_vector3_float position_player;

  float brightness;
  float brightness_text;
};

#endif
