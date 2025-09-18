#include <metil_menus/menu.h>

#include <metil_input/controller.h>
#include <metil_input/keycodes.h>
#include <metil_input/map.h>
#include <metil_menus/menu_item.h>

#include <stdlib.h>
#include <sys/time.h>

void metil_menu_initialize(
  struct metil_menu* menu
) {
  menu->index_current = 0;

  menu->length_items = 0;
  menu->items = malloc(
    sizeof(struct metil_menu_item) *
    menu->length_items
  );

  menu->index_selected = -1;
  menu->handled = 0;

  menu->wrap = 1;

  metil_stopwatch_start(
    &menu->stopwatch_input
  );
}

void metil_menu_poll_input(
  struct metil_menu* menu
) {
  if (
    menu->index_selected != -1
  ) {
    return;
  }

  if (
    metil_input_map_keydown[
      metil_keycode_space
    ] == 1 ||
    metil_controller_state.button_cross > 0.0f
  ) {
    metil_menu_select(
      menu
    );

    return;
  }

  unsigned long int delta = metil_stopwatch_elapsed(
    &menu->stopwatch_input
  );

  if (
    delta < metil_milliseconds_menu_input_delay
  ) {
    return;
  }

  unsigned char had_input = 0;

  if (
    metil_input_map_keydown[
      metil_keycode_up_arrow
    ] == 1 || 
    metil_controller_state.button_directional_up > 0.0f ||
    metil_controller_state.left_stick.y > 0.1f
  ) {
    had_input = 1;

    metil_menu_previous(
      menu
    );
  } else if (
    metil_input_map_keydown[
      metil_keycode_down_arrow
    ] == 1 || 
    metil_controller_state.button_directional_down > 0.0f ||
    metil_controller_state.left_stick.y < -0.1f
  ) {
    had_input = 1;

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

void metil_menu_item_add(
  struct metil_menu* menu,
  enum metil_menu_item_type type,
  enum metil_menu_item_action action,
  void* data
) {
  menu->length_items = (
    menu->length_items + 1
  );

  menu->items = realloc(
    menu->items,
    sizeof(struct metil_menu_item) *
    menu->length_items
  );

  metil_menu_item_initialize(
    &menu->items[
      menu->length_items - 1
    ],
    type,
    action,
    data
  );
}

void metil_menu_select(
  struct metil_menu* menu
) {
  if (menu->length_items == 0) {
    return;
  }

  menu->index_selected = menu->index_current;
}

unsigned char metil_menu_next(
  struct metil_menu* menu
) {
  if (
    menu->index_current == menu->length_items - 1
  ) {
    if (menu->wrap == 0) {
      return 1;
    }

    menu->index_current = 0;
  } else {
    menu->index_current = (
      menu->index_current + 1
    );
  }

  return 0;
}

unsigned char metil_menu_previous(
  struct metil_menu* menu
) {
  if (
    menu->index_current == 0
  ) {
    if (menu->wrap == 0) {
      return 1;
    }

    menu->index_current = (
      menu->length_items - 1
    );
  } else {
    menu->index_current = (
      menu->index_current - 1
    );
  }

  return 0;
}

void metil_menu_destroy(
  struct metil_menu* menu
) {
  free(menu->items);
}
