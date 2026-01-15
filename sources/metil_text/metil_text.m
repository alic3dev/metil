#include <metil_text/metil_text.h>

#include <metil_debug/metil_debug_log.h>
#include <metil_mesh/metil_mesh_text.h>

#include <clic3_char_arrays.h>
#include <clic3_memory.h>

#include <math_c_maximum.h>

#include <CoreGraphics/CoreGraphics.h>
#include <CoreText/CoreText.h>
#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>
#include <Metal/MTLTypes.h>

CGGlyph* metil_text_glyphs_encode(
  char* characters,
  unsigned int length_characters,
  CTFontRef font,
  struct metil_configuration* metil_configuration
) {
  static CGGlyph* glyphs;
  glyphs = 0;

  clic3_memory_allocate(
    &glyphs,
    (
      sizeof(
        CGGlyph
      ) *
      length_characters
    )
  );

  UInt16 characters_unicode[length_characters];

  for (
    unsigned int index_character = 0;
    index_character < length_characters;
    ++index_character
  ) {
    characters_unicode[
      index_character
    ] = characters[
      index_character
    ];
  }

  unsigned char status_glyphs = CTFontGetGlyphsForCharacters(
    font,
    characters_unicode,
    glyphs,
    length_characters
  );

  if (!status_glyphs) {
    char* message_debug_log_error = clic3_char_arrays_concatenate(
      "failed:encode_glyphs->{",
      characters
    );

    char* message_debug_log_error_with_newline = clic3_char_arrays_concatenate(
      message_debug_log_error,
      "}\n"
    );

    metil_debug_log_error(
      metil_configuration->debug_log_level,
      message_debug_log_error_with_newline
    );

    clic3_memory_free(
      message_debug_log_error
    );

    clic3_memory_free(
      message_debug_log_error_with_newline
    );

    clic3_memory_free(
      glyphs
    );

    return (
      0
    );
  }

  return (
    glyphs
  );
}

struct metil_text_image* metil_text_render(
  char* characters,
  struct metil_text_render_parameters* metil_text_render_parameters,
  struct metil_configuration* metil_configuration
) {
  unsigned int length_characters = clic3_char_array_length(
    characters
  );

  CGGlyph* glyphs = metil_text_glyphs_encode(
    characters,
    length_characters,
    metil_text_render_parameters->font,
    metil_configuration
  );

  if (
    glyphs == 0
  ) {
    return 0;
  }

  CGRect bounding_box_glyphs[length_characters];

  CTFontGetBoundingRectsForGlyphs(
    metil_text_render_parameters->font,
    kCTFontOrientationDefault,
    glyphs,
    bounding_box_glyphs,
    length_characters
  );

  CGPoint positions_glyphs[length_characters];

  static struct metil_text_image* text_image;
  text_image = 0;

  clic3_memory_allocate(
    &text_image,
    sizeof(
      struct metil_text_image
    )
  );

  text_image->size.x = metil_text_render_parameters->padding.x;
  text_image->size.y = 0;

  for (
    unsigned char index_glyph = 0;
    index_glyph < length_characters;
    ++index_glyph
  ) {
    positions_glyphs[
      index_glyph
    ].x = (
      text_image->size.x
    );

    positions_glyphs[
      index_glyph
    ].y = (
      metil_text_render_parameters->padding.y
    );

    text_image->size.x = (
      text_image->size.x +
      bounding_box_glyphs[
        index_glyph
      ].size.width +
      metil_text_render_parameters->letter_spacing
    );

    text_image->size.y = (
      math_c_maximum_float(
        text_image->size.y,
        bounding_box_glyphs[
          index_glyph
        ].size.height
      )
    );
  }

  text_image->size.x = text_image->size.x + metil_text_render_parameters->padding.x;
  text_image->size.y = text_image->size.y + metil_text_render_parameters->padding.y;

  unsigned int length_text_image_data = (
    4 * (text_image->size.x) * (text_image->size.y)
  );

  text_image->data = 0;

  clic3_memory_allocate(
    &text_image->data,
    (
      sizeof(
        unsigned char
      ) *
      length_text_image_data
    )
  );

  for (
    unsigned int index_pixel = 0;
    index_pixel < length_text_image_data;
    index_pixel = index_pixel + 4
  ) {
    unsigned char value = 0;

    text_image->data[index_pixel] = value;
    text_image->data[index_pixel + 1] = value;
    text_image->data[index_pixel + 2] = value;
    text_image->data[index_pixel + 3] = value;
  }

  CGColorSpaceRef color_space = CGColorSpaceCreateWithName(
    kCGColorSpaceSRGB
  );

  if (
    color_space == 0
  ) {
    metil_debug_log_error(
      metil_configuration->debug_log_level,
      "couldn't create color space\n"
    );
  }

  CGContextRef context_bitmap = CGBitmapContextCreate(
    text_image->data,
    text_image->size.x,
    text_image->size.y,
    8,
    4 * (text_image->size.x),
    color_space,
    0x0 | kCGImageAlphaNoneSkipFirst
  );

  if (
    context_bitmap == 0
  ) {
    metil_debug_log_error(
      metil_configuration->debug_log_level,
      "failed_to_create->{CGBitmapContext}\n"
    );

    return 0;
  }

  CTFontDrawGlyphs(
    metil_text_render_parameters->font,
    glyphs,
    positions_glyphs,
    length_characters,
    context_bitmap
  );

  CGContextRelease(
    context_bitmap
  );

  CGColorSpaceRelease(
    color_space
  );

  clic3_memory_free(
    glyphs
  );

  for (
    unsigned int index_pixel = 0;
    index_pixel < length_text_image_data;
    index_pixel = index_pixel + 4
  ) {
    unsigned char value = text_image->data[index_pixel];

    text_image->data[index_pixel + 1] = value;
    text_image->data[index_pixel + 2] = value;
    text_image->data[index_pixel + 3] = value;
  }

  return text_image;
}

id<MTLTexture> metil_text_texture_render(
  id<MTLDevice> metal_device,
  struct metil_text_image* text_image,
  struct metil_configuration* metil_configuration
) {
  MTLTextureDescriptor* texture_descriptor = [[MTLTextureDescriptor alloc] init];

  texture_descriptor.pixelFormat = MTLPixelFormatBGRA8Unorm;

  texture_descriptor.width = text_image->size.x;
  texture_descriptor.height = text_image->size.y;

  id<MTLTexture> texture = [metal_device
    newTextureWithDescriptor: texture_descriptor
  ];

  [texture_descriptor release];

  MTLRegion region = {
    {0, 0, 0},
    {text_image->size.x, text_image->size.y, 1}
  };

  [texture
    replaceRegion: region
    mipmapLevel: 0
    withBytes: text_image->data
    bytesPerRow: 4 * (text_image->size.x)
  ];

  return texture;
}

id<MTLTexture> metil_text_mesh_with_texture_initialize(
  id<MTLDevice> metal_device,
  struct metil_mesh* mesh,
  char* characters,
  struct metil_text_render_parameters* metil_text_render_parameters,
  struct metil_configuration* metil_configuration
) {
  struct metil_text_image* text_image = metil_text_render(
    characters,
    metil_text_render_parameters,
    metil_configuration
  );

  if (
    text_image == 0
  ) {
    metil_debug_log_error(
      metil_configuration->debug_log_level,
      "failed_to_render_text_image\n"
    );

    return 0;
  }

  metil_mesh_text_initialize(
    mesh,
    text_image->size.x,
    text_image->size.y,
    metil_text_render_parameters->scale
  );

  id<MTLTexture> texture = metil_text_texture_render(
    metal_device,
    text_image,
    metil_configuration
  );

  metil_text_image_destroy(
    text_image
  );

  return texture;
}

void metil_text_image_destroy(
  struct metil_text_image* text_image
) {
  clic3_memory_free(
    text_image->data
  );
  
  clic3_memory_free(
    text_image
  );
}

void metil_text_destroy(
  struct metil_text_render_parameters* metil_text_render_parameters
) {
  CFRelease(
    metil_text_render_parameters->font
  );
}
