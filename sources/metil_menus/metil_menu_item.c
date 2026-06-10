#include <metil_menus/metil_menu_item.h>

#include <clic3_memory.h>

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

  metil_menu_item->data_menu_item = (
    0x00
  );

  switch (
    metil_menu_item_type
  ) {
    case metil_menu_item_type_scroll: {
      metil_menu_item->data_menu_item = (
        clic3_memory_allocate_raw(
          sizeof(
            struct metil_menu_item_data_scroll
          )
        )
      );

      struct metil_menu_item_data_scroll* metil_menu_item_data_scroll = (
        metil_menu_item->data_menu_item
      );

      metil_menu_item_data_scroll->index = (
        0x00
      );

      metil_menu_item_data_scroll->length = (
        0x01
      );

      metil_menu_item_data_scroll->wrap = (
        0x01
      );

      break;
    }
    default: {
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
    metil_menu_item_data_scroll->index ==
    (
      metil_menu_item_data_scroll->length -
      0x01
    )
  ) {
    if (
      metil_menu_item_data_scroll->wrap ==
      0x00
    ) {
      return (
        0x01
      );
    }

    metil_menu_item_data_scroll->index = (
      0x00
    );
  } else {
    metil_menu_item_data_scroll->index = (
      metil_menu_item_data_scroll->index +
      0x01
    );
  }

  return (
    0x00
  );
}

unsigned char metil_menu_item_scroll_previous(
  struct metil_menu_item* metil_menu_item_scroll
) {
  struct metil_menu_item_data_scroll* metil_menu_item_data_scroll = (
    metil_menu_item_scroll->data_menu_item
  );

  if (
    metil_menu_item_data_scroll->index ==
    0x00
  ) {
    if (
      metil_menu_item_data_scroll->wrap ==
      0x00
    ) {
      return (
        0x01
      );
    }

    metil_menu_item_data_scroll->index = (
      metil_menu_item_data_scroll->length -
      0x01
    );
  } else {
    metil_menu_item_data_scroll->index = (
      metil_menu_item_data_scroll->index -
      0x01
    );
  }

  return (
    0x00
  );
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
