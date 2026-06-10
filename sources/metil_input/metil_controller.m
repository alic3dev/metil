#include <metil_input/metil_controller.h>

void metil_controller_initialize(
  struct metil_controller* metil_controller
) {
  metil_controller->controller = (
    0x00
  );

  metil_controller->profile = (
    0x00
  );
};

void metil_controller_poll(
  struct metil_controller* metil_controller
) {
  metil_controller->controller = [
    GCController
    current
  ];
}
