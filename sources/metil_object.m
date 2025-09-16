#include <metil_object.h>

#include <metil_mesh/mesh.h>

void metil_object_destroy(
  struct metil_object* object
) {
  metil_mesh_destroy(&object->mesh);
}
