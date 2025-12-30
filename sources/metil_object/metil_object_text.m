#include <metil_object/metil_object_text.h>

#include <metil_object/metil_object.h>
#include <metil_text/metil_text.h>

#include <Metal/MTLArgument.h>
#include <Metal/MTLDevice.h>
#include <Metal/MTLRenderCommandEncoder.h>

unsigned char metil_object_text_index_pipeline_render_default = 0;

void metil_object_text_initialize(
  struct metil_object* metil_object,
  char* metil_object_text_char_array,
  id<MTLDevice> metal_device
) {
  metil_object->index_pipeline_render = (
    metil_object_text_index_pipeline_render_default
  );

  id<MTLTexture> metil_object_text_texture = (
    metil_text_mesh_with_texture_initialize(
      metal_device,
      &metil_object->mesh,
      metil_object_text_char_array,
      &metil_text_render_parameters_default
    )
  );

  metil_object_buffers_initialize(
    metil_object,
    metal_device
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
