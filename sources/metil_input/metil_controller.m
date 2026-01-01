#include <metil_input/metil_controller.h>

void metil_controller_initialize(
  struct metil_controller* metil_controller
) {
  metil_controller->controller = (
    (void*) 0
  );

  metil_controller->profile = (
    (void*) 0
  );
};

void metil_controller_poll(
  struct metil_controller* metil_controller
) {
  metil_controller->controller = [GCController current];
}
