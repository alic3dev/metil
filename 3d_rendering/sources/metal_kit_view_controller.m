#import <metal_kit_view_controller.h>
#import <metal_kit_renderer.h>

@implementation metal_kit_view_controller {
  MTKView* metal_kit_view;
  metal_kit_renderer* renderer;
}

- (void) viewDidLoad {
  [super viewDidLoad];

  metal_kit_view = (MTKView*) self.view;
  metal_kit_view.device = MTLCreateSystemDefaultDevice();

  renderer = [
    [metal_kit_renderer alloc]
    initWithMetalKitView: metal_kit_view
  ];

  [renderer
    drawableSizeWillChange: metal_kit_view.bounds.size
  ];

  metal_kit_view.delegate = self;
}

- (void) drawInMTKView: (nonnull MTKView*) _metal_kit_view {
  [renderer
    drawInMTKView: _metal_kit_view
  ];
}

- (void) mtkView: (nonnull MTKView*) _metal_kit_view drawableSizeWillChange: (CGSize) size {
  [renderer
    drawableSizeWillChange: _metal_kit_view.bounds.size
  ];
}

@end
