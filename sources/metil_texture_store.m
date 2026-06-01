#include <metil_texture_store.h>

#include <clic3_memory.h>

#include <metil_debug/metil_debug_log.h>

#include <Metal/MTLTexture.h>
#include <MetalKit/MTKTextureLoader.h>

#include <stdarg.h>
#include <stdio.h>

void metil_texture_store_initialize(
  struct metil_texture_store* metil_texture_store,
  char* path_directory_textures,
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
  
  metil_texture_store->path_directory_textures = (
    path_directory_textures
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
    
    id<MTLTexture> texture = [
      metil_texture_store->loader
      newTextureWithContentsOfURL: [
        NSURL
        fileURLWithPath: (
          texture_path_string
        )
        isDirectory: (
          0x00
        )
        relativeToURL: [
          NSURL
          fileURLWithPath:[
            NSString
            stringWithUTF8String: (
              metil_texture_store->path_directory_textures
            )
          ]
          isDirectory: (
            0x01
          )
        ]
      ]
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
      
      metil_debug_log_error(
        *metil_texture_store->debug_log_level,
        "failed_to_load_texture"
      );
    } else {
      metil_texture_store->textures[
        offset_texture +
        index_texture
      ] = (
        texture
      );
    }
  }  
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
