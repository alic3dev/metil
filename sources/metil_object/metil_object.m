#include <metil_object.h>

#include <metil_mesh/metil_mesh.h>
#include <metil_positioning.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer.h>
#include <metil_scenes/metil_scene_controller.h>

#include <clic3_memory.h>

#include <math_c_vector.h>

#include <Metal/MTLArgument.h>
#include <Metal/MTLDevice.h>
#include <Metal/MTLRenderCommandEncoder.h>
#include <Metal/MTLResource.h>

void metil_object_initialize(
  struct metil_object* metil_object
) {
  metil_object->length_buffers_fragment = 0;
  metil_object->length_buffers_vertex = 0;

  metil_object->buffers_fragment = (
    clic3_memory_allocate_raw(
      0
    )
  );

  metil_object->buffers_vertex = (
    clic3_memory_allocate_raw(
      0
    )
  );

  metil_object->indices = 0;

  metil_object->type_primitive = MTLPrimitiveTypeTriangle;
  metil_object->type_index = MTLIndexTypeUInt32;

  metil_object->length_textures = 0;

  metil_object->textures = (
    clic3_memory_allocate_raw(
      0
    )
  );

  metil_object->position.x = 0.0f;
  metil_object->position.y = 0.0f;
  metil_object->position.z = 0.0f;

  metil_object->rotation.x = 0.0f;
  metil_object->rotation.y = 0.0f;
  metil_object->rotation.z = 0.0f;

  metil_object->depth_disabled = 0;
  metil_object->index_pipeline_render = 0;
  metil_object->visible = 1;

  metil_object->positioning = metil_positioning_normal;

  metil_object->poll = metil_object_poll;
  metil_object->destroy = metil_object_destroy;

  metil_object->data = 0;
}

void metil_object_indices_initialize(
  struct metil_object* metil_object,
  id<MTLDevice> metal_device
) {
  metil_object->indices = [metal_device
    newBufferWithBytes: metil_object->mesh.indices
    length: (
      metil_object->mesh.length_indices *
      sizeof(
        unsigned int
      )
    )
    options: MTLResourceStorageModeShared
  ];
}

void metil_object_buffers_initialize_vertices(
  struct metil_object* metil_object,
  id<MTLDevice> metal_device
) {
  metil_object_buffers_add(
    metil_object,
    metal_device,
    metil_object_buffer_type_vertex
  );

  metil_object->buffers_vertex[
    metil_object->length_buffers_vertex -
    1
  ].buffer = [
    metal_device
    newBufferWithBytes: metil_object->mesh.vertices
    length: (
      sizeof(
        struct math_c_vector4_float
      ) *
      metil_object->mesh.length_vertices
    )
    options: MTLResourceStorageModeShared
  ];
}

void metil_object_buffers_initialize_with_data_size(
  struct metil_object* metil_object,
  id<MTLDevice> metal_device,
  unsigned long int size_data
) {
  metil_object_indices_initialize(
    metil_object,
    metal_device
  );

  metil_object_buffers_initialize_vertices(
    metil_object,
    metal_device
  );

  metil_object_buffers_add(
    metil_object,
    metal_device,
    metil_object_buffer_type_vertex
  );

  metil_object->buffers_vertex[
    metil_object->length_buffers_vertex -
    1
  ].buffer = [
    metal_device
    newBufferWithLength: size_data
    options: MTLResourceStorageModeShared
  ];
}

void metil_object_buffers_initialize(
  struct metil_object* metil_object,
  id<MTLDevice> metal_device
) {
  metil_object_buffers_initialize_with_data_size(
    metil_object,
    metal_device,
    sizeof(
      struct metil_renderer_data_object
    )
  );

  struct metil_renderer_data_object* metil_renderer_data_object = (
    metil_object->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  metil_renderer_data_object_initialize(
    metil_renderer_data_object
  );
}

void metil_object_buffers_add(
  struct metil_object* metil_object,
  id<MTLDevice> metal_device,
  enum metil_object_buffer_type metil_object_buffer_type
) {
  struct metil_object_buffer** buffers = 0;
  unsigned char* length_buffers = 0;

  switch (
    metil_object_buffer_type
  ) {
    case metil_object_buffer_type_fragment: {
      buffers = &(
        metil_object->buffers_fragment
      );

      length_buffers = &(
        metil_object->length_buffers_fragment
      );

      break;
    }
    case metil_object_buffer_type_vertex:
    default: {
      buffers = &(
        metil_object->buffers_vertex
      );

      length_buffers = &(
        metil_object->length_buffers_vertex
      );

      break;
    }
  }

  unsigned char index_buffer = (
    *length_buffers
  );

  *length_buffers = (
    *length_buffers +
    1
  );

  clic3_memory_reallocate_raw(
    buffers,
    (
      sizeof(
        struct metil_object_buffer
      ) *
      *length_buffers
    )
  );

  (*buffers)[
    index_buffer
  ].buffer = 0;

  (*buffers)[
    index_buffer
  ].index = (
    index_buffer +
    1
  );

  (*buffers)[
    index_buffer
  ].offset = (
    0
  );
}

void metil_object_texture_add(
  struct metil_object* metil_object,
  id<MTLTexture> texture
) {
  metil_object->length_textures = (
    metil_object->length_textures + 1
  );

  clic3_memory_reallocate_raw(
    &metil_object->textures,
    (
      sizeof(
        id<MTLTexture>
      ) *
      metil_object->length_textures
    )
  );

  metil_object->textures[
    metil_object->length_textures - 1
  ] = texture;
}

void metil_object_poll(
  struct metil* metil,
  struct metil_object* metil_object,
  matrix_float3x4* matrix_projection_static,
  matrix_float4x4* matrix_object_projection,
  matrix_float4x4* matrix_player_projection,
  struct metil_camera* metil_camera
) {
  struct metil_renderer_data_object* data = (
    metil_object->buffers_vertex[
      metil_object_buffer_default_index_data
    ].buffer.contents
  );

  data->position.x = metil_object->position.x;
  data->position.y = metil_object->position.y;
  data->position.z = metil_object->position.z;

  metil_positioning_view_model_matrix_projection_set(
    metil_object->positioning,
    &data->view_model_matrix_projection,
    matrix_projection_static,
    matrix_object_projection,
    matrix_player_projection,
    &metil_object->position,
    &metil_object->rotation,
    &((struct metil_scene_controller*) metil->scene_controller)->scene.player.position,
    metil_camera
  );

  data->size.x = metil_object->mesh.size.x;
  data->size.y = metil_object->mesh.size.y;
  data->size.z = metil_object->mesh.size.z;
}

void metil_object_destroy(
  struct metil* metil,
  struct metil_object* object
) {
  if (
    object->indices != 0
  ) {
    [object->indices release];
  }

  for (
    unsigned char index_buffer_fragment = 0;
    index_buffer_fragment < object->length_buffers_fragment;
    ++index_buffer_fragment
  ) {
    [
      object->buffers_fragment[
        index_buffer_fragment
      ].buffer
      release
    ];
  }

  for (
    unsigned char index_buffer_vertex = 0;
    index_buffer_vertex < object->length_buffers_vertex;
    ++index_buffer_vertex
  ) {
    [
      object->buffers_vertex[
        index_buffer_vertex
      ].buffer
      release
    ];
  }

  clic3_memory_free(
    object->buffers_fragment
  );

  clic3_memory_free(
    object->buffers_vertex
  );

  clic3_memory_free(
    object->textures
  );

  clic3_memory_free(
    object->data
  );

  metil_mesh_destroy(
    &object->mesh
  );
}

void metil_object_destroy_with_textures(
  struct metil* metil,
  struct metil_object* metil_object
) {
  for (
    unsigned char index_texture = 0;
    index_texture < metil_object->length_textures;
    ++index_texture
  ) {
    [
      metil_object->textures[
        index_texture
      ]
      release
    ];
  }

  metil_object_destroy(
    metil,
    metil_object
  );
}
