#include <metil_scenes/scene.h>

#include <metil_input/cursor.h>
#include <metil_object.h>
#include <metil_player.h>

#include <stdlib.h>

void metil_scene_initialize(
  struct metil_scene* scene,
  id<MTLDevice> metal_kit_device
) {
  scene->metal_kit_device = metal_kit_device;

  metil_player_initialize(
    &scene->player
  );

  scene->length_objects = 0;
  scene->objects = malloc(
    sizeof(struct metil_object*) *
    scene->length_objects
  );

  scene->type = metil_scene_type_unknown;
  scene->id = -1;

  scene->player.position.x = 0.0f;
  scene->player.position.y = 0.0f;
  scene->player.position.z = 0.0f;

  scene->player.rotation.x = 0.0f;
  scene->player.rotation.y = 0.0f;
  scene->player.rotation.z = 0.0f;

  metil_input_delta_cursor.x = 0.0f;
  metil_input_delta_cursor.y = 0.0f;

  scene->poll = metil_scene_poll_default;
  scene->poll_input = metil_scene_poll_input_default;
  scene->destroy = metil_scene_destroy_default;

  scene->time = 0;
  scene->time_previous = 0;

  scene->time_input = 0;
  scene->time_input_previous = 0;

  scene->loading = 0;

  scene->rendering_properties.brightness = 1.0f;
  scene->rendering_properties.brightness_text = 1.0f;

  scene->data = (void*)0;
}

void metil_scene_poll_input(
  struct metil_scene* scene,
  unsigned long int time
) {
  scene->time_input_previous = scene->time;
  scene->time_input = time;
  scene->time_input_delta = scene->time_input_previous == 0 ? 0 : (
    scene->time_input -
    scene->time_input_previous
  );

  scene->poll_input(
    scene
  );
}

void metil_scene_poll(
  struct metil_scene* scene,
  unsigned long int time
) {
  scene->time_previous = scene->time;
  scene->time = time;
  scene->time_delta = scene->time_previous == 0 ? 0 : (
    scene->time -
    scene->time_previous
  );

  scene->poll(
    scene
  );
}

void metil_scene_destroy(
  struct metil_scene* scene
) {
  scene->destroy(
    scene
  );
}

void metil_scene_poll_input_default(
  struct metil_scene* scene
) {
  scene->player.poll_input(
    &scene->player,
    scene->time
  );
}

void metil_scene_poll_default(
  struct metil_scene* scene
) {
  scene->player.poll(
    &scene->player
  );
}

void metil_scene_destroy_default(
  struct metil_scene* scene
) {
  for (
    unsigned short int index_object = 0;
    index_object < scene->length_objects;
    ++index_object
  ) {
    metil_object_destroy(
      scene->objects[index_object]
    );

    free(scene->objects[index_object]);
  }

  free(scene->objects);

  for (
    unsigned short int index_texture = 0;
    index_texture < scene->length_textures;
    ++index_texture
  ) {
    [scene->textures[index_texture] release];
  }
  free(scene->textures);

  scene->player.destroy(
    &scene->player
  );

  if (
    scene->data != (void*)0
  ) {
    free(scene->data);
  }
}
