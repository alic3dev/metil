#include <metil_input/metil_controller_state.h>

#include <metil_input/metil_controller.h>

#include <GameController/GameController.h>

void metil_controller_state_initialize(
  struct metil_controller_state* metil_controller_state
) {
  metil_controller_state->l1 = 0.0f;
  metil_controller_state->l2 = 0.0f;
  metil_controller_state->l3 = 0.0f;

  metil_controller_state->r1 = 0.0f;
  metil_controller_state->r2 = 0.0f;
  metil_controller_state->r3 = 0.0f;

  metil_controller_state->create = 0.0f;
  metil_controller_state->options = 0.0f;

  metil_controller_state->left_stick.x = 0.0f;
  metil_controller_state->left_stick.y = 0.0f;

  metil_controller_state->right_stick.x = 0.0f;
  metil_controller_state->right_stick.y = 0.0f;

  metil_controller_state->directional_down = 0.0f;
  metil_controller_state->directional_right = 0.0f;
  metil_controller_state->directional_left = 0.0f;
  metil_controller_state->directional_up = 0.0f;

  metil_controller_state->cross = 0.0f;
  metil_controller_state->circle = 0.0f;
  metil_controller_state->square = 0.0f;
  metil_controller_state->triangle = 0.0f;

  metil_controller_state->available = 0;
}

void metil_controller_state_poll(
  struct metil_controller* metil_controller,
  struct metil_controller_state* metil_controller_state
) {
  metil_controller_poll(
    metil_controller
  );

  if (
    metil_controller->controller == (void*)0
  ) {
    metil_controller->profile = (void*)0;

    metil_controller_state->l1 = 0.0f;
    metil_controller_state->l2 = 0.0f;
    metil_controller_state->l3 = 0.0f;

    metil_controller_state->r1 = 0.0f;
    metil_controller_state->r2 = 0.0f;
    metil_controller_state->r3 = 0.0f;

    metil_controller_state->create = 0.0f;
    metil_controller_state->options = 0.0f;

    metil_controller_state->left_stick.x = 0.0f;
    metil_controller_state->left_stick.y = 0.0f;

    metil_controller_state->right_stick.x = 0.0f;
    metil_controller_state->right_stick.y = 0.0f;

    metil_controller_state->directional_down = 0.0f;
    metil_controller_state->directional_right = 0.0f;
    metil_controller_state->directional_left = 0.0f;
    metil_controller_state->directional_up = 0.0f;

    metil_controller_state->cross = 0.0f;
    metil_controller_state->circle = 0.0f;
    metil_controller_state->square = 0.0f;
    metil_controller_state->triangle = 0.0f;

    metil_controller_state->available = 0;

    return;
  }

  metil_controller->profile = (GCDualSenseGamepad*) (
    metil_controller->controller.extendedGamepad
  );

  metil_controller_state->l1 = (
    metil_controller->profile.leftShoulder.value
  );

  metil_controller_state->l2 = (
    metil_controller->profile.leftTrigger.value
  );

  metil_controller_state->l3 = (
    metil_controller->profile.leftThumbstickButton.value
  );

  metil_controller_state->r1 = (
    metil_controller->profile.rightShoulder.value
  );

  metil_controller_state->r2 = (
    metil_controller->profile.rightTrigger.value
  );

  metil_controller_state->r3 = (
    metil_controller->profile.rightThumbstickButton.value
  );

  metil_controller_state->create = (
    metil_controller->profile.buttonOptions.value
  );

  metil_controller_state->options = (
    metil_controller->profile.buttonMenu.value
  );

  GCControllerDirectionPad* stick_left = (
    metil_controller->profile.leftThumbstick
  );

  metil_controller_state->left_stick.x = stick_left.xAxis.value;
  metil_controller_state->left_stick.y = stick_left.yAxis.value;

  GCControllerDirectionPad* stick_right = (
    metil_controller->profile.rightThumbstick
  );

  metil_controller_state->right_stick.x = stick_right.xAxis.value;
  metil_controller_state->right_stick.y = stick_right.yAxis.value;

  GCControllerDirectionPad* directional_pad = (
    metil_controller->profile.dpad
  );

  metil_controller_state->directional_down = directional_pad.down.value;
  metil_controller_state->directional_right = directional_pad.right.value;
  metil_controller_state->directional_left = directional_pad.left.value;
  metil_controller_state->directional_up = directional_pad.up.value;

  metil_controller_state->cross = (
      metil_controller->profile.buttonA.value
  );

  metil_controller_state->circle = (
    metil_controller->profile.buttonB.value
  );

  metil_controller_state->square = (
    metil_controller->profile.buttonX.value
  );

  metil_controller_state->triangle = (
    metil_controller->profile.buttonY.value
  );

  metil_controller_state->available = 1;
}
