#ifndef __metil_input_metil_controller_h
#define __metil_input_metil_controller_h

#include <GameController/GCController.h>
#include <GameController/GCDualSenseGamepad.h>

struct metil_controller {
  GCController* _Nullable controller;
  GCDualSenseGamepad* _Nullable profile;
};

void metil_controller_initialize(
  struct metil_controller* _Nonnull
);

void metil_controller_poll(
  struct metil_controller* _Nonnull
);

#endif
