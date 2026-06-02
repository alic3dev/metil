#include <metil_application/metil_application_functions.h>

#include <metil_application/metil_application_mapping.h>

#include <QuartzCore/CAMetalLayer.h>

#if !target_os_ios
unsigned char metil_application_function_display_sync_get(
  struct metil_application_mapping* metil_application_mapping
) {
  return (
    metil_application_function_display_sync_get_raw(
      metil_application_mapping->layer
    )
  );
}

unsigned char metil_application_function_display_sync_get_raw(
  CAMetalLayer* metal_layer
) {
  return (
    metal_layer.displaySyncEnabled
  );
}

void metil_application_function_display_sync_lock(
  struct metil_application_mapping* metil_application_mapping
) {
  metil_application_function_display_sync_lock_raw(
    metil_application_mapping->layer
  );
}

void metil_application_function_display_sync_lock_raw(
  CAMetalLayer* metal_layer
) {
  metal_layer.displaySyncEnabled = (
    0x01
  );
}

void metil_application_function_display_sync_unlock(
  struct metil_application_mapping* metil_application_mapping
) {
  metil_application_function_display_sync_unlock_raw(
    metil_application_mapping->layer
  );
}

void metil_application_function_display_sync_unlock_raw(
  CAMetalLayer* metal_layer
) {
  metal_layer.displaySyncEnabled = (
    0x00
  );
}
#endif
