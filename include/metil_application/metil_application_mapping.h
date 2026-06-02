#ifndef __metil_metil_application_metil_application_mapping_h
#define __metil_metil_application_metil_application_mapping_h

#include <metil_application/metil_application.h>
#include <metil_application/metil_application_delegate.h>
#include <metil_application/metil_view.h>
#include <metil_application/metil_view_controller.h>
#include <metil_application/metil_window.h>
#include <metil_application/metil_window_controller.h>

#include <QuartzCore/CAMetalLayer.h>

struct metil_application_mapping {
  metil_application* _Nonnull application;
  metil_application_delegate* _Nonnull application_delegate;
  metil_view* _Nonnull view;
  metil_view_controller* _Nonnull view_controller;
  
  #if !target_os_ios
  metil_window* _Nonnull window;
  metil_window_controller* _Nonnull window_controller;
  #endif
  
  CAMetalLayer* _Nonnull layer;
};  

void metil_application_mapping_initialize(
  struct metil_application_mapping* _Nonnull
);

#endif
