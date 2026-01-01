#include <metil_object/metil_object_text.h>

#include <metil.h>
#include <metil_object/metil_object.h>
#include <metil_text/metil_text.h>

#include <Metal/MTLRenderCommandEncoder.h>

void metil_object_text_initialize(
  struct metil* metil,
  struct metil_object* metil_object,
  char* metil_object_text_char_array
) {
  metil_object->index_pipeline_render = (
    metil->object_text_index_pipeline_render_default
  );

  id<MTLTexture> metil_object_text_texture = (
    metil_text_mesh_with_texture_initialize(
      metil->renderer_interface.metal_device,
      &metil_object->mesh,
      metil_object_text_char_array,
      &metil_text_render_parameters_default,
      &metil->configuration
    )
  );

  metil_object_buffers_initialize(
    metil_object,
    metil->renderer_interface.metal_device
  );

  metil_object->positioning = (
    metil_positioning_static
  );

  metil_object_texture_add(
    metil_object,
    metil_object_text_texture
  );

  metil_object->destroy = (
    metil_object_destroy_with_textures
  );
}
