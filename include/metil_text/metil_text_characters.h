#ifndef __metil_text_metil_text_characters_h
#define __metil_text_metil_text_characters_h

#include <metil_configuration/metil_configuration.h>
#include <metil_mesh/metil_mesh.h>
#include <metil_text/metil_text.h>
#include <metil_text/metil_text_render_parameters.h>

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

void metil_text_characters_initialize(
  struct metil_text_characters* _Nonnull,
  _Nonnull id<MTLDevice>,
  struct metil_configuration* _Nonnull,
  struct metil_text_render_parameters* _Nonnull
);

void metil_text_characters_destroy(
  void* _Nonnull
);

#endif
