#include <metil_rendering/metil_renderer_data_object.h>

void metil_renderer_data_object_initialize(
  struct metil_renderer_data_object* metil_renderer_data_object
) {
  metil_renderer_data_object->position.x = 0.0f;
  metil_renderer_data_object->position.y = 0.0f;
  metil_renderer_data_object->position.z = 0.0f;

  metil_renderer_data_object->size.x = 0.0f;
  metil_renderer_data_object->size.y = 0.0f;
  metil_renderer_data_object->size.z = 0.0f;

  metil_renderer_data_object->color.x = 1.0f;
  metil_renderer_data_object->color.y = 1.0f;
  metil_renderer_data_object->color.z = 1.0f;
  metil_renderer_data_object->color.w = 1.0f;

  metil_renderer_data_object->noise = 0;
}
