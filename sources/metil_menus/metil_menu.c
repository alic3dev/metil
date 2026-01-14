#include <metil_menus/metil_menu.h>

#include <metil_menus/metil_menu_item.h>
#include <metil_utilities/metil_stopwatch.h>

#include <clic3_memory.h>

#include <stdlib.h>
#include <sys/time.h>

void metil_menu_initialize(
  struct metil_menu* menu
) {
  menu->index_current = 0;

  menu->length_items = 0;
  menu->items = malloc(
    sizeof(
      struct metil_menu_item
    ) *
    menu->length_items
  );

  menu->index_selected = -1;
  menu->handled = 0;

  menu->wrap = 1;

  metil_stopwatch_start(
    &menu->stopwatch_input
  );
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
  if (
    menu->length_items == 0 ||
    menu->index_current > menu->length_items ||
    menu->items[
      menu->index_current
    ].action != metil_menu_item_action_select
  ) {
    return;
  }

  menu->index_selected = (
    menu->index_current
  );
}

unsigned char metil_menu_next(
  struct metil_menu* menu
) {
  if (
    menu->index_current == menu->length_items - 1
  ) {
    if (
      menu->wrap == 0
    ) {
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
    if (
      menu->wrap == 0
    ) {
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
  struct metil_menu* metil_menu
) {
  for (
    unsigned char index_metil_menu_item = 0;
    index_metil_menu_item < metil_menu->length_items;
    ++index_metil_menu_item
  ) {
    metil_menu_item_destroy(
      &metil_menu->items[
        index_metil_menu_item
      ]
    );
  }

  clic3_memory_free(
    metil_menu->items
  );
}
