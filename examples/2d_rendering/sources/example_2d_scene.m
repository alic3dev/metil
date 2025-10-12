#include <example_2d_scene.h>

#include <metil_mesh/2d/mesh_triangle.h>
#include <metil_object.h>
#include <metil_player.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/scene.h>

#include <clic3_vector.h>

#include <stdlib.h>

void example_2d_scene_initialize(
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

  scene->poll = example_2d_scene_poll;
  scene->destroy = example_2d_scene_destroy;

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

    metil_mesh_triangle_initialize(
      &scene->objects[
        index_object
      ]->mesh,
      0.175,
      (float) index_object / (float) (scene->length_objects - 1)
    );

    scene->objects[index_object]->mesh.positioning = metil_mesh_positioning_static;

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
    data_object->color.x = (float) index_object / (scene->length_objects - 1);
    data_object->color.y = (float) ((index_object + 33) % scene->length_objects) / (scene->length_objects - 1);
    data_object->color.z = (float) ((index_object + 66) % scene->length_objects) / (scene->length_objects - 1);
    data_object->color.w = 1.0f;

    scene->objects[
      index_object
    ]->position.x = (
      (float) (index_object % 10)
    ) * 0.2f - 0.9f;

    scene->objects[
      index_object
    ]->position.y = (
      (float) (index_object / 10)
    ) * 0.2f - 0.9f;

    scene->objects[
      index_object
    ]->position.z = (
      1.0f
    );
  }
}

void example_2d_scene_poll(
  struct metil_scene* scene
) {
  metil_scene_poll_default(scene);

  float brightness_minimum = 0.25f;

  for (
    unsigned char index_object = 0;
    index_object < scene->length_objects;
    ++index_object
  ) {
    struct metil_renderer_data_object* data_object = scene->objects[
      index_object
    ]->data.contents;

    struct clic3_vector3_unsigned_int time_offset = {
      .x = scene->time + (index_object + 2) * 20,
      .y = scene->time + (index_object + 3) * 30,
      .z = scene->time + (index_object + 1) * 10
    };

    data_object->color.x = (
      ((time_offset.x / 1000) % 2 == 0
        ? (float) (time_offset.x % 1000) / 1500.0f
        : (float) (1000 - (time_offset.x % 1000)) / 1500.0f
      ) +
      brightness_minimum
    );
    data_object->color.y = (
      ((time_offset.y / 1000) % 2 == 0
        ? (float) (time_offset.y % 1000) / 1500.0f
        : (float) (1000 - (time_offset.y % 1000)) / 1500.0f
      ) +
      brightness_minimum
    );
    data_object->color.z = (
      ((time_offset.z / 1000) % 2 == 0
        ? (float) (time_offset.z % 1000) / 1500.0f
        : (float) (1000 - (time_offset.z % 1000)) / 1500.0f
      ) +
      brightness_minimum
    );
  }
}

void example_2d_scene_destroy(
  struct metil_scene* scene
) {
  for (
    unsigned char index_object = 0;
    index_object < scene->length_objects;
    ++index_object
  ) {
    [scene->objects[index_object]->vertices release];
    [scene->objects[index_object]->indices release];
    [scene->objects[index_object]->data release];
  }

  metil_scene_destroy_default(scene);
}
