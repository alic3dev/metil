#include <example_3d_scene.h>

#include <3d_rendering_objects/3d_rendering_ground.h>
#include <3d_rendering_objects/3d_rendering_sky.h>
#include <example_3d_rendering_index_pipeline.h>

#include <metil.h>
#include <metil_group.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_grid.h>
#include <metil_mesh/metil_mesh_box.h>
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
      case example_3d_scene_index_renderable_structures:
      case example_3d_scene_index_renderable_doors: {
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

  metil_group_add_length_initialize(
    metil_group_structures,
    0x10ff,
    metil_renderable_type_object
  );

  metil_group_add_length_initialize(
    metil_group_doors,
    0x10ff,
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
  ;}

if (index_room > 0x02aa) {
  
    brightness =math_c_maximum_float(0.0f, 1.0f - (float) (index_room - 0x02aa) / 0x00cc);
}
    data->colour.x = (
  brightness * (float)(
      (index_structure  % 0x0a) + 0x03)  / (float) 0x0c
);

  data->colour.y=(data->colour.x);
data->colour.z=data->colour.y;
}

  for (
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
          0x05
        ),
        .y = (
          0x0a
        ),
        .z = (
          0x01
        )
      }
    );

    metil_object_buffers_initialize(
      metil_object_door,
      metil->renderer_interface.metal_device
    );
  }
}

void example_3d_scene_poll(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  struct metil_object* metil_object_sky = (
    metil_scene->renderables[
      example_3d_scene_index_renderable_sky
    ].renderable
  );

  metil_object_sky->rotation.y = (
    metil_object_sky->rotation.y +
    -0.00001f *
    metil_scene->time_delta
  );

  struct metil_player* metil_player = &(
    metil_scene->player
  );

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
