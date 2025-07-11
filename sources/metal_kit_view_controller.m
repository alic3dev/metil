#import <metal_kit_view_controller.h>
#import <metal_kit_renderer.h>

#include <MetalKit/MetalKit.h>

@implementation metal_kit_view_controller {
  MTKView* metal_kit_view;
  metal_kit_renderer* metal_kit_view_delegate;
}

- (void) viewDidLoad {
  [super viewDidLoad];

  metal_kit_view = (MTKView*) self.view;
  metal_kit_view.enableSetNeedsDisplay = NO;
  metal_kit_view.device = MTLCreateSystemDefaultDevice();

  if (!metal_kit_view.device) {
    fprintf(
      stderr,
      "unable_to_create_a_metal_device\n"
    );
  }

  metal_kit_view.clearColor = MTLClearColorMake(
    0.0f,
    0.0f,
    0.0f,
    1.0f
  );

  metal_kit_view_delegate = [[metal_kit_renderer alloc] initWithMetalKitView: metal_kit_view];

  if (metal_kit_view_delegate == (void*)0) {
    fprintf(
      stderr,
      "metal_kit_view_delegate_initialization_failure\n"
    );

    return;
  }

  [metal_kit_view_delegate mtkView: metal_kit_view drawableSizeWillChange: metal_kit_view.drawableSize];

  metal_kit_view.delegate = metal_kit_view_delegate;
}

@end
