#include <example_3d_scene.h>

#include <3d_rendering_textures/3d_rendering_texture_door.h>
#include <3d_rendering_objects/3d_rendering_ground.h>
#include <3d_rendering_objects/3d_rendering_sky.h>
#include <example_3d_rendering_index_pipeline.h>

#include <metil.h>
#include <metil_group.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_grid.h>
#include <metil_mesh/metil_mesh_box.h>
#include <metil_mesh/metil_mesh_sphere.h>
#include <metil_mesh/metil_mesh_gem.h>
#include <metil_model/metil_model.h>
#include <metil_object.h>
#include <metil_player/metil_player.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderable_type.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/metil_scene.h>

#include <clic3_memory.h>

#include <math_c_absolute.h>
#include <math_c_maximum.h>
#include <math_c_minimum.h>
#include <math_c_pi.h>
#include <math_c_power.h>
#include <math_c_square_root.h>

#include <math_c_sine.h>
#include <math_c_vector.h>

void example_3d_scene_initialize(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  metil_scene_initialize_with_renderables(
    metil,
    metil_scene,
    example_3d_scene_length_renderables
  );

  metil_scene->poll = (
    example_3d_scene_poll
  );

  for (
    unsigned int index_renderable = 0;
    index_renderable < metil_scene->length_renderables;
    ++index_renderable
  ) {
    switch (
      index_renderable
    ) {
      case example_3d_scene_index_renderable_planes:
      case example_3d_scene_index_renderable_structures:
      case example_3d_scene_index_renderable_doors:
      case example_3d_scene_index_renderable_solar_system: {
        metil_renderable_initialize_at_index(
          metil_scene->renderables,
          index_renderable,
          metil_renderable_type_group
        );
      
        break;
      }
      case example_3d_scene_index_renderable_sky:
      case example_3d_scene_index_renderable_ground:
      default: {
        metil_renderable_initialize_at_index(
          metil_scene->renderables,
          index_renderable,
          metil_renderable_type_object
        );
  
        break;
      }
    }
  }

  struct metil_object* metil_object_sky = (
    metil_scene->renderables[
      example_3d_scene_index_renderable_sky
    ].renderable
  );

  metil_example_3d_rendering_sky_initialize(
    metil,
    metil_object_sky
  );

  struct metil_object* metil_object_ground = (
    metil_scene->renderables[
      example_3d_scene_index_renderable_ground
    ].renderable
  );

  metil_example_3d_rendering_ground_initialize(
    metil,
    metil_object_ground
  );

  struct metil_group* metil_group_structures = (
    metil_scene->renderables[
      example_3d_scene_index_renderable_structures
    ].renderable
  );

  struct metil_group* metil_group_doors = (
    metil_scene->renderables[
      example_3d_scene_index_renderable_doors
    ].renderable
  );

  struct metil_group* metil_group_planes = (
      metil_scene->renderables[
        example_3d_scene_index_renderable_planes
      ].renderable
    );

    metil_group_add_length_initialize(
      metil_group_planes,
      0x06,
      metil_renderable_type_model
    );

  for (
    unsigned char index_plane = (
      0x00
    );
    (
      index_plane <
      metil_group_planes->length
    );
    ++index_plane
  ) {
    struct metil_model* metil_model_plane = (
      metil_group_planes->renderables[
      index_plane
      ]->renderable
    );

  metil_model_objects_add_length(
    metil_model_plane,
    0x03
  );

  struct metil_object* metil_object_plane_body = (
    &metil_model_plane->objects[0x01]
);

  struct metil_object* metil_object_plane_wing_left = (
      &metil_model_plane->objects[0x00
  ]);

  struct metil_object* metil_object_plane_wing_right = (
      &metil_model_plane->objects[0x02
]);
  metil_mesh_gem_initialize(
    &metil_object_plane_body->mesh,
    (struct math_c_vector3_float) {
      .x = 0x20, .y = 0x20, .z = 0x80
    },
    (struct math_c_vector2_unsigned_short_int) {
      .x = 0x04, .y = 0x04
    }
  );  

  metil_mesh_gem_initialize(
    &metil_object_plane_wing_left->mesh,
    (struct math_c_vector3_float) {
      .x = 0x10, .y = 0x10, .z = 0x80
    }, (struct math_c_vector2_unsigned_short_int) {
        .x = 0x04, .y = 0x04
  }
);

metil_mesh_gem_initialize(
    &metil_object_plane_wing_right->mesh,
    (struct math_c_vector3_float) {
      .x = 0x10, .y = 0x10, .z = 0x80
    }, (struct math_c_vector2_unsigned_short_int) {
      .x = 0x04, .y = 0x04
    }
  );

  metil_model_vertex_joint_maps_initialize(
    metil_model_plane
  );

    metil_model_buffers_initialize(
    metil,
metil_model_plane,
metil->renderer_interface.metal_device

    );  
  metil_object_plane_wing_right->index_pipeline_render = (
    example_3d_rendering_index_pipeline_plane
  );

  metil_object_plane_body->index_pipeline_render = (
    example_3d_rendering_index_pipeline_plane
  );
  metil_object_plane_wing_left->index_pipeline_render = (
    example_3d_rendering_index_pipeline_plane
);

metil_object_plane_wing_left->position.x = (
  -0x11
);
metil_object_plane_wing_right->position.x = (
  0x11
);

metil_object_plane_wing_right->position.z = (
  -0x08
);

metil_object_plane_wing_left->position.z = (
  metil_object_plane_wing_right->position.z
);
metil_object_plane_wing_left->rotation.y = (1.1f);
metil_object_plane_wing_right->rotation.y = (
  -metil_object_plane_wing_left->rotation.y
);

    metil_model_plane->position.y = (
      0x3ff
    );

    metil_model_plane->position.x = (
      (index_plane % 2 == 0x00
      ? -1.0f
      : 0x01) *
       0x3ff * (index_plane / 0x02 + 0x01)
    );
}

  metil_group_add_length_initialize(
    metil_group_structures,
    0x10ff,
    metil_renderable_type_object
  );

  metil_group_add_length_initialize(
    metil_group_doors,
    metil_group_structures->length / 0x05 / 0x10 * 0x02,
    metil_renderable_type_object
  );

  for (
    unsigned int index_structure = (
      0x00
    );
    (
      index_structure <
      metil_group_structures->length
    );
    ++index_structure
  ) {
    struct metil_object* metil_object_structure = (
      metil_group_structures->renderables[
        index_structure
      ]->renderable
    );

    unsigned int index_room = (
      index_structure /
      0x05
    );

    unsigned char index_structure_part = (
      index_structure %
      0x05
    );

    metil_mesh_box_initialize(
      &metil_object_structure->mesh,
      (struct math_c_vector3_float) {
        .x = (
          0x06
        ),
        .y = (
          0xa0
        ),
        .z = (
          0xa0
        )
      }
    );

    metil_object_structure->position.x = (
      0x50 *
      (
        (index_structure_part
        < 0x02)
        ? (
          (index_structure_part)
          == 0x00
          ? -0x01
          : 0x01
        )
        : 0x00
      )
    );

    metil_object_structure->position.z = (
      0xa0 *
      index_room
    );

    if (
      (index_structure_part) > 0x01
    ) {
      metil_object_structure->rotation.z = (
        math_c_pi_half
      );

      if (index_structure_part == 0x02) {
        metil_object_structure->position.y = (
          -0x02
        );
      } else {    metil_object_structure->position.y = (
      0xa0 / 0x02 - 0x03
    );
  }
        
    }

    metil_object_buffers_initialize(
      metil_object_structure,
      metil->renderer_interface.metal_device
    );

    struct metil_renderer_data_object* data = (
      metil_object_structure->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );

float brightness = 1.0f;

if (index_room > 0xff && index_room < 0x01ff) {
  brightness = index_room % 4 == 0
  ;} else if (index_room > 0x02aa) {  
    brightness =math_c_maximum_float(0.0f, 1.0f - (float) (index_room - 0x02aa) / 0x00cc);
} else {
brightness = (float) ((index_room % 0x10) + 0x01) / 0x10;

  if (brightness > 1.0f) { brightness = 1.0f - (brightness - 1.0f); }
}

    data->colour.x = (
  brightness * (float)(
      (index_structure  % 0x0a) + 0x03)  / (float) 0x0c
);

  data->colour.y=(data->colour.x);
data->colour.z=data->colour.y;
}
metil_scene->length_textures=0x01;

clic3_memory_reallocate_raw(
&metil_scene->textures
,sizeof(id<MTLTexture>)*metil_scene->length_textures)
;
metil_scene->textures[0x00]=metil_example_3d_rendering_texture_door_generate(metil->renderer_interface.metal_device);  for (
    unsigned int index_door = (
      0x00
    );
    (
      index_door <
      metil_group_doors->length
    );
    ++index_door
  ) {
    struct metil_object* metil_object_door = (
      metil_group_doors->renderables[
        index_door
      ]->renderable
    );

    metil_mesh_box_initialize(
      &metil_object_door->mesh,
      (struct math_c_vector3_float) {
        .x = (
          0x50
        ),
        .y = (
          0xa0
        ),
        .z = (
          0x06
        )
      }
    );


    unsigned int index_room = (
      index_door / 0x02
    );

    if (
      index_door % 0x02 == 0x00
    ) {
      metil_object_door->position.x = (
        -0x28
      );
    } else {
      metil_object_door->position.x = (
        0x28
      );
    }

    metil_object_door->position.z = (
      index_room *
      0xa0 * 0x10
    );

    metil_object_buffers_initialize(
      metil_object_door,
      metil->renderer_interface.metal_device
    );

metil_object_texture_add(metil_object_door,metil_scene->textures[0x00]);

    struct metil_renderer_data_object* data = (
      metil_object_door->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );metil_object_door->index_pipeline_render=(example_3d_rendering_index_pipeline_door);

    data->colour.x = (0.9f + 0.1f * ((float) ((index_room + 0x05) % 0x09) / 0x08));
    data->colour.y = (data->colour.x);
    data->colour.z = (data->colour.x);  }

  struct metil_group* metil_group_solar_system = (
    metil_scene->renderables[
      example_3d_scene_index_renderable_solar_system
    ].renderable
  );

  metil_group_add_length_initialize(
    metil_group_solar_system,
    0x10ff,
    metil_renderable_type_object
  );

  for (
    unsigned short int index_solar_system_object = (
      0x00
    );
    (
      index_solar_system_object <
    metil_group_solar_system->length
  );
++index_solar_system_object
) {
  struct metil_object* metil_object_solar_system_object = (
    metil_group_solar_system->renderables[
      index_solar_system_object
    ]->renderable
    );

  metil_mesh_sphere_initialize(
    &metil_object_solar_system_object->mesh,
    0x00ff + 0x1000 * (float) ( index_solar_system_object * 0x88 % 0xfab) / 0xfaa,
    (struct math_c_vector2_unsigned_short_int) {
    .x = (0x0a), .y = 0x0a });

  metil_object_solar_system_object->position.x = (
    0xffff * ((index_solar_system_object * 0xcab9 % 0xa0) - (0xa0 - 0x01) / 0x02) + (0xffff * ((index_solar_system_object * 0x78 % 0x20) - (0x1f / 0x02)))
  );


metil_object_solar_system_object->position.x = (
  metil_object_solar_system_object->position.x
+(
  (metil_object_solar_system_object->position.x < 0x00) ? -0x186a0 : 0x186a0)) / 0x04;

metil_object_solar_system_object->position.z = (
    0xffff * ((index_solar_system_object * 0x711 % 0x80) - (0x80 - 0x01) / 0x02) +
    (0xffff * ((index_solar_system_object * 0xb8c % 0x28) - (0x27 / 0x02))));

metil_object_solar_system_object->position.z = (
  metil_object_solar_system_object->position.z +
  ((metil_object_solar_system_object->position.z < 0x00) ? -0x186a0 : 0x186a0)) / 0x04;

metil_object_solar_system_object->position.y = (
    0xffff * (((index_solar_system_object * 0x4f2 + 0x32) % 0x78) - (0x78 - 0x01) / 0x02) +
(0xffff * (((index_solar_system_object * 0x63 + 0x34) % 0x10) - (0x09 / 0x02))));

metil_object_solar_system_object->position.y = (metil_object_solar_system_object->position.y +( (
  metil_object_solar_system_object->position.y < 0x00)?-0x186a0 : 0x186a0)) / 0x04;
  metil_object_buffers_initialize(
    metil_object_solar_system_object,
    metil->renderer_interface.metal_device
  );

  metil_object_buffers_initialize(
    metil_object_solar_system_object,
    metil->renderer_interface.metal_device
  );
}

  metil_scene->player.position.z = -0x80ff;
}

void example_3d_scene_poll(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
struct metil_group* metil_group_doors = (
    metil_scene->renderables[
        example_3d_scene_index_renderable_doors
    ].renderable
  );

if (
   metil_scene->player.position.z < 0x00) {
  
  struct metil_group* metil_group_planes = (
    metil_scene->renderables[
      example_3d_scene_index_renderable_planes
    ].renderable
  );

  for (
      unsigned char index_plane = (
        0x00
      );
      (
        index_plane <
    metil_group_planes->length
      );
    ++index_plane
  ) {
    struct metil_model* metil_model_plane = (
      metil_group_planes->renderables[
        index_plane
      ]->renderable
    );

      metil_model_plane->position.z = (
        metil_scene->time_elapsed * 9.5f - 
        0x83ff - (
          index_plane / 0x02) * 0x2ff
      );
    }
}
    for (
      unsigned int index_room = (
        0x00
      );
      (
        index_room <
        metil_group_doors->length / 0x02
      );
      ++index_room
    ) {
      struct metil_object* metil_object_door_left = (
        metil_group_doors->renderables[
          index_room * 0x02
        ]->renderable
      );

      struct metil_object* metil_object_door_right = (
        metil_group_doors->renderables[
          index_room * 0x02
        + 0x01
        ]->renderable
      );

      metil_object_door_left->position.x = (
        -0x28 -
      (1.0f - 
         math_c_maximum_float(0x00,math_c_minimum_float((metil_object_door_left->position.z - metil_scene->player.position.z - 0x10) / 0x12ff, 0x01)
      )) * 0x50
      );

      metil_object_door_right->position.x = (
        -metil_object_door_left->position.x
      );    

  
    }
  

  struct metil_object* metil_object_sky = (
    metil_scene->renderables[
      example_3d_scene_index_renderable_sky
    ].renderable
  );

struct metil_group* metil_group_solar_system = (
    metil_scene->renderables[
      example_3d_scene_index_renderable_solar_system
    ].renderable
  );

for (unsigned short int index_object = 0x00;index_object <metil_group_solar_system->length;++index_object){
struct metil_object* metil_object_system = metil_group_solar_system->renderables[index_object]->renderable;
  metil_object_system->rotation.x = (
    metil_object_system->rotation.x +
    0.0001f * metil_scene->time_delta
  );

  metil_object_system->rotation.y = (
    metil_object_system->rotation.y +
    0.00001f * metil_scene->time_delta
);

struct metil_renderer_data_object* data =(
metil_object_system->buffers_vertex[
  metil_object_buffer_default_index_data
].buffer.contents
);

data->colour.x = (
  1.0f - ((float) (
  (metil_scene->time_elapsed / 0xfff + index_object * 0xfa) % 0xffff) / 0xffff)
);

data->colour.y = (
  data->colour.x * 0.95f
);
data->colour.z = (
  data->colour.x * 0.9f
);
data->colour.w = (data->colour.z);
}
  metil_object_sky->rotation.y = (
    metil_object_sky->rotation.y +
    -0.00001f *
    metil_scene->time_delta
  );

  struct metil_player* metil_player = &(
    metil_scene->player
  );

  if (metil_player->position.z < -0xff) {
    metil_player->rotation.x = (
      math_c_sine(
        (math_c_absolute_float(metil_player->position.z + 0xff) / 0x8000) * math_c_pi, math_c_pi
) * 0.75f);  

    metil_player->rotation.y = (
        metil_player->rotation.x / 0x04);
}

  if (
    metil_player->position.z < 0x10ff * 0xaa / 5 
  ) {
    metil_player->position.z = (
      metil_player->position.z +
      (float) metil_scene->time_delta *
       0x08
     );        
  }
else {
    metil_player->position.z =    (  metil_player->position.z +
      (float) metil_scene->time_delta *
      0x08 *
      (1.0f - 
      math_c_minimum_float(
      (metil_scene->time_elapsed - 0x4650), 0x186a0) / 0x186af)
    );  

  }

  if (
    metil_player->position.z >= 0x00ff * 0xaa / 0x05 &&
    metil_player->rotation.y > -math_c_pi
  
    ) {
metil_player->rotation.y = (metil_player->rotation.y - (float)metil_scene->time_delta / 3000.0f);
  }
  if (

  metil_scene->time_elapsed > 0x1600 &&  metil_scene->time_elapsed < 0x1300 + 0x1600) {  metil_player->rotation.x = math_c_absolute_float(math_c_sine((float) (metil_scene->time_elapsed - 0x1600) * math_c_pi / 5000.0f,math_c_pi) * math_c_pi_half);  
  }
  metil_player->position.y = (
    math_c_sine(
     (float)      metil_scene->time_elapsed / 750.0f
    ,math_c_pi) * 5.6f
  );
  metil_player->position.x = (
    math_c_sine(
      (float)
      metil_scene->time_elapsed / 760.0f
  + 30.0f,math_c_pi) * 4.4f);  
  metil_scene_poll_default(
    metil,
    metil_scene
  );
}
