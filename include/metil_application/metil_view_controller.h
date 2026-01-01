#ifndef __metil_application_metil_view_controller_h
#define __metil_application_metil_view_controller_h

#include <metil.h>

#include <MetalKit/MTKView.h>

typedef void (*metil_view_controller_on_view_did_load_function)();

extern metil_view_controller_on_view_did_load_function metil_view_controller_on_view_did_load;

#if target_os_ios
@interface metil_view_controller: UIViewController<MTKViewDelegate>
#else
@interface metil_view_controller: NSViewController<MTKViewDelegate>
#endif

{
  @public struct metil* metil;
}

@end

#endif
