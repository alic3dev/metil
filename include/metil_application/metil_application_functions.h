#ifndef __metil_metil_application_metil_application_functions_h
#define __metil_metil_application_metil_application_functions_h

#include <metil_application/metil_application_mapping.h>

#include <QuartzCore/CAMetalLayer.h>

#if !target_os_ios
unsigned char metil_application_function_display_sync_get(
  struct metil_application_mapping* _Nonnull
);

unsigned char metil_application_function_display_sync_get_raw(
  CAMetalLayer* _Nonnull
);

void metil_application_function_display_sync_lock(
  struct metil_application_mapping* _Nonnull
);

void metil_application_function_display_sync_lock_raw(
  CAMetalLayer* _Nonnull
);

void metil_application_function_display_sync_unlock(
  struct metil_application_mapping* _Nonnull
);

void metil_application_function_display_sync_unlock_raw(
  CAMetalLayer* _Nonnull
);
#endif

#endif
