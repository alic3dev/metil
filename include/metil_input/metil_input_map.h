#ifndef __metil_input_metil_input_map_h
#define __metil_input_metil_input_map_h

#include <metil_input/metil_keycodes.h>

#define metil_input_map_keydown_length metil_keycode_max_value + 1

void metil_input_keydown_map_initialize(
  unsigned char*
);

#endif
