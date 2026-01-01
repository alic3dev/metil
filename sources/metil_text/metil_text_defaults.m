#include <metil_text/metil_text_defaults.h>

#include <metil_configuration/metil_configuration.h>
#include <metil_debug/metil_debug_log.h>

void metil_text_defaults_initialize(
  struct metil_text_defaults* metil_text_defaults,
  struct metil_configuration* metil_configuration
) {
  metil_text_defaults->object_text_index_pipeline_render = 0;

  metil_text_defaults->render_parameters.font = (
    (void*) 0
  );

  metil_text_defaults->render_parameters.letter_spacing = 2;
    
  metil_text_defaults->render_parameters.padding.x = 5;
  metil_text_defaults->render_parameters.padding.y = 15;

  metil_text_defaults->render_parameters.scale = 0.001f;

  CFStringRef name_family_font_monospace = CFSTR(
    "monospace"
  );

  metil_text_defaults->render_parameters.font = CTFontCreateWithName(
    name_family_font_monospace,
    48.0,
    (void*) 0
  );

  CFRelease(
    name_family_font_monospace
  );
}
