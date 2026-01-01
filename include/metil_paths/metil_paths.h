#ifndef __metil_paths_metil_paths_h
#define __metil_paths_metil_paths_h

struct metil_paths {
  char* _Nonnull directory_root;
  char* _Nonnull directory_home;

  char* _Nonnull directory_configuration;
  char* _Nonnull directory_resources;
  char* _Nonnull directory_textures;

  char* _Nonnull file_configuration;

  unsigned int length_directory_root;
  unsigned int length_directory_home;

  unsigned int length_directory_configuration;
  unsigned int length_directory_resources;
  unsigned int length_directory_textures;

  unsigned int length_file_configuration;
};

void metil_paths_initialize(
  struct metil_paths* _Nonnull,
  char* _Nonnull,
  char* _Nonnull
);

void metil_paths_directory_root_set(
  struct metil_paths* _Nonnull,
  char* _Nonnull
);

void metil_paths_directory_home_set(
  struct metil_paths* _Nonnull
);

void metil_paths_configuration_set(
  struct metil_paths* _Nonnull,
  char* _Nonnull
);

void metil_paths_directory_resources_set(
  struct metil_paths* _Nonnull
);

void metil_paths_directory_textures_set(
  struct metil_paths* _Nonnull
);

void metil_paths_destroy(
  struct metil_paths* _Nonnull
);

#endif
