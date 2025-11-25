#ifndef __metil_application_metil_view_controller_h
#define __metil_application_metil_view_controller_h

#include <MetalKit/MTKView.h>

#if target_device == 1
@interface metil_view_controller: UIViewController<MTKViewDelegate>
@end
#else
@interface metil_view_controller: NSViewController<MTKViewDelegate>
@end
#endif

#endif
