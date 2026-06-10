#include <metil_scenes/metil_scene.h>

#include <metil_input/metil_controller.h>
#include <metil_input/metil_controller_state.h>
#include <metil_input/metil_cursor.h>
#include <metil_object.h>
#include <metil_player/metil_player.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_utilities/metil_time.h>

#include <clic3_memory.h>

#include <Metal/MTLTexture.h>

void metil_scene_initialize(
  struct metil* metil,
  struct metil_scene* scene
) {
  metil_scene_initialize_with_renderables_textures(
    metil,
    scene,
    0x00,
    0x00
  );
}

void metil_scene_initialize_with_renderables(
  struct metil* metil,
  struct metil_scene* scene,
  unsigned int length_renderables
) {
  metil_scene_initialize_with_renderables_textures(
    metil,
    scene,
    length_renderables,
    0x00
  );
}

void metil_scene_initialize_with_textures(
  struct metil* metil,
  struct metil_scene* scene,
  unsigned int length_textures
) {
  metil_scene_initialize_with_renderables_textures(
    metil,
    scene,
    0x00,
    length_textures
  );
}

void metil_scene_initialize_with_renderables_textures(
  struct metil* metil,
  struct metil_scene* scene,
  unsigned int length_renderables,
  unsigned int length_textures
) {
  metil_player_initialize(
    &scene->player,
    &metil->player_defaults
  );

  scene->length_renderables = (
    length_renderables
  );

  scene->renderables = (
    clic3_memory_allocate_raw(
      sizeof(
        struct metil_renderable
      ) *
      scene->length_renderables
    )
  );

  scene->length_textures = (
    length_textures
  );

  scene->textures = (
    clic3_memory_allocate_raw(
      scene->length_textures *
      sizeof(
        id<MTLTexture>
      )
    )
  );

  scene->player.position.x = (
    0x00
  );

  scene->player.position.y = (
    0x00
  );

  scene->player.position.z = (
    0x00
  );

  scene->player.rotation.x = (
    0x00
  );

  scene->player.rotation.y = (
    0x00
  );

  scene->player.rotation.z = (
    0x00
  );

  metil->input.cursor.delta.x = (
    0x00
  );

  metil->input.cursor.delta.y = (
    0x00
  );

  scene->poll = (
    metil_scene_poll_default
  );

  scene->poll_input = (
    metil_scene_poll_input_default
  );

  scene->destroy = (
    metil_scene_destroy_default
  );

  scene->time_initial = (
    metil_time_milliseconds_get()
  );

  scene->time = (
    0x00
  );

  scene->time_previous = (
    0x00
  );

  scene->time_delta = (
    0x00
  );

  scene->time_elapsed = (
    0x00
  );

  scene->time_input = (
    0x00
  );

  scene->time_input_delta = (
    0x00
  );

  scene->time_input_previous = (
    0x00
  );

  scene->loading = (
    0x00
  );

  scene->data = (
    0x00
  );
}

void metil_scene_renderables_set_length(
  struct metil_scene* _Nonnull scene,
  unsigned int length_renderables
) {
  scene->length_renderables = (
    length_renderables
  );

  clic3_memory_reallocate_raw(
    &scene->renderables,
    (
      sizeof(
        struct metil_renderable
      ) *
      scene->length_renderables
    )
  );
}

void metil_scene_poll_input(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  unsigned long int time = (
    metil_time_milliseconds_get()
  );

  metil_scene->time_elapsed = (
    time -
    metil_scene->time_initial
  );

  metil_scene->time_input_previous = (
    metil_scene->time
  );

  metil_scene->time_input = time;

  metil_scene->time_input_delta = (
    (
      metil_scene->time_input_previous ==
      0x00
    )
    ? 0x00
    : (
      metil_scene->time_input -
      metil_scene->time_input_previous
    )
  );

  metil_controller_poll(
    &metil->input.controller
  );

  metil_controller_state_poll(
    &metil->input.controller,
    &metil->input.controller_state
  );

  metil_scene->poll_input(
    metil,
    metil_scene
  );
}

void metil_scene_poll(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  metil_scene_poll_input(
    metil,
    metil_scene
  );

  unsigned long int time = (
    metil_time_milliseconds_get()
  );

  metil_scene->time_previous = (
    metil_scene->time
  );

  metil_scene->time = (
    time
  );

  metil_scene->time_delta = (
    (
      metil_scene->time_previous ==
      0x00
    )
    ? 0x00
    : (
      metil_scene->time -
      metil_scene->time_previous
    )
  );

  metil_scene->poll(
    metil,
    metil_scene
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
    unsigned int index_renderable = (
      0x00
    );
    (
      index_renderable <
      scene->length_renderables
    );
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

  clic3_memory_free_raw(
    scene->renderables
  );

  for (
    unsigned int index_texture = (
      0x00
    );
    (
      index_texture <
      scene->length_textures
    );
    ++index_texture
  ) {
    [
      scene->textures[
        index_texture
      ]
      release
    ];
  }

  clic3_memory_free_raw(
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
