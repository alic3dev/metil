#include <metil_text/metil_text_characters.h>

#include <metil_text/metil_text.h>

#include <clic3_memory.h>

#include <math_c_vector.h>

#include <Metal/MTLBuffer.h>
#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

void metil_text_characters_initialize(
  struct metil_text_characters* metil_text_characters_default,
  id<MTLDevice> metal_device,
  struct metil_configuration* metil_configuration,
  struct metil_text_render_parameters* metil_text_render_parameters
) {
  metil_text_characters_default->length_characters = (
    metil_text_characters_length_default
  );

  metil_text_characters_default->meshes = (
    clic3_memory_allocate_raw(
      sizeof(
        struct metil_mesh
      ) *
      metil_text_characters_default->length_characters
    )
  );

  metil_text_characters_default->vertices = (
    clic3_memory_allocate_raw(
      sizeof(
        id<MTLTexture>
      ) *
      metil_text_characters_default->length_characters
    )
  );

  metil_text_characters_default->textures = (
    clic3_memory_allocate_raw(
      sizeof(
        id<MTLTexture>
      ) *
      metil_text_characters_default->length_characters
    )
  );

  char character_array[2] = { 0, '\0' };

  struct metil_text_render_parameters text_render_parameters = {
    .font = metil_text_render_parameters->font,
    .letter_width_style = metil_text_render_parameters_letter_width_style_fixed,
    .letter_width = 30.0f,
    .letter_spacing = 0.0f,
    .padding = {
      .x = 0.0f,
      .y = 8.0f
    },
    .scale = 0.0005f
  };

  for (
    unsigned char index_character = 0;
    index_character < metil_text_characters_default->length_characters;
    ++index_character
  ) {
    if (
      index_character < ' ' ||
      index_character > '~'
    ) {
      character_array[0] = ' ';
    } else {
      character_array[0] = index_character;
    }

    metil_text_characters_default->textures[
      index_character
    ] = (
      metil_text_mesh_with_texture_initialize(
        metal_device,
        &metil_text_characters_default->meshes[
          index_character
        ],
        character_array,
        &text_render_parameters,
        metil_configuration
      )
    );

    metil_text_characters_default->vertices[
      index_character
    ] = [metal_device
      newBufferWithBytes: (
        metil_text_characters_default->meshes[
          index_character
        ].vertices
      )
      length: (
        metil_text_characters_default->meshes[
          index_character
        ].length_vertices *
        sizeof(
          struct math_c_vector4_float
        )
      )
      options: MTLResourceStorageModeShared
    ];
  }

  metil_text_characters_default->indices = [metal_device
    newBufferWithBytes: metil_text_characters_default->meshes[0].indices
    length: (
      sizeof(
        unsigned int
      ) *
      metil_text_characters_default->meshes[0].length_indices
    )
    options: MTLResourceStorageModeShared
  ];
}

void metil_text_characters_destroy(
  void* data
) {
  struct metil_text_characters* metil_text_characters_default = (
    data
  );

  for (
    unsigned char index_character = 0;
    index_character < metil_text_characters_default->length_characters;
    ++index_character
  ) {
    metil_mesh_destroy(
      &metil_text_characters_default->meshes[
        index_character
      ]
    );

    [
      metil_text_characters_default->vertices[
        index_character
      ]
      release
    ];

    [
      metil_text_characters_default->textures[
        index_character
      ]
      release
    ];
  }

  [
    metil_text_characters_default->indices
    release
  ];

  clic3_memory_free_raw(
    metil_text_characters_default->meshes
  );

  clic3_memory_free_raw(
    metil_text_characters_default->vertices
  );

  clic3_memory_free_raw(
    metil_text_characters_default->textures
  );
}
