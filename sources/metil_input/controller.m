#include <metil_input/controller.h>

#include <GameController/GameController.h>

struct metil_controller_state metil_controller_state = {
  .trigger_left = 0.0f,
  .trigger_right = 0.0f,

  .thumbstick_axis_x_left = 0.0f,
  .thumbstick_axis_y_left = 0.0f,

  .input_axis_x_right = 0.0f,
  .thumbstick_axis_y_right = 0.0f,

  .thumbstick_button_left = 0.0f,
  .thumbstick_button_right = 0.0f,

  .button_directional_pad_down = 0.0f,
  .button_directional_pad_right = 0.0f,
  .button_directional_pad_left = 0.0f,
  .button_directional_pad_up = 0.0f,

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
    GCControllerButtonInput* trigger_left = [profile_controller leftTrigger];
    GCControllerButtonInput* trigger_right = [profile_controller rightTrigger];
    
    GCControllerDirectionPad* thumbstick_right = [profile_controller rightThumbstick];
    GCControllerAxisInput* thumbstick_axis_y_right = [thumbstick_right yAxis];
    GCControllerAxisInput* input_axis_x_right = [thumbstick_right xAxis];

    GCControllerDirectionPad* thumbstick_left = [profile_controller leftThumbstick];
    GCControllerAxisInput* thumbstick_axis_y_left = [thumbstick_left yAxis];
    GCControllerAxisInput* thumbstick_axis_x_left = [thumbstick_left xAxis];

    metil_controller_state.trigger_left = trigger_left.value;
    metil_controller_state.trigger_right = trigger_right.value;

    metil_controller_state.thumbstick_axis_x_left = thumbstick_axis_x_left.value;
    metil_controller_state.thumbstick_axis_y_left = thumbstick_axis_y_left.value;

    metil_controller_state.input_axis_x_right = input_axis_x_right.value;
    metil_controller_state.thumbstick_axis_y_right = thumbstick_axis_y_right.value;

    metil_controller_state.thumbstick_button_left = [profile_controller leftThumbstickButton].value;
    metil_controller_state.thumbstick_button_right = [profile_controller rightThumbstickButton].value;

    GCControllerDirectionPad* directional_pad = [profile_controller dpad];

    metil_controller_state.button_directional_pad_down = directional_pad.down.value;
    metil_controller_state.button_directional_pad_right = directional_pad.right.value;
    metil_controller_state.button_directional_pad_left = directional_pad.left.value;
    metil_controller_state.button_directional_pad_up = directional_pad.up.value;

    metil_controller_state.button_cross = [profile_controller buttonA].value;
    metil_controller_state.button_circle = [profile_controller buttonB].value;
    metil_controller_state.button_square = [profile_controller buttonX].value;
    metil_controller_state.button_triangle = [profile_controller buttonY].value;

    metil_controller_state.available = 1;
  } else {
    metil_controller_state.trigger_left = 0.0f;
    metil_controller_state.trigger_right = 0.0f;

    metil_controller_state.thumbstick_axis_x_left = 0.0f;
    metil_controller_state.thumbstick_axis_y_left = 0.0f;

    metil_controller_state.input_axis_x_right = 0.0f;
    metil_controller_state.thumbstick_axis_y_right = 0.0f;

    metil_controller_state.thumbstick_button_left = 0.0f;
    metil_controller_state.thumbstick_button_right = 0.0f;

    metil_controller_state.available = 0;
  }
}
