#include <metil_rendering/metil_renderable.h>

#include <metil_group.h>
#include <metil_model/metil_model.h>
#include <metil_object.h>
#include <metil_rendering/metil_renderable_type.h>

#include <clic3_memory.h>

void metil_renderable_allocate_group(
  struct metil_renderable* metil_renderable
) {
  metil_renderable->renderable = (
    clic3_memory_allocate_raw(
      sizeof(
        struct metil_group
      )
    )
  );
}

void metil_renderable_allocate_object(
  struct metil_renderable* metil_renderable
) {
  metil_renderable->renderable = (
    clic3_memory_allocate_raw(
      sizeof(
        struct metil_object
      )
    )
  );
}

void metil_renderable_allocate_model(
  struct metil_renderable* metil_renderable
) {
  metil_renderable->renderable = (
    clic3_memory_allocate_raw(
      sizeof(
        struct metil_model
      )
    )
  );
}

void metil_renderable_allocate(
  struct metil_renderable* metil_renderable,
  enum metil_renderable_type metil_renderable_type
) {
  metil_renderable->type = (
    metil_renderable_type
  );

  switch (
    metil_renderable->type
  ) {
    case metil_renderable_type_group: {
      metil_renderable_allocate_group(
        metil_renderable
      );

      break;
    }
    case metil_renderable_type_object: {
      metil_renderable_allocate_object(
        metil_renderable
      );

      break;
    }
    case metil_renderable_type_menu: {
      break;
    }
    case metil_renderable_type_model: {
      metil_renderable_allocate_model(
        metil_renderable
      );

      break;
    }
    default: {
      break;
    }
  }
}

void metil_renderable_initialize(
  struct metil_renderable* metil_renderable,
  enum metil_renderable_type metil_renderable_type
) {
  metil_renderable_allocate(
    metil_renderable,
    metil_renderable_type
  );

  switch (
    metil_renderable->type
  ) {
    case metil_renderable_type_group: {
      metil_group_initialize(
        metil_renderable->renderable
      );

      break;
    }
    case metil_renderable_type_object: {
      metil_object_initialize(
        metil_renderable->renderable
      );

      break;
    }
    case metil_renderable_type_menu: {
      break;
    }
    case metil_renderable_type_model: {
      metil_model_initialize(
        metil_renderable->renderable
      );

      break;
    }
    default: {
      break;
    }
  }
}

void metil_renderable_allocate_at_index(
  struct metil_renderable* metil_renderables,
  unsigned int index_metil_renderable,
  enum metil_renderable_type metil_renderable_type
) {
  metil_renderable_allocate(
    &metil_renderables[
      index_metil_renderable
    ],
    metil_renderable_type
  );
}

void metil_renderable_initialize_at_index(
  struct metil_renderable* metil_renderables,
  unsigned int index_metil_renderable,
  enum metil_renderable_type metil_renderable_type
) {
  metil_renderable_initialize(
    &metil_renderables[
      index_metil_renderable
    ],
    metil_renderable_type
  );
}

void metil_renderable_destroy(
  struct metil* metil,
  struct metil_renderable* metil_renderable
) {
  switch (
    metil_renderable->type
  ) {
    case metil_renderable_type_group: {
      metil_group_destroy(
        metil,
        metil_renderable->renderable
      );

      break;
    }
    case metil_renderable_type_object: {
      struct metil_object* metil_object = (
        metil_renderable->renderable
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
        metil_renderable->renderable
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

  clic3_memory_free(
    metil_renderable->renderable
  );
}
