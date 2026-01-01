#include <metil_scenes/metil_scene_controller.h>

#include <metil.h>
#include <metil_scenes/metil_scene.h>

#include <stdlib.h>

struct metil_scene metil_scene_empty;

void metil_scene_controller_initialize(
  struct metil* metil,
  struct metil_scene_controller* metil_scene_controller
) {
  metil_scene_controller->length_on_scene_change = (
    0
  );

  metil_scene_controller->on_scene_change = (
    (void*) 0
  );

  metil_scene_controller->on_scene_change_data = (
    (void*) 0
  );

  metil_scene_controller->length_after_scene_change = (
    0
  );

  metil_scene_controller->after_scene_change = (
    (void*) 0
  );
  
  metil_scene_controller->after_scene_change_data = (
    (void*) 0
  );

  metil_scene_initialize(
    metil,
    &metil_scene_controller->scene
  );

  metil_scene_controller->on_scene_change = malloc(
    sizeof(metil_scene_controller_on_scene_change) *
    metil_scene_controller->length_on_scene_change
  );

  metil_scene_controller->on_scene_change_data = malloc(
    sizeof(void*) *
    metil_scene_controller->length_on_scene_change
  );

  metil_scene_controller->after_scene_change = malloc(
    sizeof(metil_scene_controller_on_scene_change) *
    metil_scene_controller->length_on_scene_change
  );

  metil_scene_controller->after_scene_change_data = malloc(
    sizeof(void*) *
    metil_scene_controller->length_on_scene_change
  );
}

void metil_scene_controller_scene_change(
  struct metil* metil,
  struct metil_scene_controller* metil_scene_controller,
  int scene_id
) {
  for (
    unsigned short int index_on_scene_change = 0;
    index_on_scene_change < metil_scene_controller->length_on_scene_change;
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
    unsigned short int index_after_scene_change = 0;
    index_after_scene_change < metil_scene_controller->length_after_scene_change;
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
    metil_scene_controller->length_on_scene_change + 1
  );

  metil_scene_controller->on_scene_change = realloc(
    metil_scene_controller->on_scene_change,
    sizeof(metil_scene_controller_on_scene_change) *
    metil_scene_controller->length_on_scene_change
  );

  metil_scene_controller->on_scene_change_data = realloc(
    metil_scene_controller->on_scene_change_data,
    sizeof(void*) *
    metil_scene_controller->length_on_scene_change
  );

  metil_scene_controller->on_scene_change[
    metil_scene_controller->length_on_scene_change - 1
  ] = on_scene_change;

  metil_scene_controller->on_scene_change_data[
    metil_scene_controller->length_on_scene_change - 1
  ] = on_scene_change_data;
}

void metil_scene_controller_after_scene_change_add(
  struct metil_scene_controller* metil_scene_controller,
  metil_scene_controller_after_scene_change after_scene_change,
  void* after_scene_change_data
) {
  metil_scene_controller->length_after_scene_change = (
    metil_scene_controller->length_after_scene_change + 1
  );

  metil_scene_controller->after_scene_change = realloc(
    metil_scene_controller->after_scene_change,
    sizeof(metil_scene_controller_after_scene_change) *
    metil_scene_controller->length_after_scene_change
  );

  metil_scene_controller->after_scene_change_data = realloc(
    metil_scene_controller->after_scene_change_data,
    sizeof(void*) *
    metil_scene_controller->length_after_scene_change
  );

  metil_scene_controller->after_scene_change[
    metil_scene_controller->length_after_scene_change - 1
  ] = after_scene_change;

  metil_scene_controller->after_scene_change_data[
    metil_scene_controller->length_after_scene_change - 1
  ] = after_scene_change_data;
}

void metil_scene_controller_destroy(
  struct metil* metil,
  struct metil_scene_controller* metil_scene_controller
) {
  metil_scene_destroy(
    metil,
    &metil_scene_controller->scene
  );

  free(
    metil_scene_controller->after_scene_change
  );

  free(
    metil_scene_controller->after_scene_change_data
  );

  free(
    metil_scene_controller->on_scene_change
  );

  free(
    metil_scene_controller->on_scene_change_data
  );
}
