#include <example_2d_scene.h>

#include <metil.h>
#include <metil_group.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_circle.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_rectangle.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_square.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_triangle.h>
#include <metil_object.h>
#include <metil_player/metil_player.h>
#include <metil_positioning.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderable_type.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/metil_scene.h>

#include <math_c_pi.h>
#include <math_c_sine.h>
#include <math_c_vector.h>

#include <clic3_memory.h>

void example_2d_scene_initialize(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  metil_scene_initialize_with_renderables(
    metil,
    metil_scene,
    1
  );

  metil_scene->player.poll_input = (
    metil_player_poll_input_null
  );

  metil_scene->poll = (
    example_2d_scene_poll
  );

  for (
    unsigned char index_renderable = 0;
    index_renderable < metil_scene->length_renderables;
    ++index_renderable
  ) {
    switch (
      index_renderable
    ) {
      case 0: {
        metil_renderable_initialize_at_index(
          metil_scene->renderables,
          index_renderable,
          metil_renderable_type_object
        );

        break;
      }
      default: {
        
        break;
      }
    }
  }

  struct metil_object* metil_object_background = (
    metil_scene->renderables[
      0
    ].renderable
  );

  metil_mesh_square_initialize(
    &metil_object_background->mesh,
    2
  );

  metil_object_background->positioning = (
    metil_positioning_absolute
  );

  metil_object_buffers_initialize(
    metil_object_background,
    metil->renderer_interface.metal_device
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
    1600
  );

  texture_descriptor.height = (
    900
  );

  metil_scene->length_textures = (
    1
  );

  clic3_memory_reallocate_raw(
    &metil_scene->textures,
    (
      sizeof(
        id<MTLTexture>
      ) *
      metil_scene->length_textures
    )
  );

  metil_scene->textures[
    0
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
    clic3_memory_allocate_raw(
      length_bytes_texture
    )
  );

  for (
    unsigned short int index_y = 0;
    index_y < texture_descriptor.height;
    ++index_y
  ) {
    for (
      unsigned short int index_x = 0;
      index_x < texture_descriptor.width;
      ++index_x
    ) {
      unsigned int index_pixel = (
        (
          (
            index_y *
            texture_descriptor.width
          ) +
          index_x
        ) *
        4
      );

      if (
        (
          index_x %
          9
        ) == 4
      ) {
        pixel_bytes[
          index_pixel +
          0
        ] = (
          0x00
        );

        pixel_bytes[
          index_pixel +
          1
        ] = (
          0x55
        );

        pixel_bytes[
          index_pixel +
          2
        ] = (
          0x00
        );
      } else if (
        (
          index_y %
          16
        ) == 7
      ) {
        pixel_bytes[
          index_pixel +
          0
        ] = (
          0x00
        );

        pixel_bytes[
          index_pixel +
          1
        ] = (
          0x00
        );

        pixel_bytes[
          index_pixel +
          2
        ] = (
          0x77
        );
      } else if (
        (
          index_x %
          8
        ) == 7 &&
        (
          index_y %
          16
        ) == 10
      ) {
        pixel_bytes[
          index_pixel +
          0
        ] = (
          0xff
        );

        pixel_bytes[
          index_pixel +
          1
        ] = (
          0x00
        );

        pixel_bytes[
          index_pixel +
          2
        ] = (
          0x00
        );
      } else {
        unsigned char value = (
          (
            (
              (
                index_x
              ) %
              8
            ) >
            3 &&
            (
              (
                index_y
              ) %
              8
            ) >
            3
          )
          ? 0x20
          : 0x00
        );

        pixel_bytes[
          index_pixel +
          0
        ] = (
          value
        );

        pixel_bytes[
          index_pixel +
          1
        ] = (
          value
        );

        pixel_bytes[
          index_pixel +
          2
        ] = (
          value
        );
      }

      pixel_bytes[
        index_pixel +
        3
      ] = (
        0xff 
      );
    }
  }

  [
    metil_scene->textures[
      0
    ]
    replaceRegion: region
    mipmapLevel: 0
    withBytes: pixel_bytes
    bytesPerRow: length_bytes_texture_row
  ];

  [
    texture_descriptor
    release
  ];

  clic3_memory_free_raw(
    pixel_bytes
  );

  metil_object_texture_add(
    metil_object_background,
    metil_scene->textures[
      0
    ]
  );
}

void example_2d_scene_poll(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  metil_scene_poll_default(
    metil,
    metil_scene
  );
}
