#include <metil_text/metil_text_render_parameters.h>

#include <CoreText/CTFont.h>
#include <Foundation/NSObject.h>
#include <Foundation/NSString.h>

void metil_text_render_parameters_initialize(
  struct metil_text_render_parameters* metil_text_render_parameters,
  char* name_family_font,
  float size
) {
  NSString* string_name_family_font = [
    [
      NSString
      alloc
    ]
    initWithUTF8String: (
      name_family_font
    )
  ];

  metil_text_render_parameters->font = (
    CTFontCreateWithName(
      (
        (CFStringRef)
        string_name_family_font
      ),
      size,
      0x00
    )
  );

  [
    string_name_family_font
    release
  ];
}

void metil_text_render_parameters_destroy(
  struct metil_text_render_parameters* metil_text_render_parameters
) {
  CFRelease(
    metil_text_render_parameters->font
  );
}
