#include <metil_editor_scene.h>

#include <metil_editor_scene_data.h>

#include <clic3_memory.h>

#include <math_c_pi.h>
#include <math_c_vector.h>

#include <metil.h>
#include <metil_group.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_grid.h>
#include <metil_object/metil_object.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderable_type.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/metil_scene.h>

void metil_editor_scene_initialize(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  metil_scene_initialize_with_renderables(
    metil,
    metil_scene,
    metil_editor_scene_length_renderables
  );
  
  metil_scene->data = (
    clic3_memory_allocate_raw(
      sizeof(
        struct metil_editor_scene_data
      )
    )
  );
  
  metil_scene->poll = (
    metil_editor_scene_poll
  );
  
  metil_scene->destroy = (
    metil_editor_scene_destroy
  );
  
  for (
    unsigned char index_renderable = (
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
      case metil_editor_scene_index_renderable_group_grids: {
        metil_renderable_initialize_at_index(
          metil_scene->renderables,
          index_renderable,
          metil_renderable_type_group
        );
        
        break;
      }
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
  
  struct metil_group* metil_group_grids = (
    metil_scene->renderables[
      metil_editor_scene_index_renderable_group_grids
    ].renderable
  );
  
  struct metil_object* metil_object_lines = (
    metil_scene->renderables[
      metil_editor_scene_index_renderable_lines
    ].renderable
  );
  
  struct metil_object* metil_object_points = (
    metil_scene->renderables[
      metil_editor_scene_index_renderable_points
    ].renderable
  );
  
  metil_group_add_length_initialize(
    metil_group_grids,
    0x06,
    metil_renderable_type_object
  );
  
  for (
    unsigned char index_grid = (
      0x00
    );
    (
      index_grid <
      metil_group_grids->length
    );
    ++index_grid
  ) {
    struct metil_object* metil_object_grid = (
      metil_group_grids->renderables[
        index_grid
      ]->renderable
    );
    
    unsigned char subgrid = (
      index_grid %
      0x02
    );
    
    unsigned long int length_cells = (
      (
        subgrid ==
        0x00
      )
      ? 0x64
      : 0x03e8
    );
      
    metil_mesh_celled_grid_initialize(
      &metil_object_grid->mesh,
      (struct math_c_vector2_float) {
        .x = (
          0x64
        ),
        .y = (
          0x64
        )
      },
      (struct math_c_vector2_unsigned_long_int) {
        .x = (
          length_cells
        ),
        .y = (
          length_cells
        )
      }
    );
    
    metil_object_buffers_initialize(
      metil_object_grid,
      metil->renderer_interface.metal_device
    );
    
    struct metil_renderer_data_object* metil_renderer_data_object = (
      metil_object_grid->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );
      
    metil_renderer_data_object->colour.w = (
      (
        subgrid ==
        0x00
      )
      ? 0.25f
      : 0.025f
    );
    
    switch (
      index_grid /
      0x02
    ) {
      case 0x00: {
        metil_object_grid->position.y = (
          metil_object_grid->mesh.size.y /
          0x64
        );
      
        metil_object_grid->rotation.x = (
          math_c_pi_half
        );
        
        break;
      }
      case 0x01: {
        metil_object_grid->rotation.y = (
          math_c_pi_half
        );
        
        break;
      }
      default: {
        break;
      }
    }
    
    metil_object_grid->type_primitive = (
      MTLPrimitiveTypeLine
    );
  }
  
  metil_mesh_initialize(
    &metil_object_lines->mesh
  );
  
  metil_mesh_initialize(
    &metil_object_points->mesh
  );
  
  metil_object_buffers_initialize(
    metil_object_lines,
    metil->renderer_interface.metal_device
  );
  
  metil_object_buffers_add(
    metil_object_points,
    metil->renderer_interface.metal_device,
    metil_object_buffer_type_vertex
  );
  
  metil_object_buffers_add(
    metil_object_points,
    metil->renderer_interface.metal_device,
    metil_object_buffer_type_vertex
  );
  
  metil_object_points->buffers_vertex[
    0x00
  ].buffer = (
    metil_object_lines->buffers_vertex[
      0x00
    ].buffer
  );
  
  metil_object_points->buffers_vertex[
    0x01
  ].buffer = (
    metil_object_lines->buffers_vertex[
      0x01
    ].buffer
  );  

  metil_object_indices_initialize(
    metil_object_points,
    metil->renderer_interface.metal_device
  );
  
  metil_object_lines->visible = (
    0x00
  );
  
  metil_object_points->visible = (
    0x00
  );
  
  metil_scene->player.position.x = (
    0x0a
  );
  
  metil_scene->player.position.y = (
    0x0a
  );
  
  metil_scene->player.position.z = -(
    0x0a
  );
  
  metil_scene->player.poll_input = (
    metil_player_poll_input_free_flying_unlocked
  );
  
  metil_scene->player.rotation.y = (
    math_c_pi_half /
    0x02
  );
}

void metil_editor_scene_poll(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  metil_scene_poll_default(
    metil,
    metil_scene
  );
  
  struct metil_editor_scene_data* metil_editor_scene_data = (
    metil_scene->data
  );
  
  if (
    metil_editor_scene_data->movement_free ==
    0x01
  ) {
    metil_scene->player.position = (
      metil_editor_scene_data->position_player
    );
  } else {
    metil_editor_scene_data->position_player = (
      metil_scene->player.position
    );
  }
  
  struct metil_object* metil_object_lines = (
    metil_scene->renderables[
      metil_editor_scene_index_renderable_lines
    ].renderable
  );
  
  struct metil_object* metil_object_points = (
    metil_scene->renderables[
      metil_editor_scene_index_renderable_points
    ].renderable
  );
  
  if (
    metil_object_lines->mesh.length_vertices ==
    0x00
  ) {
    metil_object_lines->visible = (
      0x00
    ); 
  } else {    metil_object_lines->visible = (
      0x01
    );
  }
  
  metil_object_points->visible = (
    metil_object_lines->visible
  );}

void metil_editor_scene_destroy(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  struct metil_object* metil_object_points = (
    metil_scene->renderables[
      metil_editor_scene_index_renderable_points
    ].renderable
  );
  
  metil_object_points->buffers_vertex[
    0x00
  ].buffer = (
    0x00
  );
  
  metil_object_points->buffers_vertex[
    0x01
  ].buffer = (
    0x00
  );

  metil_scene_destroy_default(
    metil,
    metil_scene
  );
}
