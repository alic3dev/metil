#include <metil_scenes/metil_scene.h>

#include <metil_input/metil_cursor.h>
#include <metil_object.h>
#include <metil_player/metil_player.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_utilities/metil_time.h>

#include <clic3_memory.h>

#include <stdlib.h>

void metil_scene_initialize(
  struct metil* metil,
  struct metil_scene* scene
) {
  metil_scene_initialize_with_renderables(
    metil,
    scene,
    0
  );
}

void metil_scene_initialize_with_renderables(
  struct metil* metil,
  struct metil_scene* scene,
  unsigned int length_renderables
) {
  metil_player_initialize(
    &scene->player,
    &metil->player_defaults
  );

  scene->length_renderables = length_renderables;
  scene->renderables = malloc(
    sizeof(struct metil_renderable) *
    scene->length_renderables
  );

  scene->length_textures = 0;
  scene->textures = malloc(
    sizeof(id<MTLTexture>) *
    scene->length_textures
  );

  scene->player.position.x = 0.0f;
  scene->player.position.y = 0.0f;
  scene->player.position.z = 0.0f;

  scene->player.rotation.x = 0.0f;
  scene->player.rotation.y = 0.0f;
  scene->player.rotation.z = 0.0f;

  metil->input.cursor.delta.x = 0.0f;
  metil->input.cursor.delta.y = 0.0f;

  scene->poll = metil_scene_poll_default;
  scene->poll_input = metil_scene_poll_input_default;
  scene->destroy = metil_scene_destroy_default;

  scene->time_initial = metil_time_milliseconds_get();

  scene->time = 0;
  scene->time_previous = 0;
  scene->time_delta = 0;
  scene->time_elapsed = 0;

  scene->time_input = 0;
  scene->time_input_delta = 0;
  scene->time_input_previous = 0;

  scene->loading = 0;

  scene->data = (void*)0;
}

void metil_scene_renderables_set_length(
  struct metil_scene* _Nonnull scene,
  unsigned int length_renderables
) {
  scene->length_renderables = length_renderables;
  scene->renderables = realloc(
    scene->renderables,
    sizeof(struct metil_renderable) *
    scene->length_renderables
  );
}

void metil_scene_poll_input(
  struct metil* metil,
  struct metil_scene* scene,
  unsigned long int time
) {
  scene->time_elapsed = time - scene->time_initial;

  scene->time_input_previous = scene->time;
  scene->time_input = time;
  scene->time_input_delta = scene->time_input_previous == 0 ? 0 : (
    scene->time_input -
    scene->time_input_previous
  );

  scene->poll_input(
    metil,
    scene
  );
}

void metil_scene_poll(
  struct metil* metil,
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
    metil,
    scene
  );
}

void metil_scene_destroy(
  struct metil* metil,
  struct metil_scene* scene
) {
  scene->destroy(
    metil,
    scene
  );
}

void metil_scene_poll_input_default(
  struct metil* metil,
  struct metil_scene* scene
) {
  scene->player.poll_input(
    metil,
    &scene->player,
    scene->time_input,
    scene->time_input_delta
  );
}

void metil_scene_poll_default(
  struct metil* metil,
  struct metil_scene* scene
) {
  scene->player.poll(
    metil,
    &scene->player
  );
}

void metil_scene_destroy_default(
  struct metil* metil,
  struct metil_scene* scene
) {
  for (
    unsigned int index_renderable = 0;
    index_renderable < scene->length_renderables;
    ++index_renderable
  ) {
    metil_renderable_destroy(
      metil,
      &(
        scene->renderables[
          index_renderable
        ]
      )
    );
  }

  clic3_memory_free(
    scene->renderables
  );

  for (
    unsigned int index_texture = 0;
    index_texture < scene->length_textures;
    ++index_texture
  ) {
    [
      scene->textures[
        index_texture
      ]
      release
    ];
  }

  clic3_memory_free(
    scene->textures
  );

  scene->player.destroy(
    metil,
    &scene->player
  );

  clic3_memory_free(
    scene->data
  );
}
