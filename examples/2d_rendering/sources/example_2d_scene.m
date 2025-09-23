#include <example_2d_scene.h>

#include <metil_mesh/mesh_box.h>
#include <metil_object.h>
#include <metil_player.h>
#include <metil_rendering/rendering_properties.h>
#include <metil_scenes/scene.h>
#include <metil_shader_types.h>

#include <clic3_vector.h>

#include <math.h>
#include <stdlib.h>

#include <stdio.h>

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

  scene->length_objects = 1;
  scene->objects = realloc(
    scene->objects,
    sizeof(struct metil_object*) *
    scene->length_objects
  );

  scene->objects[
    0
  ] = malloc(
    sizeof(struct metil_object)
  );

  metil_object_initialize(
    scene->objects[
      0
    ]
  );

  metil_mesh_initialize(
    &scene->objects[
      0
    ]->mesh
  );

  scene->objects[
    0
  ]->mesh.length_indices = 6;

  scene->objects[
    0
  ]->mesh.length_vertices = 4;

  scene->objects[
    0
  ]->mesh.indices = realloc(
    scene->objects[
      0
    ]->mesh.indices,
    sizeof(unsigned int) *
    scene->objects[
      0
    ]->mesh.length_indices
  );

  scene->objects[
    0
  ]->mesh.vertices = realloc(
    scene->objects[
      0
    ]->mesh.vertices,
    sizeof(struct clic3_vector4_float) *
    scene->objects[
      0
    ]->mesh.length_vertices
  );

  scene->objects[
    0
  ]->mesh.vertices[0].x = -0.1f;
  scene->objects[
    0
  ]->mesh.vertices[0].y = -0.1f;
  scene->objects[
    0
  ]->mesh.vertices[0].z = 0.0f;
  scene->objects[
    0
  ]->mesh.vertices[0].w = 1.0f;

  scene->objects[
    0
  ]->mesh.vertices[1].x = 0.1f;
  scene->objects[
    0
  ]->mesh.vertices[1].y = -0.1f;
  scene->objects[
    0
  ]->mesh.vertices[1].z = 0.0f;
  scene->objects[
    0
  ]->mesh.vertices[1].w = 1.0f;

  scene->objects[
    0
  ]->mesh.vertices[2].x = 0.1f;
  scene->objects[
    0
  ]->mesh.vertices[2].y = 0.1f;
  scene->objects[
    0
  ]->mesh.vertices[2].z = 0.0f;
  scene->objects[
    0
  ]->mesh.vertices[2].w = 1.0f;

  scene->objects[
    0
  ]->mesh.vertices[3].x = -0.1f;
  scene->objects[
    0
  ]->mesh.vertices[3].y = 0.1f;
  scene->objects[
    0
  ]->mesh.vertices[3].z = 0.0f;
  scene->objects[
    0
  ]->mesh.vertices[3].w = 1.0f;

  scene->objects[
    0
  ]->mesh.indices[0] = 0;

  scene->objects[
    0
  ]->mesh.indices[1] = 1;

  scene->objects[
    0
  ]->mesh.indices[2] = 2;

  scene->objects[
    0
  ]->mesh.indices[3] = 0;

  scene->objects[
    0
  ]->mesh.indices[4] = 3;

  scene->objects[
    0
  ]->mesh.indices[5] = 2;

  scene->objects[
    0
  ]->vertices = [metal_kit_device
    newBufferWithBytes: scene->objects[
      0
    ]->mesh.vertices
    length: scene->objects[
      0
    ]->mesh.length_vertices * sizeof(
      struct clic3_vector4_float
    )
    options: MTLResourceStorageModeShared
  ];

  scene->objects[
    0
  ]->indices = [metal_kit_device
    newBufferWithBytes: scene->objects[
      0
    ]->mesh.indices
    length: scene->objects[
      0
    ]->mesh.length_indices * sizeof(
      unsigned int
    )
    options: MTLResourceStorageModeShared
  ];

  scene->objects[0]->mesh.positioning = metil_mesh_positioning_static;

  scene->objects[
    0
  ]->data = [metal_kit_device
    newBufferWithLength: sizeof(metil_kit_data_frame_object)
    options: MTLResourceStorageModeShared
  ];

  metil_kit_data_frame_object* data_object = scene->objects[
    0
  ]->data.contents;

  data_object->id = 0;
  data_object->color.x = 0.25f;
  data_object->color.y = 0.1f;
  data_object->color.z = 1.0f;
  data_object->color.w = 1.0f;

  scene->objects[
    0
  ]->position.z = (
    1.0f
  );
}

void example_2d_scene_poll(
  struct metil_scene* scene
) {
  metil_scene_poll_default(scene);

  struct metil_rendering_properties* rendering_properties = (
    (struct metil_rendering_properties*) scene->data
  );

  rendering_properties->color_clear.x = fmod(
    rendering_properties->camera.ratio_aspect * (float) ((scene->time / 50) % 3000),
    100.0f
  ) / 100.0f;

  rendering_properties->color_clear.y = fmod(
    rendering_properties->camera.ratio_aspect * (float) ((scene->time / 42) % 4000),
    100.0f
  ) / 100.0f;

  rendering_properties->color_clear.z = fmod(
    rendering_properties->camera.ratio_aspect  * (float) ((scene->time / 33) % 5000),
    100.0f
  ) / 100.0f;

  struct clic3_vector4_float* a = scene->objects[
    0
  ]->vertices.contents;

  float time = (float) (scene->time % 4000);

  if (time >= 2000.0f) {
    time = 4000.0f - time;
  }

  a[0].x = -sinf(time / 4000.0f) * 0.9 - 0.1;
  a[0].y = -sinf(time / 4000.0f) * 0.9 - 0.1;

  a[1].x = sinf(time / 4000.0f) * 0.9 + 0.1;
  a[1].y = -sinf(time / 4000.0f) * 0.9 - 0.1;

  a[2].x = sinf(time / 4000.0f) * 0.9 + 0.1;
  a[2].y = sinf(time / 4000.0f) * 0.9 + 0.1;

  a[3].x = -sinf(time / 4000.0f) * 0.9 - 0.1;
  a[3].y = sinf(time / 4000.0f) * 0.9 + 0.1;

  metil_kit_data_frame_object* data_object = scene->objects[
    0
  ]->data.contents;

  data_object->color.x = fabs(sinf(((float) (scene->time % 2000) / 2000.0f) * M_PI / 2.0f));
  data_object->color.y = fabs(sinf(((float) (scene->time % 3000) / 3000.0f) * M_PI / 2.0f));
  data_object->color.z = fabs(sinf(((float) (scene->time % 1000) / 1000.0f) * M_PI / 2.0f));
}

void example_2d_scene_destroy(
  struct metil_scene* scene
) {
  [scene->objects[0]->data release];
  [scene->objects[0]->indices release];
  [scene->objects[0]->vertices release];

  scene->data = (void*)0;

  metil_scene_destroy_default(scene);
}
