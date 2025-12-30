#ifndef __metil_input_metil_controller_h
#define __metil_input_metil_controller_h

#include <GameController/GCController.h>
#include <GameController/GCDualSenseGamepad.h>

struct metil_controller {
  GCController* controller;
  GCDualSenseGamepad* profile;
};

extern struct metil_controller metil_controller;

#endif
