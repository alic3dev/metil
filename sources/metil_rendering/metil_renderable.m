#include <metil_rendering/metil_renderable.h>

#include <metil_object.h>

void metil_renderable_initialize(
  struct metil_renderable* renderable,
  enum metil_renderable_type type
) {
  renderable->type = type;

  switch (
    type
  ) {
    case metil_renderable_type_object: {
      renderable->renderable = malloc(
        sizeof(struct metil_object)
      );

      metil_object_initialize(
        (struct metil_object*) (
          renderable->renderable
        )
      );
      break;
    }
    case metil_renderable_type_menu: {
      break;
    }
    case metil_renderable_type_model: {
      break;
    }
    default: {
      break;
    }
  }
}

void metil_renderable_initialize_at_index(
  struct metil_renderable* renderables,
  unsigned int index,
  enum metil_renderable_type type
) {
  metil_renderable_initialize(
    &renderables[
      index
    ],
    type
  );
}
