#include <metil_input/metil_input.h>

#include <metil_input/metil_controller.h>
#include <metil_input/metil_controller_state.h>
#include <metil_input/metil_cursor.h>
#include <metil_input/metil_input_map.h>

void metil_input_initialize(
  struct metil_input* metil_input
) {
  metil_controller_initialize(
    &metil_input->controller
  );

  metil_controller_state_initialize(
    &metil_input->controller_state
  );

  metil_cursor_initialize(
    &metil_input->cursor
  );

  metil_input_keydown_map_initialize(
    metil_input->keydown_map
  );
}
