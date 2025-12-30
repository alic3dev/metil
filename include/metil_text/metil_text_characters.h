#ifndef __metil_text_metil_text_characters_h
#define __metil_text_metil_text_characters_h

#include <metil_mesh/metil_mesh.h>

#include <Metal/MTLBuffer.h>
#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

#define metil_text_characters_length_default 126

struct metil_text_characters {
  char length_characters;

  struct metil_mesh* _Nonnull meshes;
  _Nonnull id<MTLBuffer> indices;
  _Nonnull id<MTLBuffer>* _Nonnull vertices;
  _Nonnull id<MTLTexture>* _Nonnull textures;
};

extern struct metil_text_characters metil_text_characters_default;

void metil_text_characters_initialize(
  _Nonnull id<MTLDevice>
);

void metil_text_characters_destroy();

#endif
