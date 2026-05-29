#include <metil_editor_paths.h>

#include <clic3_bytes.h>
#include <clic3_char_arrays.h>
#include <clic3_memory.h>

#include <stdio.h>

void metil_editor_paths_parse(
  char* path,
  char** name,
  char** path_metil_mesh,
  char** path_c,
  char** path_h
) {
  unsigned int length_path = (
    clic3_char_array_length(
      path
    )
  );

  unsigned int index_extension = (
    0x00
  );

  unsigned int index_slash = (
    0x00
  );

  unsigned char status = (
    0b00000000
  );

  for (
    unsigned int index_character = (
      0x00
    );
    (
      index_character <
      length_path
    );
    ++index_character
  ) {
    unsigned int index_character_path = (
      length_path -
      index_character -
      0x01
    );

    char character = (
      path[
        index_character_path
      ]
    );

    switch (
      character
    ) {
      case '.': {
        if (
          (
            status &
            0b11000000
          ) !=
          0x00
        ) {
          break;
        }

        if (
          clic3_char_arrays_equal(
            (
              path +
              index_character_path
            ),
            ".metil_mesh"
          )
        ) {
          status = (
            status |
            0b11000000
          );

          index_extension = (
            index_character_path
          );
        } else {
          status = (
            status |
            0b01000000
          );
        }

        break;
      }
      case '/': {
        index_slash = (
          index_character_path
        );

        status = (
          status |
          0b00000001
        );

        break;
      }
      default: {
        break;
      }
    }

    if (
      (
        status &
        0b00000001
      ) !=
      0x00
    ) {
      break;
    }
  }

  unsigned int length_name = (
    length_path -
    index_slash -
    (
      status &
      0b00000001
    ) -
    (
      (
        (
          status &
          0b10000000
        ) ==
        0x00
      )
      ? 0x00
      : (
        length_path -
        index_extension
      )
    )
  );

  *name = (
    clic3_memory_allocate_raw(
      length_name +
      0x01
    )
  );

  clic3_bytes_copy(
    *name,
    (
      path +
      length_path -
      length_name +
      (
        status &
        0b00000001
      ) -

      (
        (
          (
            status &
            0b10000000
          ) ==
          0x00
        )
        ? 0x00
        : (
          length_path -
          index_extension
        )
      ) -
      0x01
    ),
    length_name
  );

  (*name)[
    length_name
  ] = (
    '\0'
  );

  if (
    (
      status &
      0b10000000
    ) ==
    0x00
  ) {
    *path_metil_mesh = (
      clic3_char_arrays_concatenate(
        *name,
        ".metil_mesh"
      )
    );
  } else {
    unsigned int length_path_metil_mesh = (
      length_path -
      index_slash -
      (
        status &
        0b00000001
      )
    );

    *path_metil_mesh = (
      clic3_memory_allocate_raw(
        length_path_metil_mesh +
        0x01
      )
    );

    clic3_bytes_copy(
      *path_metil_mesh,
      (
        path +
        length_path -
        length_path_metil_mesh
      ),
      length_path_metil_mesh
    );

    (*path_metil_mesh)[
      length_path_metil_mesh
    ] = (
      '\0'
    );
  }

  *path_c = (
    clic3_char_arrays_concatenate(
      *name,
      ".c"
    )
  );

  *path_h = (
    clic3_char_arrays_concatenate(
      *name,
      ".h"
    )
  );
}
