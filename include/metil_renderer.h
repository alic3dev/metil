#ifndef __metal_kit_renderer_h
#define __metal_kit_renderer_h

#include <metil_shader_types.h>

#include <MetalKit/MetalKit.h>

@interface metal_kit_renderer : NSObject<MTKViewDelegate>

- (nonnull instancetype) initWithMetalKitView: (nonnull MTKView*) metal_kit_view;
- (void) drawInMTKView: (nonnull MTKView*) metal_kit_view;
- (void) drawableSizeWillChange: (CGSize) size;

@property (nonatomic) float position;

@end

#endif
