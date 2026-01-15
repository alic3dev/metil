#include <metil_group.h>

#include <metil.h>
#include <metil_rendering/metil_renderable.h>

#include <clic3_memory.h>

void metil_group_initialize(
  struct metil_group* metil_group
) {
  metil_group->renderables = 0;
  metil_group->length = 0;

  clic3_memory_allocate(
    &metil_group->renderables,
    (
      sizeof(
        struct metil_renderable*
      ) *
      metil_group->length
    )
  );

  metil_group->visible = (
    1
  );
}

void metil_group_add_length_with_renderable_function(
  struct metil_group* metil_group,
  unsigned int length,
  enum metil_renderable_type metil_renderable_type,
  metil_group_renderable_function metil_group_renderable_function
) {
  metil_group->length = (
    metil_group->length +
    length
  );

  clic3_memory_allocate(
    &metil_group->renderables,
    (
      sizeof(
        struct metil_renderable*
      ) *
      metil_group->length
    )
  );

  for (
    unsigned int index_group_renderable = (
      metil_group->length -
      length
    );
    index_group_renderable < metil_group->length;
    ++index_group_renderable
  ) {
    metil_group->renderables[
      index_group_renderable
    ] = 0;

    clic3_memory_allocate(
      &metil_group->renderables[
        index_group_renderable
      ],
      sizeof(
        struct metil_renderable
      )
    );

    metil_group_renderable_function(
      metil_group->renderables[
        index_group_renderable
      ],
      metil_renderable_type
    );
  }
}

void metil_group_allocate(
  struct metil_group* metil_group,
  enum metil_renderable_type metil_renderable_type
) {
  metil_group_allocate_length(
    metil_group,
    1,
    metil_renderable_type
  );
}

void metil_group_allocate_length(
  struct metil_group* metil_group,
  unsigned int length,
  enum metil_renderable_type metil_renderable_type
) {
  metil_group_add_length_with_renderable_function(
    metil_group,
    length,
    metil_renderable_type,
    metil_renderable_allocate
  );
}

void metil_group_add_initialize(
  struct metil_group* metil_group,
  enum metil_renderable_type metil_renderable_type
) {
  metil_group_add_length_initialize(
    metil_group,
    1,
    metil_renderable_type
  );
}

void metil_group_add_length_initialize(
  struct metil_group* metil_group,
  unsigned int length,
  enum metil_renderable_type metil_renderable_type
) {
  metil_group_add_length_with_renderable_function(
    metil_group,
    length,
    metil_renderable_type,
    metil_renderable_initialize
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

  clic3_memory_allocate(
    metil_group->renderables,
    (
      sizeof(
        struct metil_renderable*
      ) *
      metil_group->length
    )
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

  clic3_memory_allocate(
    &metil_group->renderables,
    (
      sizeof(
        struct metil_renderable*
      ) *
      metil_group->length
    )
  );
}

void metil_group_destroy_renderable(
  struct metil* metil,
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
        metil,
        metil_group,
        index_renderable
      );

      break;
    }
  }
}

void metil_group_destroy_renderable_at_index(
  struct metil* metil,
  struct metil_group* metil_group,
  unsigned int index_renderable_removal
) {
  metil_renderable_destroy(
    metil,
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

  clic3_memory_allocate(
    &metil_group->renderables,
    (
      sizeof(
        struct metil_renderable*
      ) *
      metil_group->length
    ) 
  );
}

void metil_group_destroy(
  struct metil* metil,
  struct metil_group* metil_group
) {
  for (
    unsigned int index_renderable = 0;
    index_renderable < metil_group->length;
    ++index_renderable
  ) {
    metil_renderable_destroy(
      metil,
      metil_group->renderables[
        index_renderable
      ]
    );

    clic3_memory_free(
      metil_group->renderables[
        index_renderable
      ]
    );
  }

  clic3_memory_free(
    metil_group->renderables
  );
}
