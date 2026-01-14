#include <metil_menus/metil_menu_item.h>

#include <clic3_memory.h>

#include <stdlib.h>

void metil_menu_item_initialize(
  struct metil_menu_item* metil_menu_item,
  enum metil_menu_item_type metil_menu_item_type,
  enum metil_menu_item_action metil_menu_item_action,
  void* data
) {
  metil_menu_item->action = (
    metil_menu_item_action
  );

  metil_menu_item->data = (
    data
  );
  
  switch (
    metil_menu_item_type
  ) {
    case metil_menu_item_type_scroll: {
      metil_menu_item->data_menu_item = (
        malloc(
          sizeof(
            struct metil_menu_item_data_scroll
          )
        )
      );

      struct metil_menu_item_data_scroll* metil_menu_item_data_scroll = (
        metil_menu_item->data_menu_item
      );

      metil_menu_item_data_scroll->index = 0;
      metil_menu_item_data_scroll->length = 1;
      metil_menu_item_data_scroll->wrap = 1;

      break;
    }
    default: {
      metil_menu_item->data_menu_item = (
        (void*) 0
      );

      break;
    }
  }
  
  metil_menu_item->type = (
    metil_menu_item_type
  );
}

unsigned char metil_menu_item_scroll_next(
  struct metil_menu_item* metil_menu_item_scroll
) {
  struct metil_menu_item_data_scroll* metil_menu_item_data_scroll = (
    metil_menu_item_scroll->data_menu_item
  );

  if (
    metil_menu_item_data_scroll->index == metil_menu_item_data_scroll->length - 1
  ) {
    if (
      metil_menu_item_data_scroll->wrap == 0
    ) {
      return 1;
    }

    metil_menu_item_data_scroll->index = 0;
  } else {
    metil_menu_item_data_scroll->index = (
      metil_menu_item_data_scroll->index + 1
    );
  }

  return 0;
}

unsigned char metil_menu_item_scroll_previous(
  struct metil_menu_item* metil_menu_item_scroll
) {
  struct metil_menu_item_data_scroll* metil_menu_item_data_scroll = (
    metil_menu_item_scroll->data_menu_item
  );

  if (
    metil_menu_item_data_scroll->index == 0
  ) {
    if (
      metil_menu_item_data_scroll->wrap == 0
    ) {
      return 1;
    }

    metil_menu_item_data_scroll->index = (
      metil_menu_item_data_scroll->length - 1
    );
  } else {
    metil_menu_item_data_scroll->index = (
      metil_menu_item_data_scroll->index - 1
    );
  }

  return 0;
}

void metil_menu_item_destroy(
  struct metil_menu_item* metil_menu_item
) {
  clic3_memory_free(
    metil_menu_item->data
  );

  clic3_memory_free(
    metil_menu_item->data_menu_item
  );
}
