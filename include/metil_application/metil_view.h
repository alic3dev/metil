#ifndef __metil_application_view_h
#define __metil_application_view_h

#include <metil.h>

#include <MetalKit/MTKView.h>

@interface metil_view: MTKView {
  @public struct metil* metil;
}
@end

#endif
