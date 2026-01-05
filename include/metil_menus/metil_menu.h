#ifndef __metil_menus_metil_menu_h
#define __metil_menus_metil_menu_h

#include <metil_input/metil_controller_state/metil_controller_state_structure.h>
#include <metil_input/metil_input_map.h>
#include <metil_menus/metil_menu_item.h>
#include <metil_utilities/metil_stopwatch.h>

#define metil_milliseconds_menu_input_delay 200

struct metil_menu;

struct metil_menu {
  unsigned char index_current;
  signed int index_selected;

  unsigned char handled;

  unsigned char length_items;
  struct metil_menu_item* _Nonnull items;

  unsigned char wrap;

  struct metil_stopwatch stopwatch_input;
};

void metil_menu_initialize(
  struct metil_menu*
);

void metil_menu_item_add(
  struct metil_menu*,
  enum metil_menu_item_type,
  enum metil_menu_item_action,
  void*
);

void metil_menu_poll_input(
  struct metil_menu*,
  struct metil_controller_state*,
  unsigned char[
    metil_input_map_keydown_length
  ]
);

void metil_menu_select(
  struct metil_menu*
);

unsigned char metil_menu_next(
  struct metil_menu*
);

unsigned char metil_menu_previous(
  struct metil_menu*
);

void metil_menu_destroy(
  struct metil_menu*
);

#endif
