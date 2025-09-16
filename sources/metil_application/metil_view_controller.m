#include <metil_application/metil_view_controller.h>

#include <metil_application/metil_view.h>
#include <metil_rendering/metil_renderer.h>

@implementation metil_view_controller {
  metil_view* view;
  metil_renderer* renderer;
}

- (void) viewDidLoad {
  [super viewDidLoad];

  view = (metil_view*) self.view;
  view.device = MTLCreateSystemDefaultDevice();

  renderer = [
    [metil_renderer alloc]
    initWithMetalKitView: view
  ];

  [renderer
    drawableSizeWillChange: view.bounds.size
  ];

  view.delegate = self;
}

- (void) drawInMTKView: (nonnull metil_view*) _view {
  [renderer
    drawInMTKView: _view
  ];
}

- (void) mtkView: (nonnull metil_view*) _view drawableSizeWillChange: (CGSize) size {
  [renderer
    drawableSizeWillChange: _view.bounds.size
  ];
}

@end
