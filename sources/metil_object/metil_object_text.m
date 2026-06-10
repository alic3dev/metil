#include <metil_object/metil_object_text.h>

#include <metil.h>
#include <metil_object/metil_object.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>
#include <metil_text/metil_text.h>
#include <metil_text/metil_text_render_parameters.h>

#include <Metal/MTLRenderCommandEncoder.h>

void metil_object_text_initialize(
  struct metil* metil,
  struct metil_object* metil_object_text,
  char* metil_object_text_char_array
) {
  metil_object_text_initialize_with_parameters(
    metil,
    metil_object_text,
    &metil->text_defaults.render_parameters,
    metil_object_text_char_array
  );
}

void metil_object_text_initialize_with_parameters(
  struct metil* metil,
  struct metil_object* metil_object_text,
  struct metil_text_render_parameters* metil_text_render_parameters,
  char* metil_object_text_char_array
) {
  metil_object_text->index_pipeline_render = (
    metil->text_defaults.object_text_index_pipeline_render
  );

  id<MTLTexture> metil_object_text_texture = (
    metil_text_mesh_with_texture_initialize(
      metil->renderer_interface.metal_device,
      &metil_object_text->mesh,
      metil_object_text_char_array,
      metil_text_render_parameters,
      &metil->configuration
    )
  );

  metil_object_text->positioning = (
    metil_positioning_static
  );

  metil_object_buffers_initialize(
    metil_object_text,
    metil->renderer_interface.metal_device
  );

  struct metil_renderer_data_object* metil_renderer_data_object_text = (
    metil_object_text->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  metil_renderer_data_object_text->colour.x = (
    0x01
  );

  metil_renderer_data_object_text->colour.y = (
    0x01
  );

  metil_renderer_data_object_text->colour.z = (
    0x01
  );

  metil_renderer_data_object_text->colour.w = (
    0x01
  );

  metil_object_texture_add(
    metil_object_text,
    metil_object_text_texture
  );

  metil_object_text->destroy = (
    metil_object_destroy_with_textures
  );
}
