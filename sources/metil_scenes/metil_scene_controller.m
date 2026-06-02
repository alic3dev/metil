#include <metil_scenes/metil_scene_controller.h>

#include <metil.h>
#include <metil_scenes/metil_scene.h>

#include <clic3_memory.h>

struct metil_scene metil_scene_empty;

void metil_scene_controller_initialize(
  struct metil* metil,
  struct metil_scene_controller* metil_scene_controller
) {
  metil_scene_controller->length_on_scene_change = (
    0x00
  );

  metil_scene_controller->length_after_scene_change = (
    0x00
  );

  metil_scene_initialize(
    metil,
    &metil_scene_controller->scene
  );

  metil_scene_controller->on_scene_change = (
    clic3_memory_allocate_raw(
      0x00
    )
  );

  metil_scene_controller->on_scene_change_data = (
    clic3_memory_allocate_raw(
      0x00
    )
  );

  metil_scene_controller->after_scene_change = (
    clic3_memory_allocate_raw(
      0x00
    )
  );

  metil_scene_controller->after_scene_change_data = (
    clic3_memory_allocate_raw(
      0x00
    )
  );
}

void metil_scene_controller_scene_change(
  struct metil* metil,
  struct metil_scene_controller* metil_scene_controller,
  int scene_id
) {
  for (
    unsigned short int index_on_scene_change = (
      0x00
    );
    (
      index_on_scene_change <
      metil_scene_controller->length_on_scene_change
    );
    ++index_on_scene_change
  ) {
    metil_scene_controller->on_scene_change[
      index_on_scene_change
    ](
      metil,
      scene_id,
      metil_scene_controller->on_scene_change_data[
        index_on_scene_change
      ]
    );
  }

  for (
    unsigned short int index_after_scene_change = (
      0x00
    );
    (
      index_after_scene_change <
      metil_scene_controller->length_after_scene_change
    );
    ++index_after_scene_change
  ) {
    metil_scene_controller->after_scene_change[
      index_after_scene_change
    ](
      metil,
      scene_id,
      metil_scene_controller->after_scene_change_data[
        index_after_scene_change
      ]
    );
  }
}

void metil_scene_controller_on_scene_change_add(
  struct metil_scene_controller* metil_scene_controller,
  metil_scene_controller_on_scene_change on_scene_change,
  void* on_scene_change_data
) {
  metil_scene_controller->length_on_scene_change = (
    metil_scene_controller->length_on_scene_change +
    0x01
  );

  clic3_memory_reallocate_raw(
    &metil_scene_controller->on_scene_change,
    (
      sizeof(
        metil_scene_controller_on_scene_change
      ) *
      metil_scene_controller->length_on_scene_change
    )
  );

  clic3_memory_reallocate_raw(
    &metil_scene_controller->on_scene_change_data,
    (
      sizeof(
        void*
      ) *
      metil_scene_controller->length_on_scene_change
    )
  );

  metil_scene_controller->on_scene_change[
    metil_scene_controller->length_on_scene_change -
    0x01
  ] = (
    on_scene_change
  );

  metil_scene_controller->on_scene_change_data[
    metil_scene_controller->length_on_scene_change -
    0x01
  ] = (
    on_scene_change_data
  );
}

void metil_scene_controller_after_scene_change_add(
  struct metil_scene_controller* metil_scene_controller,
  metil_scene_controller_after_scene_change after_scene_change,
  void* after_scene_change_data
) {
  metil_scene_controller->length_after_scene_change = (
    metil_scene_controller->length_after_scene_change +
    0x01
  );

  clic3_memory_reallocate_raw(
    &metil_scene_controller->after_scene_change,
    (
      sizeof(
        metil_scene_controller_after_scene_change
      ) *
      metil_scene_controller->length_after_scene_change
    )
  );

  clic3_memory_reallocate_raw(
    &metil_scene_controller->after_scene_change_data,
    (
      sizeof(
        void*
      ) *
      metil_scene_controller->length_after_scene_change
    )
  );

  metil_scene_controller->after_scene_change[
    metil_scene_controller->length_after_scene_change -
    0x01
  ] = (
    after_scene_change
  );

  metil_scene_controller->after_scene_change_data[
    metil_scene_controller->length_after_scene_change -
    0x01
  ] = (
    after_scene_change_data
  );
}

void metil_scene_controller_destroy(
  struct metil* metil,
  struct metil_scene_controller* metil_scene_controller
) {
  metil_scene_destroy(
    metil,
    &metil_scene_controller->scene
  );

  clic3_memory_free_raw(
    metil_scene_controller->after_scene_change
  );

  clic3_memory_free_raw(
    metil_scene_controller->after_scene_change_data
  );

  clic3_memory_free_raw(
    metil_scene_controller->on_scene_change
  );

  clic3_memory_free_raw(
    metil_scene_controller->on_scene_change_data
  );
}
