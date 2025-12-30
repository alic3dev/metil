#ifndef __metil_paths_metil_paths_h
#define __metil_paths_metil_paths_h

struct metil_paths {
  char* directory_root;
  char* directory_home;

  char* directory_configuration;
  char* directory_resources;
  char* directory_textures;

  char* file_configuration;

  unsigned int length_directory_root;
  unsigned int length_directory_home;

  unsigned int length_directory_configuration;
  unsigned int length_directory_resources;
  unsigned int length_directory_textures;

  unsigned int length_file_configuration;
};

extern struct metil_paths metil_paths;

void metil_paths_initialize(
  char*,
  char*
);

void metil_paths_directory_root_set(
  char*
);

void metil_paths_directory_home_set();

void metil_paths_configuration_set(
  char*
);

void metil_paths_directory_resources_set();
void metil_paths_directory_textures_set();

void metil_paths_destroy();

#endif
