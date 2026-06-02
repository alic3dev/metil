#include <metil_application/metil_view_controller.h>

#include <metil_application/metil_application.h>
#include <metil_application/metil_application_functions.h>
#include <metil_application/metil_application_mapping.h>
#include <metil_application/metil_view.h>
#include <metil_application/metil_window.h>
#include <metil_rendering/metil_renderer.h>

#include <QuartzCore/CAMetalLayer.h>

metil_view_controller_on_view_did_load_function metil_view_controller_on_view_did_load = 0;

@implementation metil_view_controller {
  metil_view* view;
  metil_renderer* renderer;
}

- (void) viewDidLoad {
  [
    super
    viewDidLoad
  ];

  if (
    metil_view_controller_on_view_did_load !=
    0x00
  ) {
    metil_view_controller_on_view_did_load();
  }

  metil_application* metil_application_shared = (
    (metil_application*) [
      metil_application
      sharedApplication
    ]
  );

  self->metil = (
    metil_application_shared->metil
  );

  view = (
    (metil_view*)
    self.view
  );

  view->metil = (
    self->metil
  );

  view.device = (
    MTLCreateSystemDefaultDevice()
  );

  #if !target_os_ios
  view.device.shouldMaximizeConcurrentCompilation = (
    0x01
  );
  #endif
  
  struct metil_application_mapping* metil_application_mapping = (
    self->metil->application_mapping
  );
  
  metil_application_mapping->view = (
    view
  );
  
  metil_application_mapping->view_controller = (
    self
  );

  renderer = [
    [
      metil_renderer
      alloc
    ]
    metil_renderer_initialize: (
      view
    )
    metil: (
      self->metil
    )
  ];

  [
    renderer
    drawableSizeWillChange: (
      view.bounds.size
    )
  ];

  view.delegate = (
    self
  );

  view.paused = (
    0x01
  );

  view.enableSetNeedsDisplay = (
    0x00
  );
  
  CAMetalLayer* layer = (
    (CAMetalLayer*)
    view.layer
  );
  
  metil_application_mapping->layer = (
    layer
  );
  
  if (
    self->metil->configuration.rendering_properties.display_sync ==
    0x00
  ) {
    metil_application_function_display_sync_unlock_raw(
      layer
    );  
  } else {
    metil_application_function_display_sync_lock_raw(
      layer
    );
  }
        
  [
    view
    draw
  ];
}

- (void) drawInMTKView: (nonnull metil_view*) _view {
  [
    renderer
    drawInMTKView: _view
  ];
}

- (void) mtkView: (nonnull metil_view*) _view drawableSizeWillChange: (CGSize) size {
  [
    renderer
    drawableSizeWillChange: _view.bounds.size
  ];
}

@end
