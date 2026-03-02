#include <example_2d_scene_textures.h>

#include <metil.h>
#include <metil_scenes/metil_scene.h>

#include <clic3_memory.h>

#include <Metal/MTLTexture.h>

void example_2d_scene_textures_initialize(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  metil_scene->length_textures = (
    example_2d_rendering_length_textures
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

  example_2d_scene_textures_initialize_background(
    metil,
    metil_scene
  );
}

void example_2d_scene_textures_initialize_background(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
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

  metil_scene->textures[
    example_2d_rendering_index_texture_background
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
}
