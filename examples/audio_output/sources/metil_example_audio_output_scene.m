#include <metil_example_audio_output_scene.h>

#include <metil_example_audio_output_io_proc.h>
#include <metil_example_audio_output_io_proc_data.h>

#include <metil.h>
#include <metil_audio/metil_audio.h>
#include <metil_mesh/metil_mesh_line.h>
#include <metil_object.h>
#include <metil_player/metil_player.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderable_type.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/metil_scene.h>

#include <clic3_memory.h>

#include <math_c_pi.h>
#include <math_c_vector.h>

void metil_example_audio_output_scene_initialize(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  metil_scene_initialize_with_renderables(
    metil,
    metil_scene,
    0x02
  );

  metil_scene->poll = (
    metil_example_audio_output_scene_poll
  );

  void* vertex_pointers[
    0x02
  ];

  for (
    unsigned int index_renderable = (
      0x00
    );
    (
      index_renderable <
      metil_scene->length_renderables
    );
    ++index_renderable
  ) {
    metil_renderable_initialize_at_index(
      metil_scene->renderables,
      index_renderable,
      metil_renderable_type_object
    );

    struct metil_object* metil_object = (
      metil_scene->renderables[
        index_renderable
      ].renderable
    );

    struct metil_mesh* metil_mesh = (
      &metil_object->mesh
    );

    struct math_c_vector3_float points[
      metil_example_audio_output_io_proc_data_length_buffer
    ];

    for (
      unsigned short int index_point = (
        0x00
      );
      (
        index_point <
        metil_example_audio_output_io_proc_data_length_buffer
      );
      ++index_point
    ) {
      float percentage = (
        (float)
        index_point /
        metil_example_audio_output_io_proc_data_length_buffer
      );

      points[
        index_point
      ].x = (
        percentage *
        2.0f -
        1.0f
      );

      points[
        index_point
      ].y = (
        0x00
      );

      points[
        index_point
      ].z = (
        0.4f
      );
    }

    metil_mesh_line_initialize(
      metil_mesh,
      metil_example_audio_output_io_proc_data_length_buffer,
      points
    );

    metil_object_buffers_initialize(
      metil_object,
      metil->renderer_interface.metal_device
    );

    metil_object->positioning = (
      metil_positioning_absolute
    );

    metil_object->type_primitive = (
      MTLPrimitiveTypeLine
    );

    struct metil_renderer_data_object* data_object = (
      metil_object->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );

    struct math_c_vector4_float* vertices = (
      metil_object->buffers_vertex[
        metil_object_buffer_default_index_vertices
      ].buffer.contents
    );

    vertex_pointers[
      index_renderable
    ] = (
      vertices
    );
  }

  static struct metil_example_audio_output_io_proc_data* metil_example_audio_output_io_proc_data;

  metil_example_audio_output_io_proc_data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct metil_example_audio_output_io_proc_data
      )
    )
  );

  metil_scene->data = (
    metil_example_audio_output_io_proc_data
  );

  metil_example_audio_output_io_proc_data->vertices = (
    vertex_pointers[
      0x00
    ]
  );

  metil_example_audio_output_io_proc_data->vertices_secondary = (
    vertex_pointers[
      0x01
    ]
  );

  cer0_synthesizer_initialize(
    &metil_example_audio_output_io_proc_data->synthesizer,
    metil->audio.audio_output.sample_rate
  );

  cer0_synthesizer_initialize(
    &metil_example_audio_output_io_proc_data->synthesizer_secondary,
    metil->audio.audio_output.sample_rate
  );

  struct cer0_synthesizer* synthesizer = &(
    metil_example_audio_output_io_proc_data->synthesizer
  );
  for (
    unsigned char index_synthesizer = (
      0x00
    );
    (
      index_synthesizer <
      0x02
    );
    ++index_synthesizer
  ) {
    if (
      index_synthesizer ==
      0x01
    ) {
      synthesizer = &(
        metil_example_audio_output_io_proc_data->synthesizer_secondary
      );
    }

    cer0_synthesizer_oscillator_add(
       synthesizer,
       sine
    );

    cer0_synthesizer_oscillator_add(
      synthesizer,
      triangle
    );

    cer0_synthesizer_oscillator_add(
      synthesizer,
      square
    );

    cer0_synthesizer_oscillator_add(
      synthesizer,
      sawtooth_up
    );

    cer0_synthesizer_oscillator_add(
      synthesizer,
      sawtooth_down
    );
  }

  metil_audio_io_proc_add_with_data(
    &metil->audio,
    metil_example_audio_output_io_proc,
    metil_example_audio_output_io_proc_data
  );
}

void metil_example_audio_output_scene_poll(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  metil_scene_poll_default(
    metil,
    metil_scene
  );

  struct metil_example_audio_output_io_proc_data* metil_example_audio_output_io_proc_data = (
    metil_scene->data
  );

  struct cer0_synthesizer* synthesizer = &(
    metil_example_audio_output_io_proc_data->synthesizer
  );

  struct cer0_synthesizer* synthesizer_secondary = &(
    metil_example_audio_output_io_proc_data->synthesizer_secondary
  );

  float frequency = (
    (float)
    (
      (
        metil_scene->time_elapsed /
        0x01
      )
    ) /
    100.0f
  );

  if (
    synthesizer->frequency !=
    frequency
  ) {
    cer0_synthesizer_frequency_set(
      synthesizer,
      frequency
    );

    cer0_synthesizer_frequency_set(
      synthesizer_secondary,
      frequency + 0x02
    );
  }
}

void metil_example_audio_output_scene_destroy(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  metil_audio_io_proc_remove(
    &metil->audio,
    metil_example_audio_output_io_proc
  );

  struct metil_example_audio_output_io_proc_data* metil_example_audio_output_io_proc_data = (
    metil_scene->data
  );

  cer0_synthesizer_destroy(
    &metil_example_audio_output_io_proc_data->synthesizer
  );

  cer0_synthesizer_destroy(
    &metil_example_audio_output_io_proc_data->synthesizer_secondary
  );

  clic3_memory_free_raw(
    metil_scene->data
  );
}
