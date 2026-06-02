#include <metil_paths/metil_paths_foundation.h>

#include <metil_paths/metil_paths.h>

void metil_paths_foundation_initialize(
  struct metil_paths_foundation* metil_paths_foundation,
  struct metil_paths* metil_paths
) {
  metil_paths_foundation->string_directory_textures = [
    [
      NSString
      alloc
    ]
    initWithUTF8String: (
      metil_paths->directory_textures
    )
  ];    
  metil_paths_foundation->url_directory_textures = [
    NSURL
    fileURLWithPath: (
      metil_paths_foundation->string_directory_textures
    )
    isDirectory: (
      0x01
    )
  ]; 
  
  [
    metil_paths_foundation->string_directory_textures
    retain
  ];
  
  [
    metil_paths_foundation->url_directory_textures
    retain
  ]; 
}

void metil_paths_foundation_destroy(
  struct metil_paths_foundation* metil_paths_foundation
) {
  [
    metil_paths_foundation->string_directory_textures
    release
  ];
  
  [
    metil_paths_foundation->url_directory_textures
    release
  ];
}
