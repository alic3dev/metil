#include <metil_texture/metil_texture_concrete.h>

#include <math_c_vector.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

id<MTLTexture> metil_texture_concrete_generate(
  struct math_c_vector2_unsigned_short_int size,
  unsigned char* seed,
  unsigned int length_seed,
  id<MTLDevice> metal_device
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
    size.x
  );

  texture_descriptor.height = (
    size.y
  );

  static id<MTLTexture> texture;
  texture = [
    metal_device
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

  unsigned char* pixel_bytes_secondary = (
    malloc(
      sizeof(
        unsigned char
      ) *
      length_bytes_texture
    )
  );

  for (unsigned int index_x = 0; index_x < texture_descriptor.width; ++index_x) { for (unsigned int index_y = 0; index_y < texture_descriptor.height; ++index_y) { 
    unsigned int index_pixel = index_x * 4 + index_y * texture_descriptor.width * 4;
    unsigned int r = ((index_x + 548) % 7) * ((index_y + 234) % 2) * 0x1b * seed[((index_x + 54) * (index_y + 13)) % length_seed];
    pixel_bytes[index_pixel] = 0x7f + ((seed[r % length_seed] + 1) % 0x1b);
    pixel_bytes[index_pixel + 1] = 0x7f + ((seed[(r) % length_seed] + 1) % 0x1b);
    pixel_bytes[index_pixel + 2] = 0x7f + ((seed[(r) % length_seed] + 0) % 0x1b);
    pixel_bytes[index_pixel + 3] = 0xff;
  }}


  for (unsigned int index_x = 0; index_x < texture_descriptor.width; index_x += 2) { for (unsigned int index_y = 0; index_y < texture_descriptor.height; index_y += 2) {
    unsigned int index_pixel = index_x * 4 + index_y * texture_descriptor.width * 4;
    pixel_bytes_secondary[index_pixel] = pixel_bytes[index_pixel];
    pixel_bytes_secondary[index_pixel + 1] = pixel_bytes[index_pixel + 1];
    pixel_bytes_secondary[index_pixel + 2] = pixel_bytes[index_pixel + 2];
    pixel_bytes_secondary[index_pixel + 3] = 0xff;
  }}
  for (unsigned int index_x = 0; index_x < texture_descriptor.width; index_x += 1) { for (unsigned int index_y = 0; index_y < texture_descriptor.height; index_y += 1) {
    unsigned int index_pixel = index_x * 4 + index_y * texture_descriptor.width * 4;
    if (pixel_bytes_secondary[index_pixel] != 0) continue;

    if (
      index_x > 0
    ) {
      unsigned int z = (index_x - 1) * 4 + index_y * texture_descriptor.width * 4;

      pixel_bytes_secondary[index_pixel] = (
        (pixel_bytes_secondary[index_pixel] + pixel_bytes[z]) / 2
      );
      pixel_bytes_secondary[index_pixel + 1] = (
        (pixel_bytes_secondary[index_pixel + 1] + pixel_bytes[z + 1]) / 2
      );
      pixel_bytes_secondary[index_pixel + 2] = (
        (pixel_bytes_secondary[index_pixel + 2] + pixel_bytes[z + 2]) / 2
      );

      if (
        index_y > 0
      ) {
        unsigned int f = (index_x - 1) * 4 + (index_y - 1) * texture_descriptor.width * 4;
    
        pixel_bytes_secondary[index_pixel] = (
          (pixel_bytes_secondary[index_pixel] + pixel_bytes[f]) / 2
        );
        pixel_bytes_secondary[index_pixel + 1] = (
          (pixel_bytes_secondary[index_pixel + 1] + pixel_bytes[f + 1]) / 2
        );
        pixel_bytes_secondary[index_pixel + 2] = (
          (pixel_bytes_secondary[index_pixel + 2] + pixel_bytes[f + 2]) / 2
        );
      }

      if (
        index_y < texture_descriptor.height - 1
      ) {
        unsigned int z = (index_x - 1) * 4 + (index_y + 1) * texture_descriptor.width * 4;
    
        pixel_bytes_secondary[index_pixel] = (
          (pixel_bytes_secondary[index_pixel] + pixel_bytes[z]) / 2
        );
        pixel_bytes_secondary[index_pixel + 1] = (
          (pixel_bytes_secondary[index_pixel + 1] + pixel_bytes[z + 1]) / 2
        );
        pixel_bytes_secondary[index_pixel + 2] = (
          (pixel_bytes_secondary[index_pixel + 2] + pixel_bytes[z + 2]) / 2
        );
      }
    }

    if (
      index_x < texture_descriptor.width - 1
    ) {
      unsigned int z = (index_x + 1) * 4 + index_y * texture_descriptor.width * 4;

      pixel_bytes_secondary[index_pixel] = (
        (pixel_bytes_secondary[index_pixel] + pixel_bytes[z]) / 2
      );
      pixel_bytes_secondary[index_pixel + 1] = (
        (pixel_bytes_secondary[index_pixel + 1] + pixel_bytes[z + 1]) / 2
      );
      pixel_bytes_secondary[index_pixel + 2] = (
        (pixel_bytes_secondary[index_pixel + 2] + pixel_bytes[z + 2]) / 2
      );

      if (
        index_y > 0
      ) {
        unsigned int f = (index_x + 1) * 4 + (index_y - 1) * texture_descriptor.width * 4;
    
        pixel_bytes_secondary[index_pixel] = (
          (pixel_bytes_secondary[index_pixel] + pixel_bytes[f]) / 2
        );
        pixel_bytes_secondary[index_pixel + 1] = (
          (pixel_bytes_secondary[index_pixel + 1] + pixel_bytes[f + 1]) / 2
        );
        pixel_bytes_secondary[index_pixel + 2] = (
          (pixel_bytes_secondary[index_pixel + 2] + pixel_bytes[f + 2]) / 2
        );
      }

      if (
        index_y < texture_descriptor.height - 1
      ) {
        unsigned int z = (index_x + 1) * 4 + (index_y + 1) * texture_descriptor.width * 4;
    
        pixel_bytes_secondary[index_pixel] = (
          (pixel_bytes_secondary[index_pixel] + pixel_bytes[z]) / 2
        );
        pixel_bytes_secondary[index_pixel + 1] = (
          (pixel_bytes_secondary[index_pixel + 1] + pixel_bytes[z + 1]) / 2
        );
        pixel_bytes_secondary[index_pixel + 2] = (
          (pixel_bytes_secondary[index_pixel + 2] + pixel_bytes[z + 2]) / 2
        );
      }
    }

    if (
      index_y > 0
    ) {
      unsigned int z = index_x * 4 + (index_y - 1) * texture_descriptor.width * 4;

      pixel_bytes_secondary[index_pixel] = (
        (pixel_bytes_secondary[index_pixel] + pixel_bytes[z]) / 2
      );
      pixel_bytes_secondary[index_pixel + 1] = (
        (pixel_bytes_secondary[index_pixel + 1] + pixel_bytes[z + 1]) / 2
      );
      pixel_bytes_secondary[index_pixel + 2] = (
        (pixel_bytes_secondary[index_pixel + 2] + pixel_bytes[z + 2]) / 2
      );
    }

    if (
      index_y < texture_descriptor.height - 1
    ) {
      unsigned int z = index_x * 4 + (index_y + 1) * texture_descriptor.width * 4;

      pixel_bytes_secondary[index_pixel] = (
        (pixel_bytes_secondary[index_pixel] + pixel_bytes[z]) / 2
      );
      pixel_bytes_secondary[index_pixel + 1] = (
        (pixel_bytes_secondary[index_pixel + 1] + pixel_bytes[z + 1]) / 2
      );
      pixel_bytes_secondary[index_pixel + 2] = (
        (pixel_bytes_secondary[index_pixel + 2] + pixel_bytes[z + 2]) / 2
      );
    }

    pixel_bytes_secondary[index_pixel + 3] = 0xff;
  }}
  for (unsigned int index_x = 0; index_x < texture_descriptor.width; ++index_x) { for (unsigned int index_y = 0; index_y < texture_descriptor.height; ++index_y) {
    unsigned int index_pixel = index_x * 4 + index_y * texture_descriptor.width * 4;
    pixel_bytes_secondary[index_pixel] = pixel_bytes_secondary[index_pixel] * ((pixel_bytes_secondary[index_pixel] - 0x7f) / 0x1b);
    pixel_bytes_secondary[index_pixel + 1] = pixel_bytes_secondary[index_pixel + 1] * ((pixel_bytes_secondary[index_pixel + 1] - 0x7f) / 0x1b);
    pixel_bytes_secondary[index_pixel + 2] = pixel_bytes_secondary[index_pixel + 2] * ((pixel_bytes_secondary[index_pixel + 2] - 0x7f) / 0x1b);
    pixel_bytes_secondary[index_pixel + 3] = 0xff;
  }}
  for (unsigned int index_iteration = 0; index_iteration < 100; ++index_iteration) {
  for (unsigned int index_x = 0; index_x < texture_descriptor.width; index_x += 2) { for (unsigned int index_y = 0; index_y < texture_descriptor.height; index_y += 1) {
    unsigned int index_pixel = index_x * 4 + index_y * texture_descriptor.width * 4;

    if (
      index_x > 0
    ) {
      unsigned int z = (index_x - 1) * 4 + index_y * texture_descriptor.width * 4;

      pixel_bytes_secondary[index_pixel] = (
        (pixel_bytes_secondary[index_pixel] + pixel_bytes_secondary[z]) / 2
      );
      pixel_bytes_secondary[index_pixel + 1] = (
        (pixel_bytes_secondary[index_pixel + 1] + pixel_bytes_secondary[z + 1]) / 2
      );
      pixel_bytes_secondary[index_pixel + 2] = (
        (pixel_bytes_secondary[index_pixel + 2] + pixel_bytes_secondary[z + 2]) / 2
      );

      if (
        index_y > 0
      ) {
        unsigned int f = (index_x - 1) * 4 + (index_y - 1) * texture_descriptor.width * 4;
    
        pixel_bytes_secondary[index_pixel] = (
          (pixel_bytes_secondary[index_pixel] + pixel_bytes_secondary[f]) / 2
        );
        pixel_bytes_secondary[index_pixel + 1] = (
          (pixel_bytes_secondary[index_pixel + 1] + pixel_bytes_secondary[f + 1]) / 2
        );
        pixel_bytes_secondary[index_pixel + 2] = (
          (pixel_bytes_secondary[index_pixel + 2] + pixel_bytes_secondary[f + 2]) / 2
        );
      }

      if (
        index_y < texture_descriptor.height - 1
      ) {
        unsigned int z = (index_x - 1) * 4 + (index_y + 1) * texture_descriptor.width * 4;
    
        pixel_bytes_secondary[index_pixel] = (
          (pixel_bytes_secondary[index_pixel] + pixel_bytes_secondary[z]) / 2
        );
        pixel_bytes_secondary[index_pixel + 1] = (
          (pixel_bytes_secondary[index_pixel + 1] + pixel_bytes_secondary[z + 1]) / 2
        );
        pixel_bytes_secondary[index_pixel + 2] = (
          (pixel_bytes_secondary[index_pixel + 2] + pixel_bytes_secondary[z + 2]) / 2
        );
      }
    }

    if (
      index_x < texture_descriptor.width - 1
    ) {
      unsigned int z = (index_x + 1) * 4 + index_y * texture_descriptor.width * 4;

      pixel_bytes_secondary[index_pixel] = (
        (pixel_bytes_secondary[index_pixel] + pixel_bytes_secondary[z]) / 2
      );
      pixel_bytes_secondary[index_pixel + 1] = (
        (pixel_bytes_secondary[index_pixel + 1] + pixel_bytes_secondary[z + 1]) / 2
      );
      pixel_bytes_secondary[index_pixel + 2] = (
        (pixel_bytes_secondary[index_pixel + 2] + pixel_bytes_secondary[z + 2]) / 2
      );

      if (
        index_y > 0
      ) {
        unsigned int f = (index_x + 1) * 4 + (index_y - 1) * texture_descriptor.width * 4;
    
        pixel_bytes_secondary[index_pixel] = (
          (pixel_bytes_secondary[index_pixel] + pixel_bytes_secondary[f]) / 2
        );
        pixel_bytes_secondary[index_pixel + 1] = (
          (pixel_bytes_secondary[index_pixel + 1] + pixel_bytes_secondary[f + 1]) / 2
        );
        pixel_bytes_secondary[index_pixel + 2] = (
          (pixel_bytes_secondary[index_pixel + 2] + pixel_bytes_secondary[f + 2]) / 2
        );
      }

      if (
        index_y < texture_descriptor.height - 1
      ) {
        unsigned int z = (index_x + 1) * 4 + (index_y + 1) * texture_descriptor.width * 4;
    
        pixel_bytes_secondary[index_pixel] = (
          (pixel_bytes_secondary[index_pixel] + pixel_bytes_secondary[z]) / 2
        );
        pixel_bytes_secondary[index_pixel + 1] = (
          (pixel_bytes_secondary[index_pixel + 1] + pixel_bytes_secondary[z + 1]) / 2
        );
        pixel_bytes_secondary[index_pixel + 2] = (
          (pixel_bytes_secondary[index_pixel + 2] + pixel_bytes_secondary[z + 2]) / 2
        );
      }
    }

    if (
      index_y > 0
    ) {
      unsigned int z = index_x * 4 + (index_y - 1) * texture_descriptor.width * 4;

      pixel_bytes_secondary[index_pixel] = (
        (pixel_bytes_secondary[index_pixel] + pixel_bytes_secondary[z]) / 2
      );
      pixel_bytes_secondary[index_pixel + 1] = (
        (pixel_bytes_secondary[index_pixel + 1] + pixel_bytes_secondary[z + 1]) / 2
      );
      pixel_bytes_secondary[index_pixel + 2] = (
        (pixel_bytes_secondary[index_pixel + 2] + pixel_bytes_secondary[z + 2]) / 2
      );
    }

    if (
      index_y < texture_descriptor.height - 1
    ) {
      unsigned int z = index_x * 4 + (index_y + 1) * texture_descriptor.width * 4;

      pixel_bytes_secondary[index_pixel] = (
        (pixel_bytes_secondary[index_pixel] + pixel_bytes_secondary[z]) / 2
      );
      pixel_bytes_secondary[index_pixel + 1] = (
        (pixel_bytes_secondary[index_pixel + 1] + pixel_bytes_secondary[z + 1]) / 2
      );
      pixel_bytes_secondary[index_pixel + 2] = (
        (pixel_bytes_secondary[index_pixel + 2] + pixel_bytes_secondary[z + 2]) / 2
      );
    }
  }}}

  [
    texture
    replaceRegion: region
    mipmapLevel: 0
    withBytes: pixel_bytes
    bytesPerRow: length_bytes_texture_row
  ];

  [
    texture_descriptor
    release
  ];

  free(
    pixel_bytes
  );

  free(
    pixel_bytes_secondary
  );

  return (
    texture
  );
}


id<MTLTexture> metil_texture_concrete_secondary_generate(
  struct math_c_vector2_unsigned_short_int size,
  unsigned char* seed,
  unsigned int length_seed,
  id<MTLDevice> metal_device
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
    size.x
  );

  texture_descriptor.height = (
    size.y
  );

  static id<MTLTexture> texture;
  texture = [
    metal_device
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

  unsigned char* pixel_bytes_secondary = (
    malloc(
      sizeof(
        unsigned char
      ) *
      length_bytes_texture
    )
  );

  for (unsigned int index_x = 0; index_x < texture_descriptor.width; ++index_x) { for (unsigned int index_y = 0; index_y < texture_descriptor.height; ++index_y) { 
    unsigned int index_pixel = index_x * 4 + index_y * texture_descriptor.width * 4;
    unsigned int r = ((index_x + 0x0224) % 7) * ((index_y + 0xea) % 2) * 0x1b * seed[((index_x + 0x36) * (index_y + 0x0d)) % length_seed];
    pixel_bytes[index_pixel] = 0x7f + ((seed[r % length_seed] + 1) % 0x1b);
    pixel_bytes[index_pixel + 1] = 0x7f + ((seed[(r) % length_seed] + 1) % 0x1b);
    pixel_bytes[index_pixel + 2] = 0x7f + ((seed[(r) % length_seed] + 0) % 0x1b);
    pixel_bytes[index_pixel + 3] = 0xff;
  }}
  
  for (unsigned int index_x = 0; index_x < texture_descriptor.width; index_x += 2) { for (unsigned int index_y = 0; index_y < texture_descriptor.height; index_y += 2) {
    unsigned int index_pixel = index_x * 4 + index_y * texture_descriptor.width * 4;
    pixel_bytes_secondary[index_pixel] = pixel_bytes[index_pixel];
    pixel_bytes_secondary[index_pixel + 1] = pixel_bytes[index_pixel + 1];
    pixel_bytes_secondary[index_pixel + 2] = pixel_bytes[index_pixel + 2];
    pixel_bytes_secondary[index_pixel + 3] = 0xff;
  }}
  for (unsigned int index_x = 0; index_x < texture_descriptor.width; index_x += 1) { for (unsigned int index_y = 0; index_y < texture_descriptor.height; index_y += 1) {
    unsigned int index_pixel = index_x * 4 + index_y * texture_descriptor.width * 4;
    if (pixel_bytes_secondary[index_pixel] != 0) continue;

    if (
      index_x > 0
    ) {
      unsigned int z = (index_x - 1) * 4 + index_y * texture_descriptor.width * 4;

      pixel_bytes_secondary[index_pixel] = (
        (pixel_bytes_secondary[index_pixel] + pixel_bytes[z]) / 2
      );
      pixel_bytes_secondary[index_pixel + 1] = (
        (pixel_bytes_secondary[index_pixel + 1] + pixel_bytes[z + 1]) / 2
      );
      pixel_bytes_secondary[index_pixel + 2] = (
        (pixel_bytes_secondary[index_pixel + 2] + pixel_bytes[z + 2]) / 2
      );

      if (
        index_y > 0
      ) {
        unsigned int f = (index_x - 1) * 4 + (index_y - 1) * texture_descriptor.width * 4;
    
        pixel_bytes_secondary[index_pixel] = (
          (pixel_bytes_secondary[index_pixel] + pixel_bytes[f]) / 2
        );
        pixel_bytes_secondary[index_pixel + 1] = (
          (pixel_bytes_secondary[index_pixel + 1] + pixel_bytes[f + 1]) / 2
        );
        pixel_bytes_secondary[index_pixel + 2] = (
          (pixel_bytes_secondary[index_pixel + 2] + pixel_bytes[f + 2]) / 2
        );
      }

      if (
        index_y < texture_descriptor.height - 1
      ) {
        unsigned int z = (index_x - 1) * 4 + (index_y + 1) * texture_descriptor.width * 4;
    
        pixel_bytes_secondary[index_pixel] = (
          (pixel_bytes_secondary[index_pixel] + pixel_bytes[z]) / 2
        );
        pixel_bytes_secondary[index_pixel + 1] = (
          (pixel_bytes_secondary[index_pixel + 1] + pixel_bytes[z + 1]) / 2
        );
        pixel_bytes_secondary[index_pixel + 2] = (
          (pixel_bytes_secondary[index_pixel + 2] + pixel_bytes[z + 2]) / 2
        );
      }
    }

    if (
      index_x < texture_descriptor.width - 1
    ) {
      unsigned int z = (index_x + 1) * 4 + index_y * texture_descriptor.width * 4;

      pixel_bytes_secondary[index_pixel] = (
        (pixel_bytes_secondary[index_pixel] + pixel_bytes[z]) / 2
      );
      pixel_bytes_secondary[index_pixel + 1] = (
        (pixel_bytes_secondary[index_pixel + 1] + pixel_bytes[z + 1]) / 2
      );
      pixel_bytes_secondary[index_pixel + 2] = (
        (pixel_bytes_secondary[index_pixel + 2] + pixel_bytes[z + 2]) / 2
      );

      if (
        index_y > 0
      ) {
        unsigned int f = (index_x + 1) * 4 + (index_y - 1) * texture_descriptor.width * 4;
    
        pixel_bytes_secondary[index_pixel] = (
          (pixel_bytes_secondary[index_pixel] + pixel_bytes[f]) / 2
        );
        pixel_bytes_secondary[index_pixel + 1] = (
          (pixel_bytes_secondary[index_pixel + 1] + pixel_bytes[f + 1]) / 2
        );
        pixel_bytes_secondary[index_pixel + 2] = (
          (pixel_bytes_secondary[index_pixel + 2] + pixel_bytes[f + 2]) / 2
        );
      }

      if (
        index_y < texture_descriptor.height - 1
      ) {
        unsigned int z = (index_x + 1) * 4 + (index_y + 1) * texture_descriptor.width * 4;
    
        pixel_bytes_secondary[index_pixel] = (
          (pixel_bytes_secondary[index_pixel] + pixel_bytes[z]) / 2
        );
        pixel_bytes_secondary[index_pixel + 1] = (
          (pixel_bytes_secondary[index_pixel + 1] + pixel_bytes[z + 1]) / 2
        );
        pixel_bytes_secondary[index_pixel + 2] = (
          (pixel_bytes_secondary[index_pixel + 2] + pixel_bytes[z + 2]) / 2
        );
      }
    }

    if (
      index_y > 0
    ) {
      unsigned int z = index_x * 4 + (index_y - 1) * texture_descriptor.width * 4;

      pixel_bytes_secondary[index_pixel] = (
        (pixel_bytes_secondary[index_pixel] + pixel_bytes[z]) / 2
      );
      pixel_bytes_secondary[index_pixel + 1] = (
        (pixel_bytes_secondary[index_pixel + 1] + pixel_bytes[z + 1]) / 2
      );
      pixel_bytes_secondary[index_pixel + 2] = (
        (pixel_bytes_secondary[index_pixel + 2] + pixel_bytes[z + 2]) / 2
      );
    }

    if (
      index_y < texture_descriptor.height - 1
    ) {
      unsigned int z = index_x * 4 + (index_y + 1) * texture_descriptor.width * 4;

      pixel_bytes_secondary[index_pixel] = (
        (pixel_bytes_secondary[index_pixel] + pixel_bytes[z]) / 2
      );
      pixel_bytes_secondary[index_pixel + 1] = (
        (pixel_bytes_secondary[index_pixel + 1] + pixel_bytes[z + 1]) / 2
      );
      pixel_bytes_secondary[index_pixel + 2] = (
        (pixel_bytes_secondary[index_pixel + 2] + pixel_bytes[z + 2]) / 2
      );
    }

    pixel_bytes_secondary[index_pixel + 3] = 0xff;
  }}

  [
    texture
    replaceRegion: region
    mipmapLevel: 0
    withBytes: pixel_bytes
    bytesPerRow: length_bytes_texture_row
  ];

  [
    texture_descriptor
    release
  ];

  free(
    pixel_bytes
  );

  free(
    pixel_bytes_secondary
  );

  return (
    texture
  );
}
