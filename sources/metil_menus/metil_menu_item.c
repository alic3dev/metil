#include <metil_menus/metil_menu_item.h>

void metil_menu_item_initialize(
  struct metil_menu_item* menu_item,
  enum metil_menu_item_type type,
  enum metil_menu_item_action action,
  void* data
) {
  menu_item->type = type;
  menu_item->action = action;
  menu_item->data = data;
}
