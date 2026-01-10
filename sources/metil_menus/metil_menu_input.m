#include <metil_menus/metil_menu_input.h>

#include <metil_input/metil_input.h>
#include <metil_input/metil_keycodes.h>
#include <metil_input/metil_input_map.h>
#include <metil_utilities/metil_stopwatch.h>

void metil_menu_poll_input(
  struct metil_menu* menu,
  struct metil_input* metil_input
) {
  if (
    menu->index_selected != -1
  ) {
    return;
  }

  unsigned long int delta = (
    metil_stopwatch_elapsed(
      &menu->stopwatch_input
    )
  );

  if (
    delta < metil_milliseconds_menu_input_delay
  ) {
    return;
  }

  if (
    metil_input->keydown_map[
      metil_keycode_space
    ] == 1 ||
    metil_input->controller_state.cross > 0.0f
  ) {
    metil_menu_select(
      menu
    );

    return;
  }

  unsigned char had_input = (
    0
  );

  if (
    metil_input->keydown_map[
      metil_keycode_up_arrow
    ] == 1 ||
    metil_input->controller_state.directional_up > 0.0f ||
    metil_input->controller_state.left_stick.y > 0.1f
  ) {
    had_input = (
      1
    );

    metil_menu_previous(
      menu
    );
  } else if (
    metil_input->keydown_map[
      metil_keycode_down_arrow
    ] == 1 ||
    metil_input->controller_state.directional_down > 0.0f ||
    metil_input->controller_state.left_stick.y < -0.1f
  ) {
    had_input = (
      1
    );

    metil_menu_next(
      menu
    );
  }

  if (
    had_input == 1
  ) {
    metil_stopwatch_start(
      &menu->stopwatch_input
    );
  }
}
