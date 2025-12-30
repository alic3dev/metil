#ifndef __metil_menus_menu_item_h
#define __metil_menus_menu_item_h

struct metil_menu_item;

typedef void (*metil_menu_item_on_action)(struct metil_menu_item*);

enum metil_menu_item_type {
  metil_menu_item_type_display,
  metil_menu_item_type_submenu,
  metil_menu_item_type_selection
};

enum metil_menu_item_action {
  metil_menu_item_action_none,
  metil_menu_item_action_select
};

struct metil_menu_item {
  enum metil_menu_item_type type;
  enum metil_menu_item_action action;
  void* data;
};

void metil_menu_item_initialize(
  struct metil_menu_item*,
  enum metil_menu_item_type,
  enum metil_menu_item_action,
  void*
);

#endif
