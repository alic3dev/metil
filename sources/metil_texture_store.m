#include <metil_texture_store.h>

#include <clic3_memory.h>

#include <metil_debug/metil_debug_log.h>

#include <Metal/MTLTexture.h>
#include <MetalKit/MTKTextureLoader.h>

#include <stdarg.h>
#include <stdio.h>

void metil_texture_store_initialize(
  struct metil_texture_store* metil_texture_store,
  NSURL* url_directory_textures,
  enum metil_debug_log_level* metil_debug_log_level,
  id<MTLDevice> metal_device
) {
  metil_texture_store->length_textures = (
    0x00
  );

  metil_texture_store->textures = (
    clic3_memory_allocate_raw(
      0x00
    )
  );

  metil_texture_store->loader = [
    [
      MTKTextureLoader
      alloc
    ]
    initWithDevice: (
      metal_device
    )
  ];

  metil_texture_store->url_directory_textures = (
    url_directory_textures
  );

  metil_texture_store->debug_log_level = (
    metil_debug_log_level
  );
}

void metil_texture_store_add(
  struct metil_texture_store* metil_texture_store,
  unsigned int length_textures,
  ...
) {
  unsigned int offset_texture = (
    metil_texture_store->length_textures
  );

  metil_texture_store->length_textures = (
    metil_texture_store->length_textures +
    length_textures
  );

  clic3_memory_reallocate_raw(
    &metil_texture_store->textures,
    (
      sizeof(
        id<MTLTexture>
      ) *
      metil_texture_store->length_textures
    )
  );

  va_list textures;

  va_start(
    textures,
    length_textures
  );

  char* texture_path;

  for (
    unsigned int index_texture = (
      0x00
    );
    (
      index_texture <
      length_textures
    );
    ++index_texture
  ) {
    texture_path = (
      va_arg(
        textures,
        char*
      )
    );

    NSError* error = (
      0x00
    );

    NSString* texture_path_string = [
      [
        NSString
        alloc
      ]
      initWithUTF8String: (
        texture_path
      )
    ];

    NSURL* url_texture = [
      NSURL
      fileURLWithPath: (
        texture_path_string
      )
      isDirectory: (
        0x00
      )
      relativeToURL: (
        metil_texture_store->url_directory_textures
      )
    ];

    [
      url_texture
      retain
    ];

    id<MTLTexture> texture = [
      metil_texture_store->loader
      newTextureWithContentsOfURL: (
        url_texture
      )
      options: (
        0x00
      )
      error: &(
        error
      )
    ];

    [
      texture_path_string
      release
    ];

    if (
      error !=
      0x00
    ) {
      metil_texture_store->textures[
        offset_texture +
        index_texture
      ] = (
        0x00
      );

      NSString* string_url = (
        url_texture.path
      );

      metil_debug_log_parameters_error(
        *metil_texture_store->debug_log_level,
        "failed_to_load_texture->{%s}\n",
        0x01,
        [
          string_url
          UTF8String
        ]
      );
    } else {
      metil_texture_store->textures[
        offset_texture +
        index_texture
      ] = (
        texture
      );
    }

    [
      url_texture
      release
    ];
  }

  va_end(
    textures
  );
}

void metil_texture_store_destroy(
  struct metil_texture_store* metil_texture_store
) {
  for (
    unsigned int index_texture = (
      0x00
    );
    (
      index_texture <
      metil_texture_store->length_textures
    );
    ++index_texture
  ) {
    [
      metil_texture_store->textures[
        index_texture
      ]
      release
    ];
  }

  clic3_memory_free_raw(
    metil_texture_store->textures
  );

  [
    metil_texture_store->loader
    release
  ];
}
