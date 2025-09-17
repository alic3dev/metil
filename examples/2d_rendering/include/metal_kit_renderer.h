#ifndef __metil_metal_kit_renderer_h
#define __metil_metal_kit_renderer_h

#include <MetalKit/MetalKit.h>

@interface metal_kit_renderer : NSObject<MTKViewDelegate>

- (nonnull instancetype) initWithMetalKitView: (nonnull MTKView*) mtkView;

@end

#endif
