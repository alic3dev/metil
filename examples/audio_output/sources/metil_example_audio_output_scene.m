#include <metil_example_audio_output_scene.h>

#include <metil_example_audio_output_io_proc.h>
#include <metil_example_audio_output_io_proc_data.h>
#include <metil_example_audio_output_object.h>

#include <cer0_effects/cer0_effect_delay.h>
#include <cer0_frequency_root.h>
#include <cer0_note_table.h>
#include <cer0_synthesizer.h>

#include <clic3_memory.h>

#include <math_c_modulus.h>
#include <math_c_pi.h>
#include <math_c_vector.h>

#include <metil.h>
#include <metil_audio/metil_audio.h>
#include <metil_group.h>
#include <metil_mesh/metil_mesh_sphere.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_grid.h>
#include <metil_object.h>
#include <metil_player/metil_player.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderable_type.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/metil_scene.h>

void metil_example_audio_output_scene_initialize(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  metil_scene_initialize_with_renderables(
    metil,
    metil_scene,
    metil_example_audio_output_scene_length_renderables
  );

  id<MTLBuffer> buffer_audio = [
    metil->renderer_interface.metal_device
    newBufferWithLength: (
      0x09c4
    )
    options: (
      MTLResourceStorageModeShared
    )
  ];

  [
    buffer_audio
    retain
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
    switch (
      index_renderable
    ) {
      case metil_example_audio_output_scene_index_renderable_floor:
      case metil_example_audio_output_scene_index_renderable_flower: {
        metil_renderable_initialize_at_index(
          metil_scene->renderables,
          index_renderable,
          metil_renderable_type_object
        );

        break;
      }
      case metil_example_audio_output_scene_index_renderable_floaties: {
        metil_renderable_initialize_at_index(
          metil_scene->renderables,
          index_renderable,
          metil_renderable_type_group
        );

        break;
      }
    }
  }

  struct metil_object* metil_object_flower = (
    metil_scene->renderables[
      metil_example_audio_output_scene_index_renderable_flower
    ].renderable
  );

  struct metil_object* metil_object_floor = (
    metil_scene->renderables[
      metil_example_audio_output_scene_index_renderable_floor
    ].renderable
  );

  metil_mesh_sphere_initialize(
    &metil_object_flower->mesh,
    0x128,
    (struct math_c_vector2_unsigned_short_int) {
      .x = (
        0xff
      ),
      .y = (
        0xff
      )
    }
  );

  metil_mesh_celled_individual_triangles_grid_initialize(
    &metil_object_floor->mesh,
    (struct math_c_vector2_float) {
      .x = (
        0xffff
      ),
      .y = (
        0xfff1
      )
    },
    (struct math_c_vector2_unsigned_long_int) {
      .x = (
        0xff
      ),
      .y = (
        0xff
      )
    }
  );

  metil_object_floor->position.y = -(
    0x3f
  );

  metil_object_floor->rotation.x = (
    math_c_pi_half
  );

  metil_object_buffers_initialize(
    metil_object_flower,
    metil->renderer_interface.metal_device
  );

  metil_object_buffers_initialize(
    metil_object_floor,
    metil->renderer_interface.metal_device
  );

  metil_object_buffers_add(
    metil_object_flower,
    metil->renderer_interface.metal_device,
    metil_object_buffer_type_vertex
  );

  metil_object_buffers_add(
    metil_object_floor,
    metil->renderer_interface.metal_device,
    metil_object_buffer_type_vertex
  );

  metil_object_flower->buffers_vertex[
    metil_object_flower->length_buffers_vertex -
   0x01
  ].buffer = (
    buffer_audio
  );

  metil_object_floor->buffers_vertex[
    metil_object_floor->length_buffers_vertex -
    0x01
  ].buffer = (
    buffer_audio
  );

  struct metil_renderer_data_object* metil_renderer_data_object_floor = (
    metil_object_floor->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  metil_renderer_data_object_floor->colour.x = (
    0.7f
  );

  metil_renderer_data_object_floor->colour.y = (
    0.5f
  );

  metil_renderer_data_object_floor->colour.z = (
    0.8f
  );

  metil_renderer_data_object_floor->colour.w = (
    0.23f
  );

  metil_object_flower->position.y = (
    0x4f
  );

  metil_object_floor->destroy = (
    metil_example_audio_output_object_destroy
  );

  metil_scene->data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct metil_example_audio_output_io_proc_data
      )
    )
  );

  struct metil_example_audio_output_io_proc_data* metil_example_audio_output_io_proc_data = (
    metil_scene->data
  );

  pthread_mutex_init(
    &metil_example_audio_output_io_proc_data->mutex,
    0x00
  );

  metil_example_audio_output_io_proc_data->buffer = (
    buffer_audio.contents
  );

  metil_example_audio_output_io_proc_data->length_buffer = (
    buffer_audio.length
  );

  metil_example_audio_output_io_proc_data->index_buffer = (
    0x00
  );

  metil_example_audio_output_io_proc_data->note_table = (
    cer0_note_table_create(
      metil_example_audio_output_io_proc_data_octave_minimum,
      metil_example_audio_output_io_proc_data_octave_maximum,
      cer0_frequency_root_scientific
    )
  );

  metil_example_audio_output_io_proc_data->length_note_table = (
    cer0_note_table_length(
      metil_example_audio_output_io_proc_data_octave_minimum,
      metil_example_audio_output_io_proc_data_octave_maximum
    )
  );

  metil_example_audio_output_io_proc_data->index_synth = (
    0x00
  );

  metil_example_audio_output_io_proc_data->length_synthesizers = (
    0x00
  );

  metil_example_audio_output_io_proc_data->synthesizers = (
    clic3_memory_allocate_raw(
      0x00
    )
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
    struct cer0_synthesizer* cer0_synthesizer;

    switch (
      index_synthesizer
    ) {
      case 0x00: {
        cer0_synthesizer = &(
          metil_example_audio_output_io_proc_data->synthesizer
        );

        break;
      }
      case 0x01: {
        cer0_synthesizer = &(
          metil_example_audio_output_io_proc_data->synthesizer_secondary
        );

        break;
      }
    }

    cer0_synthesizer_initialize(
      cer0_synthesizer,
      metil->audio.audio_output.sample_rate
    );

    cer0_synthesizer_oscillator_add(
      cer0_synthesizer,
      sine
    );

    cer0_synthesizer_oscillator_add(
      cer0_synthesizer,
      triangle
    );

    if (
      index_synthesizer ==
      0x01
    ) {
      struct cer0_effect* cer0_effect = (
        cer0_synthesizer_effect_add(
          cer0_synthesizer
        )
      );

      cer0_effect_delay_initialize(
        cer0_effect
      );

      cer0_effect_delay_length_frames_buffer_set(
        cer0_effect,
        0xafff
      );
    }
  }

  metil_audio_io_proc_add_with_data(
    &metil->audio,
    metil_example_audio_output_io_proc,
    metil_example_audio_output_io_proc_data
  );

  metil_scene->destroy = (
    metil_example_audio_output_scene_destroy
  );

  metil_scene->poll = (
    metil_example_audio_output_scene_poll
  );

  metil_scene->player.position.z = -(
    0x64
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

  struct metil_object* metil_object_flower = (
    metil_scene->renderables[
      metil_example_audio_output_scene_index_renderable_flower
    ].renderable
  );

  struct metil_example_audio_output_io_proc_data* metil_example_audio_output_io_proc_data = (
    metil_scene->data
  );

  struct cer0_synthesizer* cer0_synthesizer = &(
    metil_example_audio_output_io_proc_data->synthesizer
  );

  struct cer0_synthesizer* cer0_synthesizer_secondary = &(
    metil_example_audio_output_io_proc_data->synthesizer_secondary
  );

  float frequency = (
    metil_example_audio_output_io_proc_data->note_table[
      (
        (
          (
            (
              (
                metil_scene->time_elapsed /
                0x128
              ) %
              0x32
            ) *
            0x03
          ) %
          0x32
        ) *
        0x28
      ) %
      metil_example_audio_output_io_proc_data->length_note_table
    ]
  );

  if (
    cer0_synthesizer->frequency !=
    frequency
  ) {
    cer0_synthesizer_frequency_play(
      cer0_synthesizer,
      frequency
    );

    cer0_synthesizer_frequency_play(
      cer0_synthesizer_secondary,
      (
        frequency +
        0x02
      )
    );
  }

  if (
    metil_scene->time_elapsed >=
    0x1900
  ) {
    if (
      metil_example_audio_output_io_proc_data->length_synthesizers <
      0x01
    ) {
      clic3_memory_reallocate_raw(
        &metil_example_audio_output_io_proc_data->synthesizers,
        (
          sizeof(
            struct cer0_synthesizer
          ) *
          (
            metil_example_audio_output_io_proc_data->length_synthesizers +
            0x01
          )
        )
      );

      cer0_synthesizer_initialize(
        &metil_example_audio_output_io_proc_data->synthesizers[
          metil_example_audio_output_io_proc_data->length_synthesizers
        ],
        metil->audio.audio_output.sample_rate
      );

      cer0_synthesizer = &(
        metil_example_audio_output_io_proc_data->synthesizers[
          metil_example_audio_output_io_proc_data->length_synthesizers
        ]
      );
      struct cer0_effect* cer0_effect = (
        cer0_synthesizer_effect_add(
          cer0_synthesizer
        )
      );

      cer0_effect_delay_initialize(
        cer0_effect
      );

      cer0_effect_delay_length_frames_buffer_set(
        cer0_effect,
        0xffffff
      );

      cer0_effect->mix = (
        0.25f
      );

      for (
        unsigned char index_oscillator = (
          0x00
        );
        (
          index_oscillator <
          0x03
        );
        ++index_oscillator
      ) {
        cer0_synthesizer_oscillator_add(
          cer0_synthesizer,
          sine
        );
      }

      metil_example_audio_output_io_proc_data->length_synthesizers = (
        metil_example_audio_output_io_proc_data->length_synthesizers +
        0x01
      );
    }

    cer0_synthesizer = &(
      metil_example_audio_output_io_proc_data->synthesizers[
        metil_example_audio_output_io_proc_data->index_synth
      ]
    );

    frequency = (
      metil_example_audio_output_io_proc_data->note_table[
        metil_example_audio_output_io_proc_data->length_note_table -
        (
          (
            (
              (
                (
                  (
                    (
                      metil_scene->time_elapsed /
                      0x0333
                    ) %
                    0x32
                  )
                ) %
                0x32
              ) *
              0x10
            ) %
            0x32
          ) +
          0x01
        )
      ]
    );

    struct metil_group* metil_group_floaties = (
      metil_scene->renderables[
        metil_example_audio_output_scene_index_renderable_floaties
      ].renderable
    );

    float delta = (
      (float)
      metil_scene->time_delta /
      0x03e8
    );

    for (
      unsigned int index_renderable = (
        0x00
      );
      (
        index_renderable <
        metil_group_floaties->length
      );
    ) {
      struct metil_object* metil_object_floaty = (
        metil_group_floaties->renderables[
          index_renderable
        ]->renderable
      );

      struct metil_renderer_data_object* metil_renderer_data_object_floaty = (
        metil_object_floaty->buffers_vertex[
          metil_object_buffer_default_index_data
        ].buffer.contents
      );

      metil_renderer_data_object_floaty->colour.w = (
        metil_renderer_data_object_floaty->colour.w -
        delta /
        0x0a
      );

      if (
        metil_renderer_data_object_floaty->colour.w <
        0x00
      ) {
        metil_group_destroy_renderable_at_index(
          metil,
          metil_group_floaties,
          index_renderable
        );

        continue;
      }

      metil_object_floaty->position.x = (
        metil_object_floaty->position.x +
        delta *
        (
          (
            metil_object_floaty->position.z <
            0x00
          )
          ? -0x20
          : 0x20
        )
      );

      metil_object_floaty->position.y = (
        metil_object_floaty->position.y +
        delta *
        (
          (
            metil_object_floaty->position.x <
            0x00
          )
          ? -0x20
          : 0x20
        )
      );

      metil_object_floaty->position.z = (
        metil_object_floaty->position.z +
        delta *
        (
          (
            metil_object_floaty->position.x <
            0x00
          )
          ? -0x20
          : 0x20
        )
      );

      index_renderable = (
        index_renderable +
        0x01
      );
    }

    if (
      metil_example_audio_output_io_proc_data->frequency_last !=
      frequency
    ) {
      cer0_synthesizer_frequency_play(
        cer0_synthesizer,
        frequency
      );

      metil_example_audio_output_io_proc_data->frequency_last = (
        frequency
      );

      if (
        metil_example_audio_output_io_proc_data->length_synthesizers <
        0x05
      ) {
        clic3_memory_reallocate_raw(
          &metil_example_audio_output_io_proc_data->synthesizers,
          (
            sizeof(
              struct cer0_synthesizer
            ) *
            (
              metil_example_audio_output_io_proc_data->length_synthesizers +
              0x01
            )
          )
        );

        cer0_synthesizer_initialize(
          &metil_example_audio_output_io_proc_data->synthesizers[
            metil_example_audio_output_io_proc_data->length_synthesizers
          ],
          metil->audio.audio_output.sample_rate
        );

        cer0_synthesizer = &(
          metil_example_audio_output_io_proc_data->synthesizers[
            metil_example_audio_output_io_proc_data->length_synthesizers
          ]
        );

        struct cer0_effect* cer0_effect = (
          cer0_synthesizer_effect_add(
            cer0_synthesizer
          )
        );

        cer0_effect_delay_initialize(
          cer0_effect
        );

        cer0_effect_delay_length_frames_buffer_set(
          cer0_effect,
          0xffffff
        );

        cer0_effect->mix = (
          0.25f
        );

        for (
          unsigned char index_oscillator = (
            0x00
          );
          (
            index_oscillator <
            0x03
          );
          ++index_oscillator
        ) {
          cer0_synthesizer_oscillator_add(
            cer0_synthesizer,
            (
              (
                index_oscillator +
                metil_example_audio_output_io_proc_data->length_synthesizers
              ) %
              0x04
            )
          );
        }

        cer0_synthesizer->attack_sustain_decay_release_parameters.attack = (
          0.2f
        );

        cer0_synthesizer->attack_sustain_decay_release_parameters.sustain = (
          0.05f
        );

        cer0_synthesizer->attack_sustain_decay_release_parameters.decay = (
          0.05f
        );

        cer0_synthesizer->attack_sustain_decay_release_parameters.release = (
          0.7f
        );

        cer0_synthesizer->length_attack_sustain_decay_release = (
          0xffff
        );

        metil_example_audio_output_io_proc_data->length_synthesizers = (
          metil_example_audio_output_io_proc_data->length_synthesizers +
          0x01
        );
      }

      metil_example_audio_output_io_proc_data->index_synth = (
        (
          metil_example_audio_output_io_proc_data->index_synth +
          0x01
        ) %
        metil_example_audio_output_io_proc_data->length_synthesizers
      );

      metil_group_add_initialize(
        metil_group_floaties,
        metil_renderable_type_object
      );

      struct metil_object* metil_object_floaty = (
        metil_group_floaties->renderables[
          metil_group_floaties->length -
          0x01
        ]->renderable
      );

      metil_mesh_sphere_initialize(
        &metil_object_floaty->mesh,
        (
          0x32 *
          (
            (float)
            (
              metil->rendering_properties.frame %
              0x07
            ) /
            0x03
          )
        ),
        (struct math_c_vector2_unsigned_short_int) {
          .x = (
            0x20
          ),
          .y = (
            0x20
          )
        }
      );

      metil_object_buffers_initialize(
        metil_object_floaty,
        metil->renderer_interface.metal_device
      );

      metil_object_floaty->position.x = (
        (
          (float)
          (
            (
              metil_scene->time_elapsed +
              metil->rendering_properties.frame *
              0x13
            ) %
            0x32
          ) /
          0x31 -
          0.5f
        ) *
        0x228
      );

      metil_object_floaty->position.y = (
        (
          (float)
          (
            (
              metil_scene->time_elapsed +
              0xa8 +
              metil->rendering_properties.frame *
              0x04
            ) %
            0x32
          ) /
          0x31 -
          0.5f
        ) *
        0x128 +
        0x64
      );

      metil_object_floaty->position.z = (
        (
          (float)
          (
            (
              metil_scene->time_elapsed +
              0x84 +
              metil->rendering_properties.frame
            ) %
            0x32
          ) /
          0x31 -
          0.5f
        ) *
        0x258
      );

      struct metil_renderer_data_object* metil_renderer_data_object_floaty = (
        metil_object_floaty->buffers_vertex[
          metil_object_buffer_default_index_data
        ].buffer.contents
      );

      metil_renderer_data_object_floaty->colour.x = (
        (float)
        (
          (unsigned int)
          (
            frequency *
            0x03
          ) %
          0x65
        ) /
        0x64
      );

      metil_renderer_data_object_floaty->colour.y = (
        (float)
        (
          (unsigned int)
          frequency %
          0x65
        ) /
        0x64
      );

      metil_renderer_data_object_floaty->colour.z = (
        0x01
      );

      metil_object_buffers_add(
        metil_object_floaty,
        metil->renderer_interface.metal_device,
        metil_object_buffer_type_vertex
      );

      metil_object_floaty->buffers_vertex[
        metil_object_floaty->length_buffers_vertex -
        0x01
      ].buffer = (
        metil_object_flower->buffers_vertex[
          metil_object_flower->length_buffers_vertex -
          0x01
        ].buffer
      );

      metil_object_floaty->destroy = (
        metil_example_audio_output_object_destroy
      );

      while (
        metil_group_floaties->length >
        0xffff
      ) {
        metil_group_destroy_renderable_at_index(
          metil,
          metil_group_floaties,
          0x00
        );
      }
    }
  }
}

void metil_example_audio_output_scene_destroy(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  struct metil_example_audio_output_io_proc_data* metil_example_audio_output_io_proc_data = (
    metil_scene->data
  );

  pthread_mutex_lock(
    &metil_example_audio_output_io_proc_data->mutex
  );

  metil_example_audio_output_io_proc_data->exiting = (
    0x01
  );

  pthread_mutex_lock(
    &metil_example_audio_output_io_proc_data->mutex
  );

  pthread_mutex_destroy(
    &metil_example_audio_output_io_proc_data->mutex
  );

  cer0_synthesizer_destroy(
    &metil_example_audio_output_io_proc_data->synthesizer
  );

  cer0_synthesizer_destroy(
    &metil_example_audio_output_io_proc_data->synthesizer_secondary
  );

  for (
    unsigned int index_synthesizer = (
      0x00
    );
    (
      index_synthesizer <
      metil_example_audio_output_io_proc_data->length_synthesizers
    );
    ++index_synthesizer
  ) {
    cer0_synthesizer_destroy(
      &metil_example_audio_output_io_proc_data->synthesizers[
        index_synthesizer
      ]
    );
  }

  clic3_memory_free_raw(
    metil_example_audio_output_io_proc_data->synthesizers
  );

  clic3_memory_free_raw(
    metil_example_audio_output_io_proc_data->note_table
  );

  metil_scene_destroy_default(
    metil,
    metil_scene
  );
}
