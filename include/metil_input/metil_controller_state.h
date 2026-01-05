#ifndef __metil_input_metil_controller_state_h
#define __metil_input_metil_controller_state_h

#include <metil_input/metil_controller.h>
#include <metil_input/metil_controller_state/metil_controller_state_structure.h>

void metil_controller_state_poll(
  struct metil_controller* _Nonnull,
  struct metil_controller_state* _Nonnull
);

#endif
