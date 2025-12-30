#ifndef __metil_input_map_h
#define __metil_input_map_h

#include <metil_input/metil_keycodes.h>

#define metil_input_map_keydown_length metil_keycode_max_value + 1

extern unsigned char metil_input_map_keydown[
  metil_input_map_keydown_length
];

void metil_input_maps_initialize();

void metil_input_map_keydown_initialize();

#endif
