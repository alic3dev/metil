#include <metil_input/metil_input_map.h>

#include <metil_input/metil_keycodes.h>

void metil_input_keydown_map_initialize(
  unsigned char* metil_input_keydown_map
) {
  for (
    unsigned char index_keycode = (
      0x00
    );
    (
      index_keycode <=
      metil_keycode_max_value
    );
    ++index_keycode
  ) {
    metil_input_keydown_map[
      index_keycode
    ] = (
      0x00
    );
  }
}
