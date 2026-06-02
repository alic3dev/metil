#include <metil_paths/metil_paths.h>
#include <metil_paths/metil_paths_constants.h>

#include <clic3_bytes.h>
#include <clic3_char_arrays.h>
#include <clic3_memory.h>

#include <stdlib.h>

void metil_paths_initialize(
  struct metil_paths* metil_paths,
  char* directory_root,
  char* file_configuration
) {
  metil_paths->length_directory_root = (
    0x00
  );
  
  metil_paths->length_directory_home = (
    0x00
  );

  metil_paths->length_directory_configuration = (
    0x00
  );
  
  metil_paths->length_directory_resources = (
    0x00
  );
  
  metil_paths->length_directory_textures = (
    0x00
  );

  metil_paths->length_file_configuration = (
    0x00
  );

  metil_paths_directory_root_set(
    metil_paths,
    directory_root
  );

  metil_paths_directory_home_set(
    metil_paths
  );

  metil_paths_configuration_set(
    metil_paths,
    file_configuration
  );

  metil_paths_directory_resources_set(
    metil_paths
  );

  metil_paths_directory_textures_set(
    metil_paths
  );
}

void metil_paths_directory_root_set(
  struct metil_paths* metil_paths,
  char* directory_root
) {
  unsigned int index_slash = (
    0x00
  );

  while (
    directory_root[
      metil_paths->length_directory_root
    ] !=
    '\0'
  ) {
    if (
      directory_root[
        metil_paths->length_directory_root
      ] ==
      '/'
    ) {
      index_slash = (
        metil_paths->length_directory_root
      );
    }

    metil_paths->length_directory_root = (
      metil_paths->length_directory_root +
      0x01
    );
  }

  if (
    index_slash <
    0x02
  ) {
    metil_paths->length_directory_root = (
      0x03
    );

    metil_paths->directory_root = (
      clic3_memory_allocate_raw(
        metil_paths->length_directory_root
      )
    );

    metil_paths->directory_root[
      0x00
    ] = (
      '.'
    );
    
    metil_paths->directory_root[
      0x01
    ] = (
      '/'
    );
    
    metil_paths->directory_root[
      0x02
    ] = (
      '\0'
    );
  } else {
    metil_paths->length_directory_root = (
      index_slash +
      0x02
    );

    metil_paths->directory_root = (
      clic3_memory_allocate_raw(
        metil_paths->length_directory_root
      )
    );

    clic3_bytes_copy(
      metil_paths->directory_root,
      directory_root,
      (
        metil_paths->length_directory_root -
        0x01
      )
    );

    metil_paths->directory_root[
      metil_paths->length_directory_root -
      0x01
    ] = (
      '\0'
    );
  }
}

void metil_paths_directory_home_set(
  struct metil_paths* metil_paths
) {
  metil_paths->directory_home = (
    clic3_char_arrays_concatenate(
      getenv(
        "HOME"
      ),
      "/"
    )
  );

  metil_paths->length_directory_home = (
    clic3_char_array_length(
      metil_paths->directory_home
    )
  );
}

void metil_paths_configuration_set(
  struct metil_paths* metil_paths,
  char* file_configuration
) {
  metil_paths->length_directory_configuration = (
    metil_paths->length_directory_home +
    metil_paths_length_directory_configuration
  );

  metil_paths->length_file_configuration = (
    metil_paths->length_directory_configuration +
    clic3_char_array_length(
      file_configuration
    )
  );

  metil_paths->directory_configuration = (
    clic3_char_arrays_concatenate(
      metil_paths->directory_home,
      metil_paths_directory_configuration
    )
  );

  metil_paths->file_configuration = (
    clic3_char_arrays_concatenate(
      metil_paths->directory_configuration,
      file_configuration
    )
  );
}

void metil_paths_directory_resources_set(
  struct metil_paths* metil_paths
) {
  metil_paths->length_directory_resources = (
    metil_paths->length_directory_root +
    metil_paths_length_directory_resources
  );

  metil_paths->directory_resources = (
    clic3_char_arrays_concatenate(
      metil_paths->directory_root,
      metil_paths_directory_resources
    )
  );
}

void metil_paths_directory_textures_set(
  struct metil_paths* metil_paths
) {
  metil_paths->length_directory_textures = (
    metil_paths->length_directory_resources +
    metil_paths_length_directory_textures
  );

  metil_paths->directory_textures = (
    clic3_char_arrays_concatenate(
      metil_paths->directory_resources,
      metil_paths_directory_textures
    )
  );
}

void metil_paths_destroy(
  struct metil_paths* metil_paths
) {
  clic3_memory_free_raw(
    metil_paths->directory_root
  );

  clic3_memory_free_raw(
    metil_paths->directory_home
  );

  clic3_memory_free_raw(
    metil_paths->directory_configuration
  );

  clic3_memory_free_raw(
    metil_paths->directory_resources
  );

  clic3_memory_free_raw(
    metil_paths->directory_textures
  );

  clic3_memory_free_raw(
    metil_paths->file_configuration
  );
}
