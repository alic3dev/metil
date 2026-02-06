#include <metil_text/metil_text_render_parameters.h>

#include <CoreText/CTFont.h>

void metil_text_render_parameters_initialize(
  struct metil_text_render_parameters* metil_text_render_parameters,
  char* name_family_font,
  float size
) {
  CFStringRef name_family_font_core_foundation_string = (
    __CFStringMakeConstantString(
      name_family_font
    )
  );

  metil_text_render_parameters->font = (
    CTFontCreateWithName(
      name_family_font_core_foundation_string,
      size,
      0
    )
  );

  CFRelease(
    name_family_font_core_foundation_string
  );
}
