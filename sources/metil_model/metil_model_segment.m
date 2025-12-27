#include <metil_model/metil_model_segment.h>

#include <metil_object/metil_object_buffer.h>

#include <Metal/MTLArgument.h>
#include <Metal/MTLRenderCommandEncoder.h>

void metil_model_segment_initialize(
  struct metil_model_segment* metil_model_segment
) {
  metil_model_segment->length_buffers_fragment = 0;
  metil_model_segment->length_buffers_vertex = 0;  

  metil_model_segment->buffers_fragment = malloc(
    sizeof(struct metil_object_buffer) *
    metil_model_segment->length_buffers_fragment
  );

  metil_model_segment->buffers_vertex = malloc(
    sizeof(struct metil_object_buffer) *
    metil_model_segment->length_buffers_vertex
  );

  metil_model_segment->indices = (void*) 0;

  metil_model_segment->type_primitive = MTLPrimitiveTypeTriangle;
  metil_model_segment->type_index = MTLIndexTypeUInt32;

  metil_model_segment->length_textures = 0;
  metil_model_segment->textures = malloc(
    sizeof(id<MTLTexture>) *
    metil_model_segment->length_textures
  );

  metil_model_segment->depth_disabled = 0;
  metil_model_segment->index_pipeline_render = 0;
  metil_model_segment->visible = 1;
}
