#include <metil_termination/metil_termination.h>

#include <clic3_memory.h>

void metil_termination_initialize(
  struct metil_termination* metil_termination
) {
  metil_termination->length_on_functions = (
    0x00
  );

  metil_termination->on_functions = (
    clic3_memory_allocate_raw(
      sizeof(
        metil_termination_on_function
      ) *
      metil_termination->length_on_functions
    )
  );

  metil_termination->on_functions_data = (
    clic3_memory_allocate_raw(
      sizeof(
        void*
      ) *
      metil_termination->length_on_functions
    )
  );
}

void metil_termination_on_function_add(
  struct metil_termination* metil_termination,
  metil_termination_on_function on,
  void* data
) {
  metil_termination->length_on_functions = (
    metil_termination->length_on_functions +
    0x01
  );

  clic3_memory_reallocate_raw(
    &metil_termination->on_functions,
    (
      sizeof(
        metil_termination_on_function
      ) *
      metil_termination->length_on_functions
    )
  );

  metil_termination->on_functions[
    metil_termination->length_on_functions -
    0x01
  ] = (
    on
  );

  clic3_memory_reallocate_raw(
    &metil_termination->on_functions_data,
    (
      sizeof(
        void*
      ) *
      metil_termination->length_on_functions
    )
  );

  metil_termination->on_functions_data[
    metil_termination->length_on_functions -
    0x01
  ] = (
    data
  );
}

void metil_termination_on_function_remove(
  struct metil_termination* metil_termination,
  metil_termination_on_function on
) {
  for (
    signed int index_termination_on = (
      0x00
    );
    (
      index_termination_on <
      metil_termination->length_on_functions
    );
    ++index_termination_on
  ) {
    if (
      on == metil_termination->on_functions[
        index_termination_on
      ]
    ) {
      metil_termination->length_on_functions = (
        metil_termination->length_on_functions -
        1
      );

      for (
        unsigned short int index_termination_on_offset = (
          index_termination_on
        );
        (
          index_termination_on_offset <
          metil_termination->length_on_functions
        );
        ++index_termination_on_offset
      ) {
        metil_termination->on_functions[
          index_termination_on_offset
        ] = metil_termination->on_functions[
          index_termination_on_offset +
          0x01
        ];

        metil_termination->on_functions_data[
          index_termination_on_offset
        ] = metil_termination->on_functions_data[
          index_termination_on_offset +
          0x01
        ];
      }

      clic3_memory_reallocate_raw(
        &metil_termination->on_functions,
        (
          sizeof(
            metil_termination_on_function
          ) *
          metil_termination->length_on_functions
        )
      );

      clic3_memory_reallocate_raw(
        &metil_termination->on_functions_data,
        (
          sizeof(
            void*
          ) *
          metil_termination->length_on_functions
        )
      );

      index_termination_on = (
        index_termination_on -
        0x01
      );
    }
  }
}

void metil_termination_terminate(
  struct metil_termination* metil_termination
) {
  for (
    unsigned short int index_termination_on = (
      0x00
    );
    (
      index_termination_on <
      metil_termination->length_on_functions
    );
    ++index_termination_on
  ) {
    void* on_function_data = (
      metil_termination->on_functions_data[
        index_termination_on
      ]
    );

    metil_termination->on_functions[
      index_termination_on
    ](
      on_function_data
    );
  }

  clic3_memory_free_raw(
    metil_termination->on_functions
  );

  clic3_memory_free_raw(
    metil_termination->on_functions_data
  );
}
