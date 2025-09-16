#include <metil_scenes/scene_controller.h>

#include <stdlib.h>

struct metil_scene_controller_structure metil_scene_controller = {
  .length_on_scene_change = 0,
  .on_scene_change = (void*)0,
  .on_scene_change_data = (void*)0
};

void metil_scene_controller_initialize() {
  metil_scene_controller.on_scene_change = malloc(
    sizeof(metil_scene_controller_on_scene_change) *
    metil_scene_controller.length_on_scene_change
  );
  metil_scene_controller.on_scene_change_data = malloc(
    sizeof(void*) *
    metil_scene_controller.length_on_scene_change
  );
}

void metil_scene_controller_scene_change(
  enum metil_scene_id scene_id
) {
  for (
    unsigned short int index_on_scene_change = 0;
    index_on_scene_change < metil_scene_controller.length_on_scene_change;
    ++index_on_scene_change
  ) {
    metil_scene_controller.on_scene_change[
      index_on_scene_change
    ](
      scene_id,
      metil_scene_controller.on_scene_change_data[
        index_on_scene_change
      ]
    );
  }
}

void metil_scene_controller_on_scene_change_add(
  metil_scene_controller_on_scene_change on_scene_change,
  void* on_scene_change_data
) {
  metil_scene_controller.length_on_scene_change = (
    metil_scene_controller.length_on_scene_change + 1
  );

  metil_scene_controller.on_scene_change = realloc(
    metil_scene_controller.on_scene_change,
    sizeof(metil_scene_controller_on_scene_change) *
    metil_scene_controller.length_on_scene_change
  );

  metil_scene_controller.on_scene_change_data = realloc(
    metil_scene_controller.on_scene_change_data,
    sizeof(void*) *
    metil_scene_controller.length_on_scene_change
  );

  metil_scene_controller.on_scene_change[
    metil_scene_controller.length_on_scene_change - 1
  ] = on_scene_change;

  metil_scene_controller.on_scene_change_data[
    metil_scene_controller.length_on_scene_change - 1
  ] = on_scene_change_data;
}

void metil_scene_controller_destroy() {
  free(metil_scene_controller.on_scene_change);
  free(metil_scene_controller.on_scene_change_data);
}
