#ifndef __metil_paths_metil_paths_foundation_h
#define __metil_paths_metil_paths_foundation_h

#include <metil_paths/metil_paths.h>

#include <Foundation/NSURL.h>

struct metil_paths_foundation {
  NSString* _Nonnull string_directory_textures;

  NSURL* _Nonnull url_directory_textures;
};

void metil_paths_foundation_initialize(
  struct metil_paths_foundation* _Nonnull,
  struct metil_paths* _Nonnull
);

void metil_paths_foundation_destroy(
  struct metil_paths_foundation* _Nonnull
);

#endif
