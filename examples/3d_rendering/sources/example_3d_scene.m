#include <example_3d_scene.h>

#include <metil_mesh/mesh_box.h>
#include <metil_object.h>
#include <metil_player.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/scene.h>

#include <clic3_vector.h>

#include <math.h>
#include <stdlib.h>

void example_3d_scene_initialize(
  struct metil_scene* scene,
  id<MTLDevice> metal_kit_device
) {
  metil_scene_initialize(
    scene,
    metal_kit_device
  );

  scene->player.poll_input = metil_player_poll_input_null;

  scene->type = metil_scene_type_game;
  scene->id = 0;

  scene->poll = example_3d_scene_poll;

  scene->length_objects = 100;
  scene->objects = realloc(
    scene->objects,
    sizeof(struct metil_object*) *
    scene->length_objects
  );

  for (
    unsigned char index_object = 0;
    index_object < scene->length_objects;
    ++index_object
  ) {
    scene->objects[
      index_object
    ] = malloc(
      sizeof(struct metil_object)
    );

    metil_object_initialize(
      scene->objects[
        index_object
      ]
    );

    metil_mesh_box_initialize(
      &scene->objects[
        index_object
      ]->mesh, (struct clic3_vector3_float) {
        .x = 0.1f,
        .y = 0.1f,
        .z = 0.1f
      }
    );

    scene->objects[
      index_object
    ]->vertices = [metal_kit_device
      newBufferWithBytes: scene->objects[
        index_object
      ]->mesh.vertices
      length: scene->objects[
        index_object
      ]->mesh.length_vertices * sizeof(
        struct clic3_vector4_float
      )
      options: MTLResourceStorageModeShared
    ];

    scene->objects[
      index_object
    ]->indices = [metal_kit_device
      newBufferWithBytes: scene->objects[
        index_object
      ]->mesh.indices
      length: scene->objects[
        index_object
      ]->mesh.length_indices * sizeof(
        unsigned int
      )
      options: MTLResourceStorageModeShared
    ];

    scene->objects[
      index_object
    ]->data = [metal_kit_device
      newBufferWithLength: sizeof(struct metil_renderer_data_object)
      options: MTLResourceStorageModeShared
    ];

    struct metil_renderer_data_object* data_object = scene->objects[
      index_object
    ]->data.contents;

    data_object->id = index_object;
    data_object->color.x = (
      (float) (index_object % 10) / 10.0f
    );
    data_object->color.y = (
      (float) ((index_object + 3) % 10) / 10.0f
    );
    data_object->color.z = (
      (float) ((index_object + 5) % 10) / 10.0f
    );
    data_object->color.w = 1.0f;

    scene->objects[
      index_object
    ]->position.z = (
      1.0f
    );
  }
}

void example_3d_scene_poll(
  struct metil_scene* scene
) {
  metil_scene_poll_default(scene);

  for (
    unsigned char index_object = 0;
    index_object < scene->length_objects;
    ++index_object
  ) {
    float angle = (
      (float) scene->time_elapsed / 1000.0f +
      (float) (index_object) /
      (float) scene->length_objects *
      M_PI *
      4.0f
    );

    struct metil_renderer_data_object* data_object = scene->objects[
      index_object
    ]->data.contents;

    float distance = 2.0f;

    scene->objects[
      index_object
    ]->position.x = (
      (index_object % 2 == 0 ? -1 : 1) *
      sin(angle) *
      distance / 2.0f
    );

    scene->objects[
      index_object
    ]->position.y = (
      (index_object % 2 == 0 ? -1 : 1) *
      cos(angle) *
      distance / 2.0f
    );

    scene->objects[
      index_object
    ]->position.z = 2;

    scene->objects[
      index_object
    ]->rotation.y = fmod(
      scene->time_elapsed / (
        10000.0f *
        (float) ((index_object % 10) + 1)
      ),
      (M_PI * 2.0f)
    );

    scene->objects[
      index_object
    ]->rotation.x = fmod(
      scene->time_elapsed / (
        11000.0f *
        (float) (((index_object + 2) % 10) + 1)
      ),
      (M_PI * 2.0f)
    );

    scene->objects[
      index_object
    ]->rotation.z = fmod(
      scene->time_elapsed / (
        12000.0f *
        (float) (((index_object + 3) % 10) + 1)
      ),
      (M_PI * 2.0f)
    );
  }
}
