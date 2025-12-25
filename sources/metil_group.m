#include <metil_group.h>

#include <metil_rendering/metil_renderable.h>

#include <stdlib.h>

void metil_group_initialize(
  struct metil_group* metil_group
) {
  metil_group->length = 0;
  metil_group->renderables = malloc(
    sizeof(struct metil_renderable*) *
    metil_group->length
  );
}

void metil_group_allocate(
  struct metil_group* metil_group,
  enum metil_renderable_type metil_renderable_type
) {
  static struct metil_renderable* metil_renderable;

  metil_renderable = malloc(
    sizeof(struct metil_renderable)
  );

  metil_renderable_allocate(
    metil_renderable,
    metil_renderable_type
  );

  metil_group_add(
    metil_group,
    metil_renderable
  );
}

void metil_group_add_initialize(
  struct metil_group* metil_group,
  enum metil_renderable_type metil_renderable_type
) {
  static struct metil_renderable* metil_renderable;

  metil_renderable = malloc(
    sizeof(struct metil_renderable)
  );

  metil_renderable_initialize(
    metil_renderable,
    metil_renderable_type
  );

  metil_group_add(
    metil_group,
    metil_renderable
  );
}

void metil_group_add(
  struct metil_group* metil_group,
  struct metil_renderable* metil_renderable
) {
  metil_group->length = (
    metil_group->length +
    1
  );

  metil_group->renderables = realloc(
    metil_group->renderables,
    sizeof(struct metil_renderable*) *
    metil_group->length
  );

  metil_group->renderables[
    metil_group->length -
    1
  ] = (
    metil_renderable
  );
}

void metil_group_remove(
  struct metil_group* metil_group,
  struct metil_renderable* metil_renderable
) {
  for (
    unsigned int index_renderable = 0;
    index_renderable < metil_group->length;
    ++index_renderable
  ) {
    if (
      metil_group->renderables[
        index_renderable
      ] == metil_renderable
    ) {
      metil_group_remove_at_index(
        metil_group,
        index_renderable
      );

      break;
    }
  }
}

void metil_group_remove_at_index(
  struct metil_group* metil_group,
  unsigned int index_renderable_removal
) {
  for (
    unsigned int index_renderable = index_renderable_removal;
    index_renderable < metil_group->length - 1;
    ++index_renderable
  ) {
    metil_group[
      index_renderable
    ] = metil_group[
      index_renderable +
      1
    ];
  }

  metil_group->length = (
    metil_group->length -
    1
  );

  metil_group->renderables = realloc(
    metil_group->renderables,
    sizeof(struct metil_renderable*) *
    metil_group->length
  );
}

void metil_group_destroy_renderable(
  struct metil_group* metil_group,
  struct metil_renderable* metil_renderable
) {
  for (
    unsigned int index_renderable = 0;
    index_renderable < metil_group->length;
    ++index_renderable
  ) {
    if (
      metil_group->renderables[
        index_renderable
      ] == metil_renderable
    ) {
      metil_group_destroy_renderable_at_index(
        metil_group,
        index_renderable
      );

      break;
    }
  }
}

void metil_group_destroy_renderable_at_index(
  struct metil_group* metil_group,
  unsigned int index_renderable_removal
) {
  metil_renderable_destroy(
    metil_group->renderables[
      index_renderable_removal
    ]
  );

  for (
    unsigned int index_renderable = index_renderable_removal;
    index_renderable < metil_group->length - 1;
    ++index_renderable
  ) {
    metil_group->renderables[
      index_renderable
    ] = metil_group->renderables[
      index_renderable +
      1
    ];
  }

  metil_group->length = (
    metil_group->length -
    1
  );

  metil_group->renderables = realloc(
    metil_group->renderables,
    sizeof(struct metil_renderable*) *
    metil_group->length
  );
}

void metil_group_destroy(
  struct metil_group* metil_group
) {
  for (
    unsigned int index_renderable = 0;
    index_renderable < metil_group->length;
    ++index_renderable
  ) {
    metil_renderable_destroy(
      metil_group->renderables[
        index_renderable
      ]
    );

    free(
      metil_group->renderables[
        index_renderable
      ]
    );
  }

  free(
    metil_group->renderables
  );
}
