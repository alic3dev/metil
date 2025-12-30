#include <metil_input/metil_input_map.h>

#include <metil_input/metil_keycodes.h>

unsigned char metil_input_map_keydown[
  metil_input_map_keydown_length
];

void metil_input_maps_initialize() {
  metil_input_map_keydown_initialize();
}

void metil_input_map_keydown_initialize() {
  for (
    unsigned char index_keycode = 0;
    index_keycode <= metil_keycode_max_value;
    ++index_keycode
  ) {
    metil_input_map_keydown[
      index_keycode
    ] = 0;
  }
}
