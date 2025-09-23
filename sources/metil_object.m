#include <metil_object.h>

#include <metil_mesh/mesh.h>

void metil_object_initialize(
  struct metil_object* metil_object
) {
  metil_object->data = (void*)0;
  metil_object->indices = (void*)0;
  metil_object->vertices = (void*)0;
  metil_object->texture = (void*)0;
  metil_object->texture_secondary = (void*)0;

  metil_object->position.x = 0.0f;
  metil_object->position.y = 0.0f;
  metil_object->position.z = 0.0f;

  metil_object->rotation.x = 0.0f;
  metil_object->rotation.y = 0.0f;
  metil_object->rotation.z = 0.0f;
}

void metil_object_destroy(
  struct metil_object* object
) {
  metil_mesh_destroy(&object->mesh);
}
