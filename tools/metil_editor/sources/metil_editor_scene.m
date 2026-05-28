#include <metil_editor_scene.h>

#include <metil_editor_index_pipeline_render.h>
#include <metil_editor_scene_data.h>

#include <clic3_bytes.h>
#include <clic3_memory.h>

#include <math_c_maximum.h>
#include <math_c_pi.h>
#include <math_c_vector.h>
#include <math_c_vector_distance.h>

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
  struct metil_editor_index_pipeline_render* metil_editor_index_pipeline_render = (
    metil->data
  );

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

  struct metil_editor_scene_data* metil_editor_scene_data = (
    metil_scene->data
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
      case metil_editor_scene_index_renderable_group_grids:
      case metil_editor_scene_index_renderable_group_text_position_cursor:
      case metil_editor_scene_index_renderable_group_text_position_vertex:
      case metil_editor_scene_index_renderable_group_text_length_vertices: {
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

  struct metil_object* metil_object_grid_lines = (
    metil_scene->renderables[
      metil_editor_scene_index_renderable_grid_lines
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
  
  struct metil_object* metil_object_triangles = (
    metil_scene->renderables[
      metil_editor_scene_index_renderable_triangles
    ].renderable
  );

  struct metil_object* metil_object_cursor = (
    metil_scene->renderables[
      metil_editor_scene_index_renderable_cursor
    ].renderable
  );

  struct metil_group* metil_group_text_position_cursor = (
    metil_scene->renderables[
      metil_editor_scene_index_renderable_group_text_position_cursor
    ].renderable
  );

  struct metil_group* metil_group_text_position_vertex = (
    metil_scene->renderables[
      metil_editor_scene_index_renderable_group_text_position_vertex
    ].renderable
  );

  struct metil_group* metil_group_text_length_vertices = (
    metil_scene->renderables[
      metil_editor_scene_index_renderable_group_text_length_vertices
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
      ? 0.025f
      : 0.0125f
    );

    switch (
      index_grid /
      0x02
    ) {
      case 0x00: {
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

    metil_object_grid->depth_disabled = (
      0x01
    );
  }

  metil_mesh_initialize_with_lengths(
    &metil_object_grid_lines->mesh,
    0x06,
    0x06
  );

  for (
    unsigned char index_vertex = (
      0x00
    );
    (
      index_vertex <
      metil_object_grid_lines->mesh.length_vertices
    );
    ++index_vertex
  ) {
    float inverter = (
      (
        (
          index_vertex %
          0x02
        ) ==
        0x00
      )
      ?  0x01
      : -0x01
    );

    unsigned char index_axis = (
      index_vertex /
      0x02
    );

    metil_object_grid_lines->mesh.vertices[
      index_vertex
    ].x = (
      (
        index_axis ==
        0x00
      )
      ? (
        0x64 *
        inverter
      )
      : 0x00
    );

    metil_object_grid_lines->mesh.vertices[
      index_vertex
    ].y = (
      (
        index_axis ==
        0x01
      )
      ? (
        0x64 *
        inverter
      )
      : 0x00
    );

    metil_object_grid_lines->mesh.vertices[
      index_vertex
    ].z = (
      (
        index_axis ==
        0x02
      )
      ? (
        0x64 *
        inverter
      )
      : 0x00
    );

    metil_object_grid_lines->mesh.vertices[
      index_vertex
    ].w = (
      0x01
    );

    metil_object_grid_lines->mesh.indices[
      index_vertex
    ] = (
      index_vertex
    );
  }

  metil_object_buffers_initialize(
    metil_object_grid_lines,
    metil->renderer_interface.metal_device
  );

  metil_object_grid_lines->index_pipeline_render = (
    metil_editor_index_pipeline_render->grid_lines
  );

  metil_object_grid_lines->type_primitive = (
    MTLPrimitiveTypeLine
  );

  metil_object_grid_lines->depth_disabled = (
    0x01
  );

  metil_mesh_initialize(
    &metil_object_lines->mesh
  );

  metil_mesh_initialize(
    &metil_object_points->mesh
  );
  
  metil_mesh_initialize(
    &metil_object_triangles->mesh
  );

  metil_object_buffers_add(
    metil_object_lines,
    metil->renderer_interface.metal_device,
    metil_object_buffer_type_vertex
  );

  metil_object_buffers_add(
    metil_object_lines,
    metil->renderer_interface.metal_device,
    metil_object_buffer_type_vertex
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
  
  metil_object_buffers_add(
    metil_object_triangles,
    metil->renderer_interface.metal_device,
    metil_object_buffer_type_vertex
  );

  metil_object_buffers_add(
    metil_object_triangles,
    metil->renderer_interface.metal_device,
    metil_object_buffer_type_vertex
  );

  metil_object_lines->type_primitive = (
    MTLPrimitiveTypeLineStrip
  );

  metil_object_points->type_primitive = (
    MTLPrimitiveTypePoint
  );
  
  metil_object_lines->index_pipeline_render = (
    metil_editor_index_pipeline_render->vertex_lines
  );

  metil_object_points->index_pipeline_render = (
    metil_editor_index_pipeline_render->vertex_points
  );
  
  metil_object_triangles->index_pipeline_render = (
    metil_editor_index_pipeline_render->vertex_triangles
  );
  
  metil_object_lines->indices = [
    metil->renderer_interface.metal_device
    newBufferWithLength: (
      sizeof(
        unsigned int
      ) *
      0xffff
    )
    options: (
      MTLResourceStorageModeShared
    )
  ];

  metil_object_lines->buffers_vertex[
    metil_object_buffer_default_index_vertices
  ].buffer = [
    metil->renderer_interface.metal_device
    newBufferWithLength: (
      sizeof(
        struct math_c_vector4_float
      ) *
      0xffff
    )
    options: (
      MTLResourceStorageModeShared
    )
  ];

  metil_object_lines->buffers_vertex[
    metil_object_buffer_default_index_data
  ].buffer = [
    metil->renderer_interface.metal_device
    newBufferWithLength: (
      sizeof(
        struct metil_renderer_data_object
      )    )
    options: (
      MTLResourceStorageModeShared
    )
  ];

  metil_renderer_data_object_initialize(
    metil_object_lines->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );
  
  metil_object_points->indices = [
    metil->renderer_interface.metal_device
    newBufferWithLength: (
      sizeof(
        unsigned int
      ) *
      0xffff
    )
    options: (
      MTLResourceStorageModeShared
    )
  ];
  
  metil_object_triangles->indices = [
    metil->renderer_interface.metal_device
    newBufferWithLength: (
      sizeof(
        unsigned int
      ) *
      0xffff
    )
    options: (
      MTLResourceStorageModeShared
    )
  ];

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
  
  metil_object_triangles->buffers_vertex[
    0x00
  ].buffer = (
    metil_object_lines->buffers_vertex[
      0x00
    ].buffer
  );

  metil_object_triangles->buffers_vertex[
    0x01
  ].buffer = (
    metil_object_lines->buffers_vertex[
      0x01
    ].buffer
  );
  
  metil_object_lines->visible = (
    0x00
  );

  metil_object_points->visible = (
    0x00
  );
  
  metil_object_triangles->visible = (
    0x00
  );

  metil_mesh_initialize_with_lengths(
    &metil_object_cursor->mesh,
    0x01,
    0x01
  );

  metil_object_cursor->mesh.vertices[
    0x00
  ].x = (
    0x00
  );

  metil_object_cursor->mesh.vertices[
    0x00
  ].y = (
    0x00
  );

  metil_object_cursor->mesh.vertices[
    0x00
  ].z = (
    0x00
  );

  metil_object_cursor->mesh.vertices[
    0x00
  ].w = (
    0x01
  );

  metil_object_cursor->mesh.indices[
    0x00
  ] = (
    0x00
  );
  
  metil_object_buffers_initialize(
    metil_object_cursor,
    metil->renderer_interface.metal_device
  );

  struct metil_renderer_data_object* metil_renderer_data_object_cursor = (
    metil_object_cursor->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  metil_renderer_data_object_cursor->colour.w = (
    0.25f
  );

  metil_object_cursor->type_primitive = (
    MTLPrimitiveTypePoint
  );

  metil_object_cursor->index_pipeline_render = (
    metil_editor_index_pipeline_render->cursor
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
    metil_player_poll_input_free_flying_locked
  );

  metil_scene->player.rotation.y = (
    math_c_pi_half /
    0x02
  );

  metil_editor_scene_data->movement_free = (
    0x01
  );

  metil_editor_scene_data->mode = (
    metil_editor_mode_vertices
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
  
  struct metil_object* metil_object_triangles = (
    metil_scene->renderables[
      metil_editor_scene_index_renderable_triangles
    ].renderable
  );

  struct metil_object* metil_object_cursor = (
    metil_scene->renderables[
      metil_editor_scene_index_renderable_cursor
    ].renderable
  );

  if (
    metil->input.keydown_map[
      metil_keycode_g
    ] !=
    0x00
  ) {
    if (
      metil->input.keydown_map[
        metil_keycode_x
      ] !=
      0x00
    ) {
      struct metil_object* metil_object_grid_x = (
        metil_group_grids->renderables[
          0x00
        ]->renderable
      );

      struct metil_object* metil_object_grid_sub_x = (
        metil_group_grids->renderables[
          0x01
        ]->renderable
      );

      metil_object_grid_x->visible = (
        (
          metil_object_grid_x->visible ==
          0x00
        )
        ? 0x01
        : 0x00
      );

      metil_object_grid_sub_x->visible = (
        metil_object_grid_x->visible
      );

      metil->input.keydown_map[
        metil_keycode_x
      ] = (
        0x00
      );
    }
    if (
      metil->input.keydown_map[
        metil_keycode_y
      ] !=
      0x00
    ) {
      struct metil_object* metil_object_grid_y = (
        metil_group_grids->renderables[
          0x02
        ]->renderable
      );

      struct metil_object* metil_object_grid_sub_y = (
        metil_group_grids->renderables[
          0x03
        ]->renderable
      );

      metil_object_grid_y->visible = (
        (
          metil_object_grid_y->visible ==
          0x00
        )
        ? 0x01
        : 0x00
      );

      metil_object_grid_sub_y->visible = (
        metil_object_grid_y->visible
      );

      metil->input.keydown_map[
        metil_keycode_y
      ] = (
        0x00
      );
    }

    if (
      metil->input.keydown_map[
        metil_keycode_z
      ] !=
      0x00
    ) {
      struct metil_object* metil_object_grid_z = (
        metil_group_grids->renderables[
          0x04
        ]->renderable
      );

      struct metil_object* metil_object_grid_sub_z = (
        metil_group_grids->renderables[
          0x05
        ]->renderable
      );

      metil_object_grid_z->visible = (
        (
          metil_object_grid_z->visible ==
          0x00
        )
        ? 0x01
        : 0x00
      );

      metil_object_grid_sub_z->visible = (
        metil_object_grid_z->visible
      );

      metil->input.keydown_map[
        metil_keycode_z
      ] = (
        0x00
      );
    }
  } else if (
    metil->input.keydown_map[
      metil_keycode_tab
    ] !=
    0x00
  ) {
    metil->input.keydown_map[
      metil_keycode_tab
    ] = (
      0x00
    );

    metil_editor_scene_data->movement_free = (
      (
        metil_editor_scene_data->movement_free ==
        0x00
      )
      ? 0x01
      : 0x00
    );
  } else if (
    metil_editor_scene_data->mode ==
    metil_editor_mode_vertices
  ) {
    if (
      metil->input.keydown_map[
        metil_keycode_period
      ] !=
      0x00
    ) {
      metil_object_lines->mesh.length_vertices = (
        metil_object_lines->mesh.length_vertices +
        0x01
      );

      metil_object_lines->mesh.length_indices = (
        metil_object_lines->mesh.length_indices +
        0x01
      );
      
      metil_object_points->mesh.length_indices = (
        metil_object_points->mesh.length_indices +
        0x01
      );      

      struct math_c_vector4_float* vertices_lines = (
        metil_object_lines->buffers_vertex[
          metil_object_buffer_default_index_vertices
        ].buffer.contents
      );

      vertices_lines[
        metil_object_lines->mesh.length_vertices -
        0x01
      ] = (
        (struct math_c_vector4_float)
        {
          .x = (
            metil_object_cursor->position.x
          ),
          .y = (
            metil_object_cursor->position.y
          ),
          .z = (
            metil_object_cursor->position.z
          ),
          .w = (
            0x01
          )
        }
      );

      unsigned int* indices_lines = (
        metil_object_lines->indices.contents
      );
      
      unsigned int* indices_points = (
        metil_object_points->indices.contents
      );

      indices_lines[
        metil_object_lines->mesh.length_indices -
        0x01
      ] = (
        metil_object_lines->mesh.length_vertices -
        0x01
      );

      indices_points[
        metil_object_points->mesh.length_indices -
        0x01
      ] = (
        metil_object_points->mesh.length_indices -
        0x01
      );
      
      metil->input.keydown_map[
        metil_keycode_period
      ] = (
        0x00
      );
    } else if (
      (
        metil_object_lines->mesh.length_vertices >
        0x00
      ) &&
      (
        metil->input.keydown_map[
          metil_keycode_slash
        ] !=
        0x00
      )
    ) {
      metil_object_triangles->mesh.length_indices = (
        metil_object_triangles->mesh.length_indices +
        0x01
      );
      
      unsigned int index_vertex_closest = (
        0x00
      );
      
      struct math_c_vector4_float* vertices = (
        metil_object_lines->buffers_vertex[
          metil_object_buffer_default_index_vertices
        ].buffer.contents
      );
     
      struct math_c_vector3_float position_vertex = {
        .x = (
          vertices[
            0x00
          ].x
        ),
        .y = (
          vertices[
            0x00
          ].y
        ),
        .z = (
          vertices[
            0x00
          ].z
        )
      };
      
      float distance = (
        math_c_vector3_distance_float(
          &metil_object_cursor->position,
          &position_vertex
        )
      );
                  
      for (
        unsigned int index_vertex = (
          0x01
        );
        (
          index_vertex <
          metil_object_lines->mesh.length_vertices
        );
        ++index_vertex
      ) {
        position_vertex.x = (          vertices[
            index_vertex
          ].x
        );
        
        position_vertex.y = (
          vertices[
            index_vertex
          ].y
        );
        
        position_vertex.z = (
          vertices[
            index_vertex
          ].z
        );
        
        float distance_vertex = (
          math_c_vector3_distance_float(
            &metil_object_cursor->position,
            &position_vertex
          )
        );        
        
        if (
          distance_vertex <=
          distance
        ) {
          index_vertex_closest = (
            index_vertex
          );
          
          distance = (
            distance_vertex
          );
        }
      }
      
      unsigned int* indices_triangles = (
        metil_object_triangles->indices.contents
      );
      
      indices_triangles[
        metil_object_triangles->mesh.length_indices -
        0x01
      ] = (
        index_vertex_closest
      );
      
      metil->input.keydown_map[
        metil_keycode_slash
      ] = (
        0x00
      );
    }
  }

  if (
    metil_editor_scene_data->movement_free ==
    0x00
  ) {
    metil_object_cursor->position.x = (
      metil_object_cursor->position.x +
      (
        metil_scene->player.position.x -
        metil_editor_scene_data->position_player.x
      ) /
      0x04
    );

    metil_object_cursor->position.y = (
      metil_object_cursor->position.y +
      (
        metil_scene->player.position.y -
        metil_editor_scene_data->position_player.y
      ) /
      0x04
    );

    metil_object_cursor->position.z = (
      metil_object_cursor->position.z +
      (
        metil_scene->player.position.z -
        metil_editor_scene_data->position_player.z
      ) /
      0x04
    );

    metil_scene->player.position = (
      metil_editor_scene_data->position_player
    );
  } else {
    metil_editor_scene_data->position_player = (
      metil_scene->player.position
    );
  }

  metil_object_cursor->mesh.size.x = (
    math_c_maximum_float(
      (
        (
          0x10 -
          math_c_vector3_distance_float_fastest(
            &metil_object_cursor->position,
            &metil_scene->player.position
          )
        ) /
        0x10 *
        0x32
      ),
      0x0a
    )
  );

  if (
    metil_object_lines->mesh.length_vertices <=
    0x01
  ) {
    metil_object_lines->visible = (
      0x00
    );
  } else {
    metil_object_lines->visible = (
      0x01
    );
  }

  if (
    metil_object_points->mesh.length_indices ==
    0x00
  ) {
    metil_object_points->visible = (
      0x00
    );
  } else {
    metil_object_points->visible = (
      0x01
    );
  }
  
  if (
    metil_object_triangles->mesh.length_indices <
    0x03
  ) {
    metil_object_triangles->visible = (
      0x00
    );
  } else {
    metil_object_triangles->visible = (
      0x01
    );
  }
}

void metil_editor_scene_destroy(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  struct metil_object* metil_object_points = (
    metil_scene->renderables[
      metil_editor_scene_index_renderable_points
    ].renderable
  );
  
  struct metil_object* metil_object_triangles = (
    metil_scene->renderables[
      metil_editor_scene_index_renderable_triangles
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
  
  metil_object_triangles->buffers_vertex[
    0x00
  ].buffer = (
    0x00
  );

  metil_object_triangles->buffers_vertex[
    0x01
  ].buffer = (
    0x00
  );

  metil_scene_destroy_default(
    metil,
    metil_scene
  );
}
