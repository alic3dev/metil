#include <metil_rendering/metil_renderable.h>

#include <metil_group.h>
#include <metil_model/metil_model.h>
#include <metil_object.h>

void metil_renderable_allocate_group(
  struct metil_renderable* renderable
) {
  renderable->renderable = malloc(
    sizeof(struct metil_group)
  );
}

void metil_renderable_allocate_object(
  struct metil_renderable* renderable
) {
  renderable->renderable = malloc(
    sizeof(struct metil_object)
  );
}

void metil_renderable_allocate_model(
  struct metil_renderable* renderable
) {
  renderable->renderable = malloc(
    sizeof(struct metil_model)
  );
}

void metil_renderable_allocate(
  struct metil_renderable* renderable,
  enum metil_renderable_type type
) {
  renderable->type = type;

  switch (
    type
  ) {
    case metil_renderable_type_group: {
      metil_renderable_allocate_group(
        renderable
      );

      break;
    }
    case metil_renderable_type_object: {
      metil_renderable_allocate_object(
        renderable
      );

      break;
    }
    case metil_renderable_type_menu: {
      break;
    }
    case metil_renderable_type_model: {
      metil_renderable_allocate_model(
        renderable
      );

      break;
    }
    default: {
      break;
    }
  }
}

void metil_renderable_initialize(
  struct metil_renderable* renderable,
  enum metil_renderable_type type
) {
  metil_renderable_allocate(
    renderable,
    type
  );

  switch (
    type
  ) {
    case metil_renderable_type_group: {
      metil_group_initialize(
        renderable->renderable
      );

      break;
    }
    case metil_renderable_type_object: {
      metil_object_initialize(
        renderable->renderable
      );

      break;
    }
    case metil_renderable_type_menu: {
      break;
    }
    case metil_renderable_type_model: {
      metil_model_initialize(
        renderable->renderable
      );

      break;
    }
    default: {
      break;
    }
  }
}

void metil_renderable_allocate_at_index(
  struct metil_renderable* renderables,
  unsigned int index,
  enum metil_renderable_type type
) {
  metil_renderable_allocate(
    &renderables[
      index
    ],
    type
  );
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

void metil_renderable_destroy(
  struct metil* metil,
  struct metil_renderable* renderable
) {
  switch (
    renderable->type
  ) {
    case metil_renderable_type_group: {
      metil_group_destroy(
        metil,
        renderable->renderable
      );
      break;
    }
    case metil_renderable_type_object: {
      struct metil_object* metil_object = (
        renderable->renderable
      );

      metil_object->destroy(
        metil,
        metil_object
      );
      break;
    }
    case metil_renderable_type_menu: {
      break;
    }
    case metil_renderable_type_model: {
      struct metil_model* metil_model = (
        renderable->renderable
      );

      metil_model->destroy(
        metil,
        metil_model
      );
      break;
    }
    default: {
      break;
    }
  }

  free(
    renderable->renderable
  );
}
