#include <metil_paths/paths.h>
#include <metil_paths/paths_constants.h>

#include <clic3_char_arrays.h>
#include <clic3_bytes.h>

#include <stdlib.h>

struct metil_paths metil_paths;

void metil_paths_initialize(
  char* directory_root,
  char* file_configuration
) {
  metil_paths.length_directory_root = 0;
  metil_paths.length_directory_home = 0;

  metil_paths.length_directory_configuration = 0;
  metil_paths.length_directory_resources = 0;
  metil_paths.length_directory_textures = 0;

  metil_paths.length_file_configuration = 0;

  metil_paths_directory_root_set(
    directory_root
  );

  metil_paths_directory_home_set();

  metil_paths_configuration_set(
    file_configuration
  );

  metil_paths_directory_resources_set();
  metil_paths_directory_textures_set();
}

void metil_paths_directory_root_set(
  char* directory_root
) {
  unsigned int index_slash = 0;

  while (
    directory_root[
      metil_paths.length_directory_root
    ] != '\0'
  ) {
    if (
      directory_root[
        metil_paths.length_directory_root
      ] == '/'
    ) {
      index_slash = metil_paths.length_directory_root;
    }

    metil_paths.length_directory_root = (
      metil_paths.length_directory_root + 1
    );
  }

  if (index_slash < 2) {
    metil_paths.length_directory_root = 3;

    metil_paths.directory_root = malloc(
      sizeof(char) *
      metil_paths.length_directory_root
    );

    metil_paths.directory_root[0] = '.';
    metil_paths.directory_root[1] = '/';
    metil_paths.directory_root[2] = '\0';
  } else {
    metil_paths.length_directory_root = index_slash + 2;

    metil_paths.directory_root = malloc(
      sizeof(char) * metil_paths.length_directory_root
    );

    clic3_bytes_copy(
      metil_paths.directory_root,
      directory_root,
      metil_paths.length_directory_root - 1
    );

    metil_paths.directory_root[
      metil_paths.length_directory_root - 1
    ] = '\0';
  }
}

void metil_paths_directory_home_set() {
  metil_paths.directory_home = clic3_char_arrays_concatenate(
    getenv("HOME"),
    "/"
  );

  metil_paths.length_directory_home = clic3_char_array_length(
    metil_paths.directory_home
  );
}

void metil_paths_configuration_set(
  char* file_configuration
) {
  metil_paths.length_directory_configuration = (
    metil_paths.length_directory_home +
    metil_paths_length_directory_configuration
  );

  metil_paths.length_file_configuration = (
    metil_paths.length_directory_configuration +
    clic3_char_array_length(
      file_configuration
    )
  );

  metil_paths.directory_configuration = clic3_char_arrays_concatenate(
    metil_paths.directory_home,
    metil_paths_directory_configuration
  );

  metil_paths.file_configuration = clic3_char_arrays_concatenate(
    metil_paths.directory_configuration,
    file_configuration
  );
}

void metil_paths_directory_resources_set() {
  metil_paths.length_directory_resources = (
    metil_paths.length_directory_root +
    metil_paths_length_directory_resources
  );

  metil_paths.directory_resources = clic3_char_arrays_concatenate(
    metil_paths.directory_root,
    metil_paths_directory_resources
  );
}

void metil_paths_directory_textures_set() {
  metil_paths.length_directory_textures = (
    metil_paths.length_directory_resources +
    metil_paths_length_directory_textures
  );

  metil_paths.directory_textures = clic3_char_arrays_concatenate(
    metil_paths.directory_resources,
    metil_paths_directory_textures
  );
}

void metil_paths_destroy() {
  free(metil_paths.directory_root);
  free(metil_paths.directory_home);

  free(metil_paths.directory_configuration);
  free(metil_paths.directory_resources);
  free(metil_paths.directory_textures);

  free(metil_paths.file_configuration);
}
