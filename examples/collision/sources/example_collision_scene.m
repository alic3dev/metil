#include <example_collision_scene.h>

#include <models/turret.h>
#include <example_collision_pipeline_index.h>

#include <metil_mesh/metil_mesh_2d/metil_mesh_square.h>
#include <metil_model/metil_model.h>
#include <metil_input/metil_cursor.h>
#include <metil_object.h>
#include <metil_player/metil_player.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/metil_scene.h>

#include <math.h>

void example_collision_scene_initialize(
  struct metil* metil,
  struct metil_scene* scene
) {
  metil_scene_initialize_with_renderables(
    metil,
    scene,
    2
  );

  metil->rendering_properties.camera.height = 5.40f;

  scene->player.position.z = 5.0f;

  metil_renderable_initialize_at_index(
    scene->renderables,
    scene_example_collision_index_renderable_turret,
    metil_renderable_type_model
  );

  metil_renderable_initialize_at_index(
    scene->renderables,
    scene_example_collision_index_renderable_floor,
    metil_renderable_type_object
  );

  struct metil_model* metil_model_turret = (
    scene->renderables[
      scene_example_collision_index_renderable_turret
    ].renderable
  );

  model_turret_initialize(
    metil,
    metil_model_turret
  );

  metil_model_turret->position.y = 1.25f;

  struct metil_object* metil_object_floor = (
    scene->renderables[
      scene_example_collision_index_renderable_floor
    ].renderable
  );

  struct metil_mesh* metil_mesh_floor = &(
    metil_object_floor->mesh
  );

  metil_mesh_initialize(
    metil_mesh_floor
  );

  metil_mesh_floor->length_vertices = 25;
  metil_mesh_floor->length_indices = 132;

  float size_floor = (
    300.0f
  );

  float size_floor_half = (
    size_floor /
    2.0f
  );

  metil_mesh_floor->indices = realloc(
    metil_mesh_floor->indices,
    sizeof(
      unsigned int
    ) *
    metil_mesh_floor->length_indices
  );

  metil_mesh_floor->vertices = realloc(
    metil_mesh_floor->vertices,
    sizeof(
      struct math_c_vector4_float
    ) *
    metil_mesh_floor->length_vertices
  );

  metil_mesh_floor->vertices[
    0
  ].x = (
    -size_floor_half
  );

  metil_mesh_floor->vertices[
    0
  ].y = (
    0.0f
  );

  metil_mesh_floor->vertices[
    0
  ].z = (
    -size_floor_half
  );

  metil_mesh_floor->vertices[
    0
  ].w = (
    1.0f
  );

  metil_mesh_floor->vertices[
    1
  ].x = (
    size_floor_half
  );

  metil_mesh_floor->vertices[
    1
  ].y = (
    0.0f
  );

  metil_mesh_floor->vertices[
    1
  ].z = (
    -size_floor_half
  );

  metil_mesh_floor->vertices[
    1
  ].w = (
    1.0f
  );

  metil_mesh_floor->vertices[
    2
  ].x = (
    size_floor_half
  );

  metil_mesh_floor->vertices[
    2
  ].y = (
    0.0f
  );

  metil_mesh_floor->vertices[
    2
  ].z = (
    size_floor_half
  );

  metil_mesh_floor->vertices[
    2
  ].w = (
    1.0f
  );

  metil_mesh_floor->vertices[
    3
  ].x = (
    -size_floor_half
  );

  metil_mesh_floor->vertices[
    3
  ].y = (
    0.0f
  );

  metil_mesh_floor->vertices[
    3
  ].z = (
    size_floor_half
  );
  
  metil_mesh_floor->vertices[
    3
  ].w = (
    1.0f
  );

  unsigned short int index_index = (
    0
  );

  float radius = (
    -8.0f
  );

  for (
    unsigned char index_vertex = 4;
    index_vertex < (
      metil_mesh_floor->length_vertices -
      1
    );
    ++index_vertex
  ) {
    float angle = (
      (
        (float) (
          index_vertex -
          4
        ) / (float) (
          metil_mesh_floor->length_vertices -
          5
        )
      ) *
      M_PI *
      2.0f
    );

    metil_mesh_floor->vertices[
      index_vertex
    ].x = (
      cos(
        angle
      ) *
      radius
    );

    metil_mesh_floor->vertices[
      index_vertex
    ].y = (
      0.0f
    );

    metil_mesh_floor->vertices[
      index_vertex
    ].z = (
      sin(
        angle
      ) *
      radius
    );

    metil_mesh_floor->vertices[
      index_vertex
    ].w = (
      1.0f
    );

    metil_mesh_floor->indices[
      index_index
    ] = (
      index_vertex
    );

    if (
      index_vertex != (
        metil_mesh_floor->length_vertices -
        2
      )
    ) {
      metil_mesh_floor->indices[
        index_index +
        1
      ] = (
        index_vertex +
        1
      );
    } else {
      metil_mesh_floor->indices[
        index_index +
        1
      ] = (
        4
      );
    }

    metil_mesh_floor->indices[
      index_index +
      2
    ] = (
      (
        index_vertex -
        4
      ) /
      5
    );

    index_index = (
      index_index +
      3
    );

    metil_mesh_floor->indices[
      index_index
    ] = (
      index_vertex
    );
    
    if (
      index_vertex != (
        metil_mesh_floor->length_vertices -
        2
      )
    ) {
      metil_mesh_floor->indices[
        index_index +
        1
      ] = (
        index_vertex +
        1
      );
    } else {
      metil_mesh_floor->indices[
        index_index +
        1
      ] = (
        4
      );
    }

    metil_mesh_floor->indices[
      index_index +
      2
    ] = (
      metil_mesh_floor->length_vertices -
      1
    );

    index_index = (
      index_index +
      3
    );
  }

  metil_mesh_floor->vertices[
    metil_mesh_floor->length_vertices -
    1
  ].x = (
    0.0f
  );

  metil_mesh_floor->vertices[
    metil_mesh_floor->length_vertices -
    1
  ].y = (
    0.0f
  );

  metil_mesh_floor->vertices[
    metil_mesh_floor->length_vertices -
    1
  ].z = (
    0.0f
  );

  metil_mesh_floor->vertices[
    metil_mesh_floor->length_vertices -
    1
  ].w = (
    1.0f
  );

  metil_mesh_floor->indices[
    index_index
  ] = (
    0
  );

  metil_mesh_floor->indices[
    index_index +
    1
  ] = (
    1
  );

  metil_mesh_floor->indices[
    index_index +
    2
  ] = (
    9
  );

  index_index = (
    index_index +
    3
  );

  metil_mesh_floor->indices[
    index_index
  ] = (
    1
  );

  metil_mesh_floor->indices[
    index_index +
    1
  ] = (
    2
  );

  metil_mesh_floor->indices[
    index_index +
    2
  ] = (
    14
  );

  index_index = (
    index_index +
    3
  );

  metil_mesh_floor->indices[
    index_index
  ] = (
    2
  );

  metil_mesh_floor->indices[
    index_index +
    1
  ] = (
    3
  );

  metil_mesh_floor->indices[
    index_index +
    2
  ] = (
    19
  );

  index_index = (
    index_index +
    3
  );

  metil_mesh_floor->indices[
    index_index
  ] = (
    3
  );

  metil_mesh_floor->indices[
    index_index +
    1
  ] = (
    0
  );

  metil_mesh_floor->indices[
    index_index +
    2
  ] = (
    4
  );

  index_index = (
    index_index +
    3
  );

  metil_object_buffers_initialize(
    metil_object_floor,
    metil->renderer_interface.metal_device
  );

  metil_object_floor->index_pipeline_render = (
    example_collision_pipeline_index_floor
  );

  struct metil_renderer_data_object* metil_renderer_data_object_floor = (
    metil_object_floor->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  metil_renderer_data_object_initialize(
    metil_renderer_data_object_floor
  );

  MTLTextureDescriptor* texture_descriptor = [
    [
      MTLTextureDescriptor
      alloc
    ]
    init
  ];

  texture_descriptor.pixelFormat = (
    MTLPixelFormatRGBA8Unorm
  );

  texture_descriptor.width = (
    200
  );

  texture_descriptor.height = (
    200
  );

  scene->length_textures = 2;

  scene->textures = (
    realloc(
      scene->textures,
      sizeof(
        id<MTLTexture>
      ) *
      scene->length_textures
    )
  );

  scene->textures[
    0
  ] = [
    metil->renderer_interface.metal_device
    newTextureWithDescriptor: texture_descriptor
  ];

  scene->textures[
    1
  ] = [
    metil->renderer_interface.metal_device
    newTextureWithDescriptor: texture_descriptor
  ];

  MTLRegion region = {
    {0, 0, 0},
    {texture_descriptor.width, texture_descriptor.height, 1}
  };

  unsigned int length_bytes_texture_row = (
    4 *
    texture_descriptor.width
  );

  unsigned int length_bytes_texture = (
    length_bytes_texture_row *
    texture_descriptor.height
  );

  unsigned char* pixel_bytes = (
    malloc(
      sizeof(
        unsigned char
      ) *
      length_bytes_texture
    )
  );

  for (
    unsigned int index_pixel = 0;
    index_pixel < length_bytes_texture;
    index_pixel = (
      index_pixel +
      4
    )
  ) {
    unsigned char offset = (
      (
        index_pixel *
        index_pixel +
        0b101011001010
      ) % 0x2a
    );

    if (
      offset > 0x10
    ) {
      offset = (
        0b010101010101101 %
        0b11111111
      );
    } else {
      offset = (
        0b001010101000100 %
        0b11111111
      );
    }

    pixel_bytes[
      index_pixel
    ] = (
      offset % 0xa0
    );
    
    pixel_bytes[
      index_pixel +
      1
    ] = (
      offset % 0xa0
    );

    pixel_bytes[
      index_pixel +
      2
    ] = (
      offset % 0xa1
    );

    pixel_bytes[
      index_pixel +
      3
    ] = 0xff;
  }

  [
    scene->textures[0]
    replaceRegion: region
    mipmapLevel: 0
    withBytes: pixel_bytes
    bytesPerRow: length_bytes_texture_row
  ];

  for (
    unsigned int index_pixel = 0;
    index_pixel < length_bytes_texture;
    index_pixel = (
      index_pixel +
      4
    )
  ) {
    unsigned int index_row = (
      index_pixel /
      length_bytes_texture_row
    );

    unsigned int index_column = (
      (index_pixel / 4) %
      texture_descriptor.width
    );
    
    pixel_bytes[
      index_pixel
    ] = 0x00;
    
    if (
      index_row >= 10 &&
      index_row <= 30 ||
      index_row == 100 ||
      index_column % 100 < 2 ||
      (index_column + 20) % 100 == 0 ||
      (index_column - 20) % 100 == 0 ||

      (
        index_row == 110 ||
        index_row == 111 ||
        index_row == 90 ||
        index_row == 89
      ) &&
      (
        index_column <= 50 ||
        index_column >= 150
      )
    ) {
      pixel_bytes[
        index_pixel +
        1
      ] = 0x00;

      pixel_bytes[
        index_pixel +
        3
      ] = 0xff;
    } else {
      pixel_bytes[
        index_pixel +
        1
      ] = 0xff;

      pixel_bytes[
        index_pixel +
        3
      ] = 0x13;
    }

    pixel_bytes[
      index_pixel +
      2
    ] = 0x00;
  }

  [
    scene->textures[1]
    replaceRegion: region
    mipmapLevel: 0
    withBytes: pixel_bytes
    bytesPerRow: length_bytes_texture_row
  ];

  for (
    unsigned short int index_object = 0;
    index_object < metil_model_turret->length_objects;
    ++index_object
  ) {
    switch (
      index_object
    ) {
      case model_turret_index_object_sight:
        metil_object_texture_add(
          &metil_model_turret->objects[
            index_object
          ],
          scene->textures[
            1
          ]
        );

        break;
      default:
        metil_object_texture_add(
          &metil_model_turret->objects[
            index_object
          ],
          scene->textures[
            0
          ]
        );

        break;
    }
  }

  [
    texture_descriptor
    release
  ];

  free(
    pixel_bytes
  );
  
  scene->destroy = example_collision_scene_destroy;
  scene->poll = example_collision_scene_poll;
}

void example_collision_scene_poll(
  struct metil* metil,
  struct metil_scene* scene
) {
  struct metil_model* metil_model_turret = (
    scene->renderables[
      scene_example_collision_index_renderable_turret
    ].renderable
  );

  struct metil_joint* metil_joint_turret = &(
    metil_model_turret->joints[
      0
    ]
  );

  metil_joint_turret->rotation.y = (
    metil_joint_turret->rotation.y +
    0.01f
  );

  metil_joint_propagate(
    metil_joint_turret
  );

  metil_scene_poll_default(
    metil,
    scene
  );
}

void example_collision_scene_destroy(
  struct metil* metil,
  struct metil_scene* scene
) {
  metil_scene_destroy_default(
    metil,
    scene
  );
}
