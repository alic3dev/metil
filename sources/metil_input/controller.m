#include <metil_input/controller.h>

#include <GameController/GameController.h>

struct metil_controller_state metil_controller_state = {
  .l1 = 0.0f,
  .l2 = 0.0f,
  .l3 = 0.0f,

  .r1 = 0.0f,
  .r2 = 0.0f,
  .r3 = 0.0f,

  .left_stick = {
    .x = 0.0f,
    .y = 0.0f
  },

  .right_stick = {
    .x = 0.0f,
    .y = 0.0f
  },

  .button_directional_down = 0.0f,
  .button_directional_right = 0.0f,
  .button_directional_left = 0.0f,
  .button_directional_up = 0.0f,

  .button_cross = 0.0f,
  .button_circle = 0.0f,
  .button_square = 0.0f,
  .button_triangle = 0.0f,

  .available = 0
};

void metil_controller_poll() {
  // TODO: GCDualSenseGamepad: Add DualSense specific functionality
  GCController* controller = [GCController current];
  GCExtendedGamepad* profile_controller = (
    controller != (void*)0
    ? (GCDualSenseGamepad*) [controller extendedGamepad]
    : (void*)0
  );

  if (profile_controller != (void*)0) {
    metil_controller_state.l1 = [profile_controller leftShoulder].value;
    metil_controller_state.l2 = [profile_controller leftTrigger].value;
    metil_controller_state.l3 = [profile_controller leftThumbstickButton].value;

    metil_controller_state.r1 = [profile_controller rightShoulder].value;
    metil_controller_state.r2 = [profile_controller rightTrigger].value;
    metil_controller_state.r3 = [profile_controller rightThumbstickButton].value;

    GCControllerDirectionPad* stick_left = [profile_controller leftThumbstick];

    metil_controller_state.left_stick.x = [stick_left xAxis].value;
    metil_controller_state.left_stick.y = [stick_left yAxis].value;

    GCControllerDirectionPad* stick_right = [profile_controller rightThumbstick];

    metil_controller_state.right_stick.x = [stick_right xAxis].value;
    metil_controller_state.right_stick.y = [stick_right yAxis].value;

    GCControllerDirectionPad* directional_pad = [profile_controller dpad];

    metil_controller_state.button_directional_down = directional_pad.down.value;
    metil_controller_state.button_directional_right = directional_pad.right.value;
    metil_controller_state.button_directional_left = directional_pad.left.value;
    metil_controller_state.button_directional_up = directional_pad.up.value;

    metil_controller_state.button_cross = [profile_controller buttonA].value;
    metil_controller_state.button_circle = [profile_controller buttonB].value;
    metil_controller_state.button_square = [profile_controller buttonX].value;
    metil_controller_state.button_triangle = [profile_controller buttonY].value;

    metil_controller_state.available = 1;
  } else {
    metil_controller_state.l2 = 0.0f;
    metil_controller_state.r2 = 0.0f;

    metil_controller_state.left_stick.x = 0.0f;
    metil_controller_state.left_stick.y = 0.0f;

    metil_controller_state.right_stick.x = 0.0f;
    metil_controller_state.right_stick.y = 0.0f;

    metil_controller_state.l3 = 0.0f;
    metil_controller_state.r3 = 0.0f;

    metil_controller_state.available = 0;
  }
}
