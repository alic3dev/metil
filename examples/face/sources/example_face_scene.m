#include <example_face_scene.h>

#include <example_face_pipeline_index.h>
#include <example_face_renderer_data_object.h>

#include <clic3_memory.h>

#include <math_c_power.h>
#include <math_c_square_root.h>

#include <metil.h>
#include <metil_mesh/metil_mesh.h>
#include <metil_input/metil_cursor.h>
#include <metil_object.h>
#include <metil_player/metil_player.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderable_type.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/metil_scene.h>

void example_face_scene_initialize(
  struct metil* metil,
  struct metil_scene* scene
) {
  metil_scene_initialize_with_renderables(
    metil,
    scene,
    2
  );

  scene->player.position.z = -(
    0x01
  );

  scene->player.poll_input = (
    metil_player_poll_input_null
  );

  scene->destroy = (
    example_face_scene_destroy
  );

  metil->rendering_properties.camera.height = (
    0x00
  );

  metil_renderable_initialize_at_index(
    scene->renderables,
    0x00,
    metil_renderable_type_object
  );

  metil_renderable_initialize_at_index(
    scene->renderables,
    0x01,
    metil_renderable_type_object
  );

  struct metil_object* object = (
    scene->renderables[
      0x00
    ].renderable
  );

  struct metil_mesh* metil_mesh = (
    &object->mesh
  );

  metil_mesh_initialize_with_lengths(
    metil_mesh,
    0x21,
    0x9c
  );

  metil_mesh->vertices[0].x = -0.9f;
  metil_mesh->vertices[0].y = 0.8f;
  metil_mesh->vertices[0].z = 0.3f;
  metil_mesh->vertices[0].w = 1.0f;

  metil_mesh->vertices[1].x = -0.4f;
  metil_mesh->vertices[1].y = 0.9f;
  metil_mesh->vertices[1].z = 0.3f;
  metil_mesh->vertices[1].w = 1.0f;

  metil_mesh->vertices[2].x = 0.0f;
  metil_mesh->vertices[2].y = 1.0f;
  metil_mesh->vertices[2].z = 0.3f;
  metil_mesh->vertices[2].w = 1.0f;

  metil_mesh->vertices[3].x = 0.4f;
  metil_mesh->vertices[3].y = 0.9f;
  metil_mesh->vertices[3].z = 0.3f;
  metil_mesh->vertices[3].w = 1.0f;

  metil_mesh->vertices[4].x = 0.9f;
  metil_mesh->vertices[4].y = 0.8f;
  metil_mesh->vertices[4].z = 0.3f;
  metil_mesh->vertices[4].w = 1.0f;

  metil_mesh->vertices[5].x = -1.0f;
  metil_mesh->vertices[5].y = 0.1f;
  metil_mesh->vertices[5].z = 0.3f;
  metil_mesh->vertices[5].w = 1.0f;

  metil_mesh->vertices[6].x = -0.6f;
  metil_mesh->vertices[6].y = 0.2f;
  metil_mesh->vertices[6].z = 0.0f;
  metil_mesh->vertices[6].w = 1.0f;

  metil_mesh->vertices[7].x = -0.2f;
  metil_mesh->vertices[7].y = 0.25f;
  metil_mesh->vertices[7].z = 0.0f;
  metil_mesh->vertices[7].w = 1.0f;

  metil_mesh->vertices[8].x = 0.2f;
  metil_mesh->vertices[8].y = 0.25f;
  metil_mesh->vertices[8].z = 0.0f;
  metil_mesh->vertices[8].w = 1.0f;

  metil_mesh->vertices[9].x = 0.6f;
  metil_mesh->vertices[9].y = 0.2f;
  metil_mesh->vertices[9].z = 0.0f;
  metil_mesh->vertices[9].w = 1.0f;

  metil_mesh->vertices[10].x = 1.0f;
  metil_mesh->vertices[10].y = 0.1f;
  metil_mesh->vertices[10].z = 0.3f;
  metil_mesh->vertices[10].w = 1.0f;

  metil_mesh->vertices[11].x = -0.5f;
  metil_mesh->vertices[11].y = 0.04f;
  metil_mesh->vertices[11].z = 0.0f;
  metil_mesh->vertices[11].w = 1.0f;

  metil_mesh->vertices[12].x = -0.3f;
  metil_mesh->vertices[12].y = 0.05f;
  metil_mesh->vertices[12].z = 0.2f;
  metil_mesh->vertices[12].w = 1.0f;

  metil_mesh->vertices[13].x = 0.0f;
  metil_mesh->vertices[13].y = 0.05f;
  metil_mesh->vertices[13].z = 0.0f;
  metil_mesh->vertices[13].w = 1.0f;

  metil_mesh->vertices[14].x = 0.3f;
  metil_mesh->vertices[14].y = 0.05f;
  metil_mesh->vertices[14].z = 0.2f;
  metil_mesh->vertices[14].w = 1.0f;

  metil_mesh->vertices[15].x = 0.5f;
  metil_mesh->vertices[15].y = 0.04f;
  metil_mesh->vertices[15].z = 0.0f;
  metil_mesh->vertices[15].w = 1.0f;

  metil_mesh->vertices[16].x = 0.0f;
  metil_mesh->vertices[16].y = 0.0f;
  metil_mesh->vertices[16].z = 0.0f;
  metil_mesh->vertices[16].w = 1.0f;

  metil_mesh->vertices[17].x = -0.9f;
  metil_mesh->vertices[17].y = -0.1f;
  metil_mesh->vertices[17].z = 0.2f;
  metil_mesh->vertices[17].w = 1.0f;

  metil_mesh->vertices[18].x = -0.5f;
  metil_mesh->vertices[18].y = -0.09f;
  metil_mesh->vertices[18].z = 0.0f;
  metil_mesh->vertices[18].w = 1.0f;

  metil_mesh->vertices[19].x = -0.3f;
  metil_mesh->vertices[19].y = -0.1f;
  metil_mesh->vertices[19].z = 0.0f;
  metil_mesh->vertices[19].w = 1.0f;

  metil_mesh->vertices[20].x = 0.0f;
  metil_mesh->vertices[20].y = -0.09f;
  metil_mesh->vertices[20].z = -0.1f;
  metil_mesh->vertices[20].w = 1.0f;

  metil_mesh->vertices[21].x = 0.3f;
  metil_mesh->vertices[21].y = -0.1f;
  metil_mesh->vertices[21].z = 0.0f;
  metil_mesh->vertices[21].w = 1.0f;

  metil_mesh->vertices[22].x = 0.5f;
  metil_mesh->vertices[22].y = -0.09f;
  metil_mesh->vertices[22].z = 0.0f;
  metil_mesh->vertices[22].w = 1.0f;

  metil_mesh->vertices[23].x = 0.9f;
  metil_mesh->vertices[23].y = -0.1f;
  metil_mesh->vertices[23].z = 0.2f;
  metil_mesh->vertices[23].w = 1.0f;

  metil_mesh->vertices[24].x = -0.2f;
  metil_mesh->vertices[24].y = -0.3f;
  metil_mesh->vertices[24].z = 0.0f;
  metil_mesh->vertices[24].w = 1.0f;

  metil_mesh->vertices[25].x = 0.2f;
  metil_mesh->vertices[25].y = -0.3f;
  metil_mesh->vertices[25].z = 0.0f;
  metil_mesh->vertices[25].w = 1.0f;

  metil_mesh->vertices[26].x = 0.0f;
  metil_mesh->vertices[26].y = -0.4f;
  metil_mesh->vertices[26].z = -0.2f;
  metil_mesh->vertices[26].w = 1.0f;

  metil_mesh->vertices[27].x = 0.0f;
  metil_mesh->vertices[27].y = -0.5f;
  metil_mesh->vertices[27].z = -0.05f;
  metil_mesh->vertices[27].w = 1.0f;

  metil_mesh->vertices[28].x = -0.6f;
  metil_mesh->vertices[28].y = -0.6f;
  metil_mesh->vertices[28].z = 0.2f;
  metil_mesh->vertices[28].w = 1.0f;

  metil_mesh->vertices[29].x = -0.2f;
  metil_mesh->vertices[29].y = -0.6f;
  metil_mesh->vertices[29].z = 0.1f;
  metil_mesh->vertices[29].w = 1.0f;

  metil_mesh->vertices[30].x = 0.2f;
  metil_mesh->vertices[30].y = -0.6f;
  metil_mesh->vertices[30].z = 0.1f;
  metil_mesh->vertices[30].w = 1.0f;

  metil_mesh->vertices[31].x = 0.6f;
  metil_mesh->vertices[31].y = -0.6f;
  metil_mesh->vertices[31].z = 0.2f;
  metil_mesh->vertices[31].w = 1.0f;

  metil_mesh->vertices[32].x = 0.0f;
  metil_mesh->vertices[32].y = -1.0f;
  metil_mesh->vertices[32].z = 0.3f;
  metil_mesh->vertices[32].w = 1.0f;

  for (
    unsigned char index_index = (
      0x00
    );
    (
      index_index <
      metil_mesh->length_indices
    );
    ++index_index
  ) {
    metil_mesh->indices[
      index_index
    ] = (
      0x00
    );
  }

  metil_mesh->indices[0] = 0;
  metil_mesh->indices[1] = 5;
  metil_mesh->indices[2] = 6;

  metil_mesh->indices[3] = 0;
  metil_mesh->indices[4] = 1;
  metil_mesh->indices[5] = 6;

  metil_mesh->indices[6] = 6;
  metil_mesh->indices[7] = 7;
  metil_mesh->indices[8] = 1;

  metil_mesh->indices[9] = 1;
  metil_mesh->indices[10] = 2;
  metil_mesh->indices[11] = 7;

  metil_mesh->indices[12] = 7;
  metil_mesh->indices[13] = 8;
  metil_mesh->indices[14] = 2;

  metil_mesh->indices[15] = 2;
  metil_mesh->indices[16] = 3;
  metil_mesh->indices[17] = 8;

  metil_mesh->indices[18] = 8;
  metil_mesh->indices[19] = 9;
  metil_mesh->indices[20] = 3;

  metil_mesh->indices[21] = 3;
  metil_mesh->indices[22] = 4;
  metil_mesh->indices[23] = 9;

  metil_mesh->indices[24] = 9;
  metil_mesh->indices[25] = 10;
  metil_mesh->indices[26] = 4;

  metil_mesh->indices[27] = 5;
  metil_mesh->indices[28] = 6;
  metil_mesh->indices[29] = 11;

  metil_mesh->indices[30] = 11;
  metil_mesh->indices[31] = 6;
  metil_mesh->indices[32] = 12;

  metil_mesh->indices[33] = 12;
  metil_mesh->indices[34] = 6;
  metil_mesh->indices[35] = 7;

  metil_mesh->indices[36] = 7;
  metil_mesh->indices[37] = 12;
  metil_mesh->indices[38] = 13;

  metil_mesh->indices[39] = 13;
  metil_mesh->indices[40] = 7;
  metil_mesh->indices[41] = 8;

  metil_mesh->indices[42] = 8;
  metil_mesh->indices[43] = 13;
  metil_mesh->indices[44] = 14;

  metil_mesh->indices[45] = 14;
  metil_mesh->indices[46] = 8;
  metil_mesh->indices[47] = 9;

  metil_mesh->indices[48] = 9;
  metil_mesh->indices[49] = 14;
  metil_mesh->indices[50] = 15;

  metil_mesh->indices[51] = 15;
  metil_mesh->indices[52] = 9;
  metil_mesh->indices[53] = 10;

  metil_mesh->indices[54] = 5;
  metil_mesh->indices[55] = 17;
  metil_mesh->indices[56] = 11;

  metil_mesh->indices[57] = 11;
  metil_mesh->indices[58] = 17;
  metil_mesh->indices[59] = 18;

  metil_mesh->indices[60] = 18;
  metil_mesh->indices[61] = 11;
  metil_mesh->indices[62] = 12;

  metil_mesh->indices[63] = 12;
  metil_mesh->indices[64] = 18;
  metil_mesh->indices[65] = 19;

  metil_mesh->indices[66] = 19;
  metil_mesh->indices[67] = 16;
  metil_mesh->indices[68] = 12;

  metil_mesh->indices[69] = 12;
  metil_mesh->indices[70] = 13;
  metil_mesh->indices[71] = 16;

  metil_mesh->indices[72] = 16;
  metil_mesh->indices[73] = 19;
  metil_mesh->indices[74] = 20;

  metil_mesh->indices[75] = 20;
  metil_mesh->indices[76] = 16;
  metil_mesh->indices[77] = 21;

  metil_mesh->indices[78] = 21;
  metil_mesh->indices[79] = 16;
  metil_mesh->indices[80] = 13;

  metil_mesh->indices[81] = 13;
  metil_mesh->indices[82] = 14;
  metil_mesh->indices[83] = 21;

  metil_mesh->indices[84] = 21;
  metil_mesh->indices[85] = 22;
  metil_mesh->indices[86] = 15;

  metil_mesh->indices[87] = 15;
  metil_mesh->indices[88] = 14;
  metil_mesh->indices[89] = 21;

  metil_mesh->indices[90] = 15;
  metil_mesh->indices[91] = 22;
  metil_mesh->indices[92] = 23;

  metil_mesh->indices[93] = 23;
  metil_mesh->indices[94] = 10;
  metil_mesh->indices[95] = 15;

  metil_mesh->indices[96] = 17;
  metil_mesh->indices[97] = 28;
  metil_mesh->indices[98] = 18;

  metil_mesh->indices[99] = 18;
  metil_mesh->indices[100] = 19;
  metil_mesh->indices[101] = 28;

  metil_mesh->indices[102] = 28;
  metil_mesh->indices[103] = 29;
  metil_mesh->indices[104] = 19;

  metil_mesh->indices[105] = 19;
  metil_mesh->indices[106] = 24;
  metil_mesh->indices[107] = 29;

  metil_mesh->indices[108] = 24;
  metil_mesh->indices[109] = 19;
  metil_mesh->indices[110] = 20;

  metil_mesh->indices[111] = 20;
  metil_mesh->indices[112] = 24;
  metil_mesh->indices[113] = 26;

  metil_mesh->indices[111] = 20;
  metil_mesh->indices[112] = 24;
  metil_mesh->indices[113] = 26;

  metil_mesh->indices[114] = 24;
  metil_mesh->indices[115] = 27;
  metil_mesh->indices[116] = 29;

  metil_mesh->indices[117] = 24;
  metil_mesh->indices[118] = 26;
  metil_mesh->indices[119] = 27;

  metil_mesh->indices[120] = 29;
  metil_mesh->indices[121] = 30;
  metil_mesh->indices[122] = 27;

  metil_mesh->indices[123] = 25;
  metil_mesh->indices[124] = 26;
  metil_mesh->indices[125] = 27;

  metil_mesh->indices[126] = 25;
  metil_mesh->indices[127] = 26;
  metil_mesh->indices[128] = 20;

  metil_mesh->indices[129] = 27;
  metil_mesh->indices[130] = 25;
  metil_mesh->indices[131] = 30;

  metil_mesh->indices[132] = 20;
  metil_mesh->indices[133] = 21;
  metil_mesh->indices[134] = 25;

  metil_mesh->indices[135] = 30;
  metil_mesh->indices[136] = 25;
  metil_mesh->indices[137] = 21;

  metil_mesh->indices[138] = 30;
  metil_mesh->indices[139] = 31;
  metil_mesh->indices[140] = 21;

  metil_mesh->indices[141] = 31;
  metil_mesh->indices[142] = 21;
  metil_mesh->indices[143] = 22;

  metil_mesh->indices[144] = 31;
  metil_mesh->indices[145] = 23;
  metil_mesh->indices[146] = 22;

  metil_mesh->indices[147] = 28;
  metil_mesh->indices[148] = 29;
  metil_mesh->indices[149] = 32;

  metil_mesh->indices[150] = 32;
  metil_mesh->indices[151] = 29;
  metil_mesh->indices[152] = 30;

  metil_mesh->indices[153] = 30;
  metil_mesh->indices[154] = 31;
  metil_mesh->indices[155] = 32;

  metil_object_buffers_initialize_with_data_size(
    object,
    metil->renderer_interface.metal_device,
    sizeof(
      struct example_face_renderer_data_object
    )
  );

  struct example_face_renderer_data_object* data_object = (
    object->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  data_object->vertex_hovered = (
    0x00
  );

  data_object->vertex_held = (
    0x00
  );

  object->depth_disabled = (
    0x01
  );

  struct metil_object* object_points = (
    scene->renderables[
      0x01
    ].renderable
  );

  metil_mesh_initialize(
    &object_points->mesh
  );

  object_points->mesh.length_indices = (
    object->mesh.length_indices
  );

  object_points->mesh.length_vertices = (
    object->mesh.length_vertices
  );

  object_points->depth_disabled = (
    0x01
  );

  object_points->type_primitive = (
    MTLPrimitiveTypePoint
  );

  object_points->index_pipeline_render = (
    example_face_pipeline_index_face_points
  );

  object_points->indices = (
    object->indices
  );

  for (
    unsigned char index_buffer_vertex = (
      0x00
    );
    (
      index_buffer_vertex <
      object->length_buffers_vertex
    );
    ++index_buffer_vertex
  ) {
    metil_object_buffers_add(
      object_points,
      metil->renderer_interface.metal_device,
      metil_object_buffer_type_vertex
    );

    object_points->buffers_vertex[
      index_buffer_vertex
    ].buffer = object->buffers_vertex[
      index_buffer_vertex
    ].buffer;

    object_points->buffers_vertex[
      index_buffer_vertex
    ].index = object->buffers_vertex[
      index_buffer_vertex
    ].index;

    object_points->buffers_vertex[
      index_buffer_vertex
    ].offset = object->buffers_vertex[
      index_buffer_vertex
    ].offset;
  }

  scene->poll = (
    example_face_scene_poll
  );
}

void example_face_scene_poll(
  struct metil* metil,
  struct metil_scene* scene
) {
  metil_scene_poll_default(
    metil,
    scene
  );

  struct metil_object* object = (
    scene->renderables[
      0x00
    ].renderable
  );

  struct example_face_renderer_data_object* data_object = (
    object->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  struct math_c_vector4_float* vertices = (
    object->buffers_vertex[
      metil_object_buffer_default_index_vertices
    ].buffer.contents
  );

  data_object->vertex_hovered = (
    0x00
  );

  float distance_closest = (
    0x2710
  );

  struct math_c_vector2_float position_relative = {
    .x = (
      (
        metil->input.cursor.position_window.x /
        metil->renderer_interface.size.x *
        0x02
      ) -
      0x01
    ),
    .y = (
      (
        metil->input.cursor.position_window.y /
        metil->renderer_interface.size.y *
        0x02
      ) -
      0x01    )
  };

  float aspect_ratio = (
    metil->renderer_interface.size.y /
    metil->renderer_interface.size.x
  );

  for (
    unsigned int index_vertex = (
      0x00
    );
    (
      index_vertex <
      object->mesh.length_vertices
    );
    ++index_vertex
  ) {
    struct math_c_vector4_float* vertex = &(
      vertices[
        index_vertex
      ]
    );

    float distance = (
      math_c_square_root(
        math_c_power_float(
          (
            (
              vertex->x *
              aspect_ratio * (
                0x01 -
                vertex->z
              )
            ) - position_relative.x
          ),
          0x02
        ) +
        math_c_power_float(
          (
            vertex->y *
            0.8f -
            position_relative.y
          ),
          0x02
        )
      )
    );

    if (
      (
        distance <
        distance_closest
      ) &&
      (
        distance <
        0.1f
      )
    ) {
      data_object->vertex_hovered = (
        index_vertex +
        0x01
      );

      distance_closest = distance;
    }
  }

  if (
    (
      metil->input.cursor.down ==
      0x01
    ) &&
    (
      data_object->vertex_hovered !=
      0x00
    ) &&
    (
      data_object->vertex_held ==
      0x00
    )
  ) {
    data_object->vertex_held = (
      data_object->vertex_hovered
    );
  } else if (
    metil->input.cursor.down !=
    0x01
  ) {
    data_object->vertex_held = (
      0x00
    );
  }

  if (
    data_object->vertex_held !=
    0x00
  ) {
    struct math_c_vector4_float* vertex = &(
      vertices[
        data_object->vertex_held -
        0x01
      ]
    );

    vertex->x = (
      position_relative.x /
      aspect_ratio
    );

    vertex->y = (
      position_relative.y /
      0.8f
    );
  }
}

void example_face_scene_destroy(
  struct metil* metil,
  struct metil_scene* scene
) {
  struct metil_object* object_points = (
    scene->renderables[
      0x01
    ].renderable
  );

  object_points->length_buffers_vertex = (
    0x00
  );

  object_points->indices = (
    0x00
  );

  metil_scene_destroy_default(
    metil,
    scene
  );
}
