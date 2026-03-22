#ifndef __metil_application_metil_view_h
#define __metil_application_metil_view_h

#include <metil.h>

#include <MetalKit/MTKView.h>

#if target_os_ios
#include <UIKit/UIEvent.h>
#include <UIKit/UITouch.h>
#endif

@interface metil_view: MTKView {
  @public struct metil* metil;
}

#if target_os_ios
- (void) touchesBegan: (NSSet<UITouch*>* _Nonnull) touches withEvent: (UIEvent* _Nullable) event;
- (void) touchesMoved: (NSSet<UITouch*>* _Nonnull) touches withEvent: (UIEvent* _Nullable) event;
- (void) touchesEnded: (NSSet<UITouch*>* _Nonnull) touches withEvent: (UIEvent* _Nullable) event;
- (void) touchesCancelled: (NSSet<UITouch*>* _Nonnull) touches withEvent: (UIEvent* _Nullable) event;
#endif

@end

#endif
