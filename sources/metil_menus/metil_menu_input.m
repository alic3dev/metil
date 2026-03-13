#include <metil_menus/metil_menu_input.h>

#include <metil_input/metil_input.h>
#include <metil_input/metil_keycodes.h>
#include <metil_input/metil_input_map.h>
#include <metil_utilities/metil_stopwatch.h>

void metil_menu_poll_input(
  struct metil_menu* metil_menu,
  struct metil_input* metil_input
) {
  if (
    metil_menu->index_selected != -1
  ) {
    return;
  }

  unsigned long int delta = (
    metil_stopwatch_elapsed(
      &metil_menu->stopwatch_input
    )
  );

  if (
    delta < metil_milliseconds_menu_input_delay
  ) {
    return;
  }

  enum metil_menu_item_action metil_menu_item_action = (
    metil_menu_item_action_none
  );

  enum metil_menu_item_type metil_menu_item_type = (
    metil_menu_item_type_display
  );

  struct metil_menu_item* metil_menu_item = (
    0
  );

  if (
    metil_menu->index_current < metil_menu->length_items
  ) {
    metil_menu_item = (
      &metil_menu->items[
        metil_menu->index_current
      ]
    );

    metil_menu_item_action = (
      metil_menu_item->action
    );

    metil_menu_item_type = (
      metil_menu_item->type
    );
  }

  if (
    (
      metil_menu_item_action == metil_menu_item_action_select
    ) && (
      metil_input->keydown_map[
        metil_keycode_space
      ] == 1 ||
      metil_input->controller_state.cross > 0.0f
    )
  ) {
    metil_menu_select(
      metil_menu
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
      metil_menu
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
      metil_menu
    );
  } else if (
    metil_menu_item_type == metil_menu_item_type_scroll
  ) {
    if (
      metil_input->keydown_map[
        metil_keycode_left_arrow
      ] == 1 ||
      metil_input->controller_state.directional_left > 0.0f ||
      metil_input->controller_state.left_stick.x < -0.1f
    ) {
      had_input = (
        1
      );

      metil_menu_item_scroll_previous(
        metil_menu_item
      );
    } else if (
      metil_input->keydown_map[
        metil_keycode_right_arrow
      ] == 1 ||
      metil_input->controller_state.directional_right > 0.0f ||
      metil_input->controller_state.left_stick.x > 0.1f
    ) {
      had_input = (
        1
      );

      metil_menu_item_scroll_next(
        metil_menu_item
      );
    }
  }

  if (
    had_input == 1
  ) {
    metil_stopwatch_start(
      &metil_menu->stopwatch_input
    );
  }
}
