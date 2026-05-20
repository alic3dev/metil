#include <metil_rendering/metil_renderer_data_object.h>

void metil_renderer_data_object_initialize(
  struct metil_renderer_data_object* metil_renderer_data_object
) {
  metil_renderer_data_object->position.x = (
    0x00
  );

  metil_renderer_data_object->position.y = (
    0x00
  );

  metil_renderer_data_object->position.z = (
    0x00
  );

  metil_renderer_data_object->size.x = (
    0x00
  );

  metil_renderer_data_object->size.y = (
    0x00
  );

  metil_renderer_data_object->size.z = (
    0x00
  );

  metil_renderer_data_object->colour.x = (
    0x01
  );

  metil_renderer_data_object->colour.y = (
    0x01
  );

  metil_renderer_data_object->colour.z = (
    0x01
  );

  metil_renderer_data_object->colour.w = (
    0x01
  );

  metil_renderer_data_object->noise = (
    0x00
  );
}
