#ifndef __metil_metil_texture_store_h
#define __metil_metil_texture_store_h

#include <metil_debug/metil_debug_log_level.h>

#include <Foundation/NSURL.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>
#include <MetalKit/MTKTextureLoader.h>

struct metil_texture_store {
  id<MTLTexture>* textures;
  unsigned int length_textures;
  
  MTKTextureLoader* loader;
  
  NSURL* url_directory_textures;
  
  enum metil_debug_log_level* debug_log_level;
};

void metil_texture_store_initialize(
  struct metil_texture_store*,
  NSURL*,
  enum metil_debug_log_level*,
  id<MTLDevice>
);

void metil_texture_store_add(
  struct metil_texture_store*,
  unsigned int length_texturs,
  ...
);

void metil_texture_store_destroy(
  struct metil_texture_store*
);

#endif
