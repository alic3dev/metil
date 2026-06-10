#include <metil_input/metil_touch.h>

void metil_touch_initialize(
  struct metil_touch* metil_touch
) {
  metil_touch->index_touch = (
    0x00
  );

  metil_touch->touching = (
    0x00
  );

  metil_touch->pressure = (
    0x00
  );

  metil_touch->maximum_pressure = (
    0x00
  );

  metil_touch->position.x = (
    0x00
  );

  metil_touch->position.y = (
    0x00
  );

  metil_touch->delta.x = (
    0x00
  );

  metil_touch->delta.y = (
    0x00
  );
}
