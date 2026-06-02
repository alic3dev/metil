#include <metil_application/metil_application_mapping.h>

void metil_application_mapping_initialize(
  struct metil_application_mapping* metil_application_mapping
) {
  metil_application_mapping->application = (
    0x00
  );
  
  metil_application_mapping->application_delegate = (
    0x00
  );
  
  metil_application_mapping->view = (
    0x00
  );
  
  metil_application_mapping->view_controller = (
    0x00
  );
  
  #if !target_os_ios
  metil_application_mapping->window = (
    0x00
  );
  
  metil_application_mapping->window_controller = (
    0x00
  );
  #endif
  
  metil_application_mapping->layer = (
    0x00
  );
}
