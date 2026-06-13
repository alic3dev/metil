#include <metil_example_audio_output_scene.h>

#include <metil_example_audio_output_io_proc.h>
#include <metil_example_audio_output_io_proc_data.h>

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

  metil_scene->poll = (
    metil_example_audio_output_scene_poll
  );

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
      case 0x00:
      case 0x02: {
        metil_renderable_initialize_at_index(
          metil_scene->renderables,
          index_renderable,
          metil_renderable_type_object
        );
        
        break;
      }
      case 0x01: {
        metil_renderable_initialize_at_index(
          metil_scene->renderables,
          index_renderable,
          metil_renderable_type_group
        );
        
        break;
      }
    }
  }
  
  struct metil_object* metil_object_sphere = (
    metil_scene->renderables[
      0x00
    ].renderable
  );
  
  struct metil_object* metil_object_floor = (
    metil_scene->renderables[
      0x02
      ].renderable
    );
    
    metil_mesh_celled_individual_triangles_grid_initialize(
      &metil_object_floor->mesh,
      (struct math_c_vector2_float) {.x = 0xffff, .y = 0xfff1},
      (struct math_c_vector2_unsigned_long_int) {
        .x = 0xff,
        .y = 0xff
      }
    );
    
 
  metil_mesh_sphere_initialize(
    &metil_object_sphere->mesh,
    0x64 * 2,
    (struct math_c_vector2_unsigned_short_int) {
      .x = (
        0xff
      ),
      .y = (
        0xff
      )
    }
  );
  
  id<MTLBuffer> buffer_audio = [
    metil->renderer_interface.metal_device
    newBufferWithLength: (
      0x09c4    )
    options: (
      MTLResourceStorageModeShared
    )
  ];
  
  [buffer_audio retain];
  
  metil_object_buffers_initialize(
    metil_object_sphere,
    metil->renderer_interface.metal_device
  );
  
  metil_object_buffers_initialize(
    metil_object_floor,
    metil->renderer_interface.metal_device
  );
  
metil_object_floor->rotation.x = math_c_pi_half;
metil_object_floor->position.y = -0x3f;

struct metil_renderer_data_object* d = metil_object_floor->buffers_vertex[0x01].buffer.contents;

d->colour.x = 0.7;
d->colour.y = 0.5;
d->colour.z = 0.8;
d->colour.w = 0.23f;
    metil_object_buffers_add(
    metil_object_sphere,
    metil->renderer_interface.metal_device,
    metil_object_buffer_type_vertex
  );
  
  metil_object_buffers_add(
    metil_object_floor,
    metil->renderer_interface.metal_device,
    metil_object_buffer_type_vertex
  );
  
  metil_object_sphere->buffers_vertex[
    metil_object_sphere->length_buffers_vertex -
    0x01
  ].buffer = (
    buffer_audio
  );
  
  metil_object_sphere->position.y = 0x4f;
  
  metil_object_floor->buffers_vertex[
    metil_object_floor->length_buffers_vertex -
    0x01
  ].buffer = (
    buffer_audio
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
      0x01,
      0x06,
      cer0_frequency_root_scientific
    )
  );
  
  metil_example_audio_output_io_proc_data->length_note_table = (
    cer0_note_table_length(
      0x01,
      0x06
    )
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

      metil_example_audio_output_io_proc_data->index_synth = 0x00;
      metil_example_audio_output_io_proc_data->length_synthesizers = 0x00;      
metil_example_audio_output_io_proc_data->synthesizers = clic3_memory_allocate_raw(0x00);  
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
      
      struct cer0_effect* effect = (
        cer0_synthesizer_effect_add(
          synthesizer
        )
      );
      
      cer0_effect_delay_initialize(
        effect
      );
      
      cer0_effect_delay_length_frames_buffer_set(
        effect,
        0xafff
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
  }

  metil_audio_io_proc_add_with_data(
    &metil->audio,
    metil_example_audio_output_io_proc,
    metil_example_audio_output_io_proc_data
  );
  
  metil_scene->destroy = metil_example_audio_output_scene_destroy;
  
  metil_scene->player.position.z = (
    -0x64
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
    metil_example_audio_output_io_proc_data->note_table[
      ((((
        (
          metil_scene->time_elapsed /
          0x128
        ) %
        0x32) * 0x03) % 0x32
        ) *
        40
      ) %
      metil_example_audio_output_io_proc_data->length_note_table
    ]
  );

  if (
    synthesizer->frequency !=
    frequency
  ) {
    cer0_synthesizer_frequency_play(
      synthesizer,
      frequency
    );

    cer0_synthesizer_frequency_play(
      synthesizer_secondary,
      (
        frequency +
        0x02
      )
    );
  }
  
  if (
    metil_scene->time_elapsed >=
    0x64 *
    0x40
  ) {
    if (
      metil_example_audio_output_io_proc_data->length_synthesizers <
      0x01
    ) {
    clic3_memory_reallocate_raw(
       &metil_example_audio_output_io_proc_data->synthesizers,
       sizeof(struct cer0_synthesizer) * (metil_example_audio_output_io_proc_data->length_synthesizers + 0x01)
    );
        
    cer0_synthesizer_initialize(
&metil_example_audio_output_io_proc_data->synthesizers[
  metil_example_audio_output_io_proc_data->length_synthesizers
],
metil->audio.audio_output.sample_rate
);    
      
      
      synthesizer = &(
        metil_example_audio_output_io_proc_data->synthesizers[
          metil_example_audio_output_io_proc_data->length_synthesizers -
          0x00
        ]
        );
        
    
      struct cer0_effect* effect = (
        cer0_synthesizer_effect_add(
          synthesizer
        )
      );
      
      cer0_effect_delay_initialize(
        effect
      );
      
      cer0_effect_delay_length_frames_buffer_set(
        effect,
        0xffffff
      );
      
      effect->mix = (0.25f);
      
      for (
        unsigned char index_osc = 0;
        index_osc < 0x03;
        ++index_osc
      ) {
        cer0_synthesizer_oscillator_add(
       synthesizer,
       sine
    );
    }
    
    metil_example_audio_output_io_proc_data->length_synthesizers = (
        metil_example_audio_output_io_proc_data->length_synthesizers +
        0x01
      );
    }
    
    synthesizer = &(
      metil_example_audio_output_io_proc_data->synthesizers[
        metil_example_audio_output_io_proc_data->index_synth
      ]
    );
  
    frequency = (
    metil_example_audio_output_io_proc_data->note_table[
    metil_example_audio_output_io_proc_data->length_note_table -
      ((((((
        (
          metil_scene->time_elapsed /
          0x333
        ) %
        0x32) * 0x01 ) % 0x32
        ) *
        0x10
      ) %
      0x32) + 0x01)
    ]
    
    );
    
    struct metil_group* group = metil_scene->renderables[
    0x01].renderable;
    
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
        group->length
      );
    ) {
      struct metil_object* object = group->renderables[
      index_renderable
      ]->renderable;
      
      struct metil_renderer_data_object* data = object->buffers_vertex[metil_object_buffer_default_index_data].buffer.contents;
      
      data->colour.w = (
        data->colour.w -
        delta / 0x0a
      );
      
      if (data->colour.w < 0x00) {
      ((struct metil_object*) group->renderables[index_renderable]->renderable)->buffers_vertex[
       ((struct metil_object*) group->renderables[index_renderable]->renderable)->length_buffers_vertex -
       0x01
     ].buffer = 0x00;

      
        metil_group_destroy_renderable_at_index(
          
metil,
          group,
          index_renderable
        );      } else {
        object->position.x = (
          object->position.x + delta * ((object->position.z < 0x00) ? -0x20 : 0x20)
        );
        
        object->position.y = (
          object->position.y + delta * ((object->position.x < 0x00) ? -0x20 : 0x20)
        );

        
object->position.z = (
          object->position.z + delta * ((object->position.x < 0x00) ? -0x20 : 0x20)
        );      
        index_renderable = (
          index_renderable +
          0x01
        );
      }
    }
    
    
    if (metil_example_audio_output_io_proc_data->frequency_last != frequency) {
    cer0_synthesizer_frequency_play(
      synthesizer,
      (
        frequency
      )
    );
    
    metil_example_audio_output_io_proc_data->frequency_last = frequency;
    
if (
      metil_example_audio_output_io_proc_data->length_synthesizers <
      0x05
    ) {
    clic3_memory_reallocate_raw(
       &metil_example_audio_output_io_proc_data->synthesizers,
       sizeof(struct cer0_synthesizer) * (metil_example_audio_output_io_proc_data->length_synthesizers + 0x01)
    );
        
    cer0_synthesizer_initialize(
&metil_example_audio_output_io_proc_data->synthesizers[
  metil_example_audio_output_io_proc_data->length_synthesizers
],
metil->audio.audio_output.sample_rate
);    
      
      
      synthesizer = &(
        metil_example_audio_output_io_proc_data->synthesizers[
          metil_example_audio_output_io_proc_data->length_synthesizers -
          0x00
        ]
        );
        
    
      struct cer0_effect* effect = (
        cer0_synthesizer_effect_add(
          synthesizer
        )
      );
      
      cer0_effect_delay_initialize(
        effect
      );
      
      cer0_effect_delay_length_frames_buffer_set(
        effect,
        0xffffff
      );
      
      effect->mix = (0.25f);
      
      for (
        unsigned char index_osc = 0;
        index_osc < 0x03;
        ++index_osc
      ) {
        cer0_synthesizer_oscillator_add(
       synthesizer,
       (index_osc + metil_example_audio_output_io_proc_data->length_synthesizers) % 0x04 
    );
    }
    
    synthesizer->attack_sustain_decay_release_parameters.attack = (0.2f);
    synthesizer->attack_sustain_decay_release_parameters.sustain = ( 0.05f);
    synthesizer->attack_sustain_decay_release_parameters.decay = (0.05f);
    synthesizer->attack_sustain_decay_release_parameters.release = (0.7f);
    
synthesizer->length_attack_sustain_decay_release = 0xffff;    
    metil_example_audio_output_io_proc_data->length_synthesizers = (
        metil_example_audio_output_io_proc_data->length_synthesizers +
        0x01
      );
    }
    
    
    metil_example_audio_output_io_proc_data->index_synth = (
      (metil_example_audio_output_io_proc_data->index_synth +
      0x01) % metil_example_audio_output_io_proc_data->length_synthesizers
    );
    
    metil_group_add_initialize(
      group,
      metil_renderable_type_object
    );
    
    struct metil_object* object = group->renderables[group->length - 0x01]->renderable;
    
    metil_mesh_sphere_initialize(
      &object->mesh,
      0x32 * ((float) (metil->rendering_properties.frame % 0x07) /0x03),
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
      object,
      metil->renderer_interface.metal_device
    );
    
    object->position.x = (
      (float)
      (
        (metil_scene->time_elapsed + metil->rendering_properties.frame * 0x13) %
        0x32
      ) /
      0x31 - 0.5f
    ) * 0x228;
    
    object->position.y = (
      (float)
      (
        (metil_scene->time_elapsed + 0xa8 + metil->rendering_properties.frame * 0x04) %
        0x32
      ) /
      0x31 - 0.5f
    ) * 0x128 + 0x64;

    
    object->position.z = (
      (float)
      (
        (metil_scene->time_elapsed + 0x84 + metil->rendering_properties.frame) %
        0x32
      ) /
      0x31 - 0.5f
    ) * 0x258;
    
struct metil_renderer_data_object* data = object->buffers_vertex[metil_object_buffer_default_index_data].buffer.contents;
      
      data->colour.x = (
        (float)
        (
          (unsigned int)
          (frequency * 0x03) %
          0x65
        ) /
        0x64      );
      
      data->colour.y = (
        (float)
        (
          (unsigned int)
          frequency %
          0x65
        ) /
        0x64 
      );
      
      data->colour.z = (
        0x01
      );
      metil_object_buffers_add(
    object,
    metil->renderer_interface.metal_device,
    metil_object_buffer_type_vertex
  );
  
  object->buffers_vertex[
    object->length_buffers_vertex -
    0x01
  ].buffer = (
  
  ((struct metil_object*) metil_scene->renderables[0x00].renderable)->buffers_vertex[
    ((struct metil_object*) metil_scene->renderables[0x00].renderable)->length_buffers_vertex -
    0x01
  ].buffer
  
  );
      
                while (group->length > 0xffff) {
                
       ((struct metil_object*) group->renderables[0x00]->renderable)->buffers_vertex[
       ((struct metil_object*) group->renderables[0x00]->renderable)->length_buffers_vertex -
       0x01
     ].buffer = 0x00;
      metil_group_destroy_renderable_at_index(
        metil,
        group,
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
  
metil_example_audio_output_io_proc_data->exiting = 0x01;

pthread_mutex_lock(&metil_example_audio_output_io_proc_data->mutex);

pthread_mutex_destroy(&metil_example_audio_output_io_proc_data->mutex);
  cer0_synthesizer_destroy(
    &metil_example_audio_output_io_proc_data->synthesizer
  );

  cer0_synthesizer_destroy(
    &metil_example_audio_output_io_proc_data->synthesizer_secondary
  );
  
  for (unsigned int index_synth = 0; index_synth < metil_example_audio_output_io_proc_data->length_synthesizers; ++index_synth) {
   
  cer0_synthesizer_destroy(
    &metil_example_audio_output_io_proc_data->synthesizers[index_synth]  );  }

  
clic3_memory_free_raw(
  metil_example_audio_output_io_proc_data->synthesizers);  
  clic3_memory_free_raw(
    metil_example_audio_output_io_proc_data->note_table
  );
  
  for (unsigned int ind = 0;ind <((struct metil_group*) metil_scene->renderables[0x01].renderable)->length;++ind) {
    ((struct metil_object*) ((struct metil_group*)metil_scene->renderables[0x01].renderable)->renderables[ind]->renderable)->buffers_vertex[
  ((struct metil_object*) ((struct metil_group*)metil_scene->renderables[0x01].renderable)->renderables[ind]->renderable)->length_buffers_vertex -
    0x01
    ].buffer = 0x00;  }
  
((struct metil_object*)metil_scene->renderables[0x02].renderable)->buffers_vertex[
0x01
].buffer = 0x00;

[((struct metil_object*)metil_scene->renderables[0x00].renderable)->buffers_vertex[
((struct metil_object*)metil_scene->renderables[0x00].renderable)->length_buffers_vertex -
0x01
].buffer release];

((struct metil_object*)metil_scene->renderables[0x00].renderable)->buffers_vertex[
((struct metil_object*)metil_scene->renderables[0x00].renderable)->length_buffers_vertex -
0x01
].buffer = 0x00;
  metil_scene_destroy_default(metil,metil_scene);
}
