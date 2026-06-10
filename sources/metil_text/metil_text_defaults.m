#include <metil_text/metil_text_defaults.h>

#include <metil_configuration/metil_configuration.h>
#include <metil_debug/metil_debug_log.h>
#include <metil_text/metil_text_render_parameters.h>

void metil_text_defaults_initialize(
  struct metil_text_defaults* metil_text_defaults,
  struct metil_configuration* metil_configuration
) {
  metil_text_defaults->object_text_index_pipeline_render = (
    0x00
  );

  metil_text_render_parameters_initialize(
    &metil_text_defaults->render_parameters,
    "Monaco",
    0x30
  );

  metil_text_defaults->render_parameters.letter_width_style = (
    metil_text_render_parameters_letter_width_style_default
  );

  metil_text_defaults->render_parameters.letter_width = (
    0x00
  );

  metil_text_defaults->render_parameters.letter_spacing = (
    0x06
  );

  metil_text_defaults->render_parameters.padding.x = (
    0x14
  );
  
  metil_text_defaults->render_parameters.padding.y = (
    0x14
  );

  metil_text_defaults->render_parameters.scale = (
    0.0008f
  );
}

void metil_text_defaults_destroy(
  struct metil_text_defaults* metil_text_defaults
) {
  metil_text_render_parameters_destroy(
    &metil_text_defaults->render_parameters
  );
}
