#include <3d_rendering_textures/3d_rendering_texture_door.h>

#include <clic3_memory.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

id<MTLTexture> metil_example_3d_rendering_texture_door_generate(
  id<MTLDevice> metal_device
) {
  static id<MTLTexture> metil_example_3d_rendering_texture_ground;

  MTLTextureDescriptor* descriptor_texture = [
    [
      MTLTextureDescriptor
      alloc
    ]
    init
  ];

  descriptor_texture.pixelFormat = (
    MTLPixelFormatRGBA8Unorm
  );

  descriptor_texture.width = (
    0x10ff /
    0x02
  );

  descriptor_texture.height = (
    0x10ff
  );

  metil_example_3d_rendering_texture_ground = [
    metal_device
    newTextureWithDescriptor: (
      descriptor_texture
    )
  ];

  MTLRegion region = {
    {
      0x00,
      0x00,
      0x00
    },
    {
      descriptor_texture.width,
      descriptor_texture.height,
      0x01
    }
  };

  unsigned int length_bytes_row = (
    descriptor_texture.width *
    0x04
  );

  unsigned char* bytes_pixels = (
    clic3_memory_allocate_raw(
      length_bytes_row *
      descriptor_texture.height
    )
  );

  for (
    unsigned int index_row = (
      0x00
    );
    (
      index_row <
      descriptor_texture.height
    );
    ++index_row
  ) {
    unsigned int offset_index = (
      index_row *
      length_bytes_row
    );

    for (
      unsigned int index_column = (
        0x00
      );
      (
        index_column <
        descriptor_texture.width
      );
      ++index_column
    ) {
      unsigned int index = (
        offset_index +
        index_column *
        0x04
      );

      bytes_pixels[
        index
      ] = (
        (
          (
            index_row > 0x13f
          ) &&
          (
            index_row <
            (
              descriptor_texture.height -
              0x13f
            )
          ) &&
          (
            index_column >
            0x13f
          ) &&
          (
            index_column <
            (
              descriptor_texture.width -
              0x13f
            )
          )
        )
        ? 0x80
        : 0xff
      );

      bytes_pixels[
        0x01 +
        index
      ] = (
        bytes_pixels[
          index
        ]
      );

      bytes_pixels[
        index +
        0x02
      ] = (
        bytes_pixels[
          index
        ]
      );

      bytes_pixels[
        index +
        0x03
      ] = (
        0xff
      );
    }
  }

  [
    metil_example_3d_rendering_texture_ground
    replaceRegion: region
    mipmapLevel: 0x00
    withBytes: bytes_pixels
    bytesPerRow: length_bytes_row
  ];

  [
    descriptor_texture
    release
  ];

  clic3_memory_free_raw(
    bytes_pixels
  );

  return (
    metil_example_3d_rendering_texture_ground
  );
}
