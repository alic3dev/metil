#include <metil_rendering/metil_descriptors/metil_pipeline_render.h>

#include <Metal/MTLRenderPipeline.h>

void metil_rendering_descriptors_pipeline_render_initialize(
  MTLRenderPipelineDescriptor* descriptor_pipeline_render,
  unsigned long count_samples,
  id<MTLFunction> function_fragment,
  id<MTLFunction> function_vertex,
  MTLPixelFormat format_pixel_colour_attachment,
  MTLPixelFormat format_pixel_depth,
  MTLPixelFormat format_pixel_stencil
) {
  descriptor_pipeline_render.rasterSampleCount = count_samples;

  descriptor_pipeline_render.fragmentFunction = function_fragment;
  descriptor_pipeline_render.vertexFunction = function_vertex;

  descriptor_pipeline_render.colorAttachments[0].pixelFormat = format_pixel_colour_attachment;
  descriptor_pipeline_render.colorAttachments[0].blendingEnabled = 1;
  descriptor_pipeline_render.colorAttachments[0].rgbBlendOperation = MTLBlendOperationAdd;
  descriptor_pipeline_render.colorAttachments[0].alphaBlendOperation = MTLBlendOperationAdd;
  descriptor_pipeline_render.colorAttachments[0].sourceRGBBlendFactor = MTLBlendFactorSourceAlpha;
  descriptor_pipeline_render.colorAttachments[0].sourceAlphaBlendFactor = MTLBlendFactorSourceAlpha;
  descriptor_pipeline_render.colorAttachments[0].destinationRGBBlendFactor = MTLBlendFactorOneMinusSourceAlpha;
  descriptor_pipeline_render.colorAttachments[0].destinationAlphaBlendFactor = MTLBlendFactorOneMinusSourceAlpha;

  descriptor_pipeline_render.depthAttachmentPixelFormat = format_pixel_depth;
  descriptor_pipeline_render.stencilAttachmentPixelFormat = format_pixel_stencil;
}
