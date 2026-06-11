#include <example_meshes_scene.h>

#include <metil.h>

/* 2d meshes */
#include <metil_mesh/metil_mesh_2d/metil_mesh_circle.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_rectangle.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_square.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_triangle.h>

/* 3d meshes */
#include <metil_mesh/metil_mesh_ball.h>
#include <metil_mesh/metil_mesh_box.h>
#include <metil_mesh/metil_mesh_dollop.h>
#include <metil_mesh/metil_mesh_gem.h>
#include <metil_mesh/metil_mesh_mushroom.h>
#include <metil_mesh/metil_mesh_ring.h>
#include <metil_mesh/metil_mesh_shuttle.h>
#include <metil_mesh/metil_mesh_sphere.h>
#include <metil_mesh/metil_mesh_tube.h>

#include <metil_object.h>
#include <metil_player/metil_player.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderable_type.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/metil_scene.h>

#include <clic3_memory.h>

#include <math_c_pi.h>
#include <math_c_sine.h>
#include <math_c_vector.h>
#include <math_c_vector_distance.h>

void example_meshes_scene_initialize(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  metil_scene_initialize_with_renderables_textures(
    metil,
    metil_scene,
    14,
    0x01
  );
  
  MTLTextureDescriptor* descriptor_texture_lighting = [
    [
      MTLTextureDescriptor
      alloc
    ]
    init
  ];
  
  descriptor_texture_lighting.textureType = (
    MTLTextureType3D  
  );
  
  descriptor_texture_lighting.pixelFormat = (
    MTLPixelFormatRGBA8Unorm
  );
  
  descriptor_texture_lighting.width = (
    0x64
  );
  
  descriptor_texture_lighting.height = (
    0x64
  );
  
  descriptor_texture_lighting.depth = (
    0x64
  );
  
  descriptor_texture_lighting.mipmapLevelCount = (
    0x01
  );
  
  descriptor_texture_lighting.sampleCount = (
    0x01
  );
  
  descriptor_texture_lighting.arrayLength = (
    0x01
  );
      descriptor_texture_lighting.storageMode = (
    MTLStorageModeShared
  );
  
  descriptor_texture_lighting.compressionType = (
    MTLTextureCompressionTypeLossless
  );
  
  descriptor_texture_lighting.usage = (
    MTLTextureUsageShaderRead
  );
  
  id<MTLTexture> texture_lighting = [
    metil->renderer_interface.metal_device
    newTextureWithDescriptor: (
      descriptor_texture_lighting
    )
  ];
  
  [
    texture_lighting
    retain
  ];
  
  unsigned long int bytesPerRow = (
    texture_lighting.width *
    //texture_lighting.depth *
    0x04  ); 
  
  unsigned int length_bytes = (
    texture_lighting.width *
    texture_lighting.height *
    texture_lighting.depth *
    0x04
  );  
  
  unsigned char* bytes_texture_lighting = (
    clic3_memory_allocate_raw(
      length_bytes
    )
  );
  
  struct math_c_vector3_float center = {
    .x = 0x00,
    .y = 0x00,
    .z = 0x00
  };
float max;  
    for (
      unsigned int index_byte = (
        0x00
      );
      (
        index_byte <
        length_bytes
      );
      index_byte = (
        index_byte +
        0x04
      )
    ) {
      unsigned int index_pixel = (
        index_byte /
        0x04
      );
  
      struct math_c_vector3_float position = {
        .x = (
          (float)
          (
            index_pixel %
            (
              0x64
            )
          ) /
          0x64 *
          0x02 -
          0x01
        ),
        .y = (
          (float)
          (
            (
              index_pixel %
              (
                0x64 *
                0x64
              )
            ) /
            0x64
          ) /
          0x64 *
          0x02 -
          0x01
        ),
        .z = (
          (float)
          (
            (
              index_pixel /
              0x64
            ) /
            0x64
          ) /
          0x64 *
          0x02 -
          0x01
        )
      };
      
      float distance = (
        0x01 -
        (
          math_c_vector3_distance_float(
            &position,
            &center
          ) /
          1.74f
        )
      );   
  
      bytes_texture_lighting[
        index_byte
      ] = (
        0xff
      );
    
      bytes_texture_lighting[
        index_byte +
        0x01
      ] = (
        distance *
        0xff
      );
      
      bytes_texture_lighting[
        index_byte +
        0x02
      ] = (
        0xff
      );
    
      bytes_texture_lighting[
        index_byte +
        0x03
      ] = (
        0xff
      );
    }
  
  for (
    unsigned int index_z = (
      0x00
    );
    (
      index_z <
      texture_lighting.depth
    );
    ++index_z
  ) {
    MTLRegion region_texture_lighting = {
      .origin = {
        .x = 0x00,
        .y = 0x00,
        .z = index_z
      },
      .size = {
        .height = texture_lighting.height,
        .width = texture_lighting.width,
        .depth = 0x01
      }
    };
  
    [
      texture_lighting
      replaceRegion: region_texture_lighting
      mipmapLevel: 0x00
      withBytes: (bytes_texture_lighting + index_z * 0x64 * 0x64 * 0x04)
      bytesPerRow: bytesPerRow
    ];
  }
  
  clic3_memory_free_raw(
    bytes_texture_lighting
  );
  
  metil_scene->textures[
    0x00
  ] = (
    texture_lighting
  );
  
  [
    descriptor_texture_lighting
    release
  ];

  metil_scene->poll = (
    example_meshes_scene_poll
  );

  float width = (
    0x20
  );
  for (
    unsigned int index_renderable = (
      0x00
    );
    (
      index_renderable <
      (
        metil_scene->length_renderables -
        0x01
      )
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

    switch (
      index_renderable %
      13
    ) {
      case 0: {
        metil_mesh_circle_initialize(
          metil_mesh,
          10.0f,
          100
        );

        break;
      }
      case 1: {
        metil_mesh_rectangle_initialize(
          metil_mesh,
          (struct math_c_vector2_float) {
            .x = 10.0f,
            .y = 5.0f
          }
        );

        break;
      }
      case 2: {
        metil_mesh_square_initialize(
          metil_mesh,
          10.0f
        );

        break;
      }
      case 3: {
        metil_mesh_triangle_initialize(
          metil_mesh,
          (struct math_c_vector2_float) {
            .x = 10.0f,
            .y = 10.0f
          }
        );

        break;
      }
      case 4: {
        metil_mesh_ball_initialize(
          metil_mesh,
          10,
          (struct math_c_vector2_unsigned_short_int) {
            .x = 100,
            .y = 100
          }
        );

        break;
      }
      case 5: {
        metil_mesh_box_initialize(
          metil_mesh,
          (struct math_c_vector3_float) {
            .x = 10.0f,
            .y = 10.0f,
            .z = 10.0f
          }
        );

        break;
      }
      case 6: {
        metil_mesh_dollop_initialize(
          metil_mesh,
          (struct math_c_vector3_float) {
            .x = 10.0f,
            .y = 10.0f,
            .z = 10.0f
          },
          (struct math_c_vector2_unsigned_short_int) {
            .x = 100,
            .y = 100
          }
        );

        break;
      }
      case 7: {
        metil_mesh_gem_initialize(
          metil_mesh,
          (struct math_c_vector3_float) {
            .x = 10.0f,
            .y = 10.0f,
            .z = 10.0f
          },
          (struct math_c_vector2_unsigned_short_int) {
            .x = 100,
            .y = 100
          }
        );

        break;
      }
      case 8: {
        metil_mesh_mushroom_initialize(
          metil_mesh,
          (struct math_c_vector3_float) {
            .x = 10.0f,
            .y = 10.0f,
            .z = 10.0f
          },
          (struct math_c_vector2_unsigned_short_int) {
            .x = 110,
            .y = 110
          }
        );

        break;
      }
      case 9: {
        metil_mesh_ring_initialize(
          metil_mesh,
          (struct math_c_vector3_float) {
            .x = 10.0f,
            .y = 1.0f,
            .z = 10.0f
          },
          (struct math_c_vector3_float) {
            .x = 8.0f,
            .y = 1.0f,
            .z = 8.0f
          },
          (struct math_c_vector2_unsigned_short_int) {
            .x = 100,
            .y = 100
          }
        );

        break;
      }
      case 10: {
        metil_mesh_shuttle_initialize(
          metil_mesh,
          (struct math_c_vector3_float) {
            .x = 10.0f,
            .y = 10.0f,
            .z = 10.0f
          },
          (struct math_c_vector2_unsigned_short_int) {
            .x = 7,
            .y = 7
          }
        );

        break;
      }
      case 11: {
        metil_mesh_sphere_initialize(
          metil_mesh,
          10,
          (struct math_c_vector2_unsigned_short_int) {
            .x = 100,
            .y = 100
          }
        );

        break;
      }
      case 12: {
        metil_mesh_tube_initialize(
          metil_mesh,
          (struct math_c_vector3_float) {
            .x = 10.0f,
            .y = 10.0f,
            .z = 10.0f
          },
          (struct math_c_vector2_unsigned_short_int) {
            .x = 100,
            .y = 100
          },
          metil_direction_up
        );

        break;
      }
    }

    metil_object_buffers_initialize(
      metil_object,
      metil->renderer_interface.metal_device
    );

    float percentage = (
      (float)
      index_renderable /
      (float)
      (
        metil_scene->length_renderables -
        0x02
      )
    );

    metil_object->position.x = (
      math_c_sine(
        (
          percentage *
          math_c_pi_doubled
        ),
        math_c_pi
      ) *
      width
    );
    
    metil_object->position.y = 10.0f;
    
    metil_object->position.z = (
      math_c_cosine(
        (
          percentage *
          math_c_pi_doubled
        ),
        math_c_pi
      ) *
      width
    );

    metil_object->rotation.x = (
      index_renderable *
      math_c_pi
    );

    metil_object->rotation.y = (
      index_renderable *
      math_c_pi_half
    );
    
    metil_object_texture_add(
      metil_object,
      texture_lighting
    );

    struct metil_renderer_data_object* data_object = (
      metil_object->buffers_vertex[
        metil_object_buffer_default_index_data
      ].buffer.contents
    );
    
    }  
  metil_renderable_initialize_at_index(
    metil_scene->renderables,
    (
      metil_scene->length_renderables -
      0x01
    ),
    metil_renderable_type_object
  );
  
  struct metil_object* metil_object_room = (
    metil_scene->renderables[
      metil_scene->length_renderables -
      0x01
    ].renderable
  );
  
  metil_mesh_box_initialize(
    &metil_object_room->mesh,
    (struct math_c_vector3_float) {
      .x = (
        width *
        0x03
      ),
      .y = (
        width *
        0x01
      ),
      .z = (
        width *
        0x03
      )
    }
  );

  metil_object_buffers_initialize(
    metil_object_room,
    metil->renderer_interface.metal_device
  );
  
  metil_object_room->position.y = (
    metil_object_room->mesh.size.y /
    0x02
  );
  
  metil_object_texture_add(
    metil_object_room,
    texture_lighting
  );
  
  struct metil_renderer_data_object* data_object = (
    metil_object_room->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );
  
  data_object->colour.y = (
    0.9f
  );
  
  data_object->colour.z = (
    0.8f
  );}

void example_meshes_scene_poll(
  struct metil* metil,
  struct metil_scene* metil_scene
) {
  metil_scene_poll_default(
    metil,
    metil_scene
  );

  for (
    unsigned int index_renderable = (
      0x00
    );
    (
      index_renderable <
      (
        metil_scene->length_renderables -
        0x01
      )
    );
    ++index_renderable
  ) {
    struct metil_object* metil_object = (
      metil_scene->renderables[
        index_renderable
      ].renderable
    );
    
    metil_object->position.x = (
      math_c_sine(
        ((float) metil_scene->time_elapsed / 0xbe8 + (float) ((index_renderable * 0x02) % metil_scene->length_renderables) /
        0x10) / 0x02 * math_c_pi_doubled
        ,math_c_pi) * 0x20
    );
    
    metil_object->position.y = (
      math_c_sine(
        ((float) metil_scene->time_elapsed / 0x0ce8 + (float) index_renderable /
        0x10 + 0x829 + index_renderable * 0x34) / 0x02 * math_c_pi_doubled
        ,math_c_pi) * 0x05 +
        0x10
    );
    
    metil_object->position.z = (
      math_c_sine(
        ((float) metil_scene->time_elapsed / 0x09e8 + (float) index_renderable /
        0x10 + 0x398) / 0x02 * math_c_pi_doubled
        ,math_c_pi) * 0x20
    );

    /*metil_object->rotation.x = (
      metil_object->rotation.x +
      0.01
    );

    metil_object->rotation.y = (
      metil_object->rotation.y +
      0.01
    );*/
  }
}
