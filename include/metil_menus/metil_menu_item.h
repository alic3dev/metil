#ifndef __metil_menus_metil_menu_item_h
#define __metil_menus_metil_menu_item_h

struct metil_menu_item;

typedef void (*metil_menu_item_on_action)(struct metil_menu_item*);

enum metil_menu_item_type {
  metil_menu_item_type_display = 0,
  metil_menu_item_type_submenu = 1,
  metil_menu_item_type_selection = 2,
  metil_menu_item_type_scroll = 3
};

enum metil_menu_item_action {
  metil_menu_item_action_none = 0,
  metil_menu_item_action_select = 1
};

struct metil_menu_item_data_scroll {
  unsigned int length;
  unsigned int index;
  unsigned char wrap;
};

struct metil_menu_item {
  enum metil_menu_item_type type;
  enum metil_menu_item_action action;

  void* data_menu_item;
  void* data;
};

void metil_menu_item_initialize(
  struct metil_menu_item*,
  enum metil_menu_item_type,
  enum metil_menu_item_action,
  void*
);

unsigned char metil_menu_item_scroll_next(
  struct metil_menu_item*
);

unsigned char metil_menu_item_scroll_previous(
  struct metil_menu_item*
);

void metil_menu_item_destroy(
  struct metil_menu_item*
);

#endif
