#ifndef __metil_tools_metil_editor_metil_editor_scene_data_h
#define __metil_tools_metil_editor_metil_editor_scene_data_h

#include <metil_editor_mode.h>

struct metil_editor_scene_data {
  struct math_c_vector3_float position;

  struct math_c_vector3_float position_player;

  unsigned char movement_free;

  unsigned char mode;

  char* path_export;
};

#endif
