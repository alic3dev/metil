#ifndef __metil_metil_application_metil_application_mapping_h
#define __metil_metil_application_metil_application_mapping_h

#include <metil_application/metil_application.h>
#include <metil_application/metil_application_delegate.h>
#include <metil_application/metil_view.h>
#include <metil_application/metil_view_controller.h>
#include <metil_application/metil_window.h>
#include <metil_application/metil_window_controller.h>

struct metil_application_mapping {
  metil_application* application;
  metil_application_delegate* application_delegate;
  metil_view* view;
  metil_view_controller* view_controller;
  metil_window* window;
  metil_window_controller* window_controller;
};  

#endif
