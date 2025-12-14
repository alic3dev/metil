#include <metil_object.h>

#include <metil_mesh/mesh.h>
#include <metil_positioning.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer.h>

#include <clic3_vector.h>

#include <Metal/MTLArgument.h>
#include <Metal/MTLDevice.h>
#include <Metal/MTLRenderCommandEncoder.h>
#include <Metal/MTLResource.h>

void metil_object_initialize(
  struct metil_object* metil_object
) {
  metil_object->data = (void*)0;
  metil_object->indices = (void*)0;
  metil_object->vertices = (void*)0;

  metil_object->type_primitive = MTLPrimitiveTypeTriangle;
  metil_object->type_index = MTLIndexTypeUInt32;

  metil_object->length_textures = 0;
  metil_object->textures = malloc(
    sizeof(id<MTLTexture>) *
    metil_object->length_textures
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
}

void metil_object_buffers_initialize_with_data_size(
  struct metil_object* metil_object,
  id<MTLDevice> metal_device,
  unsigned long int size_data
) {
  metil_object->data = [metal_device
    newBufferWithLength: size_data
    options: MTLResourceStorageModeShared
  ];

  metil_object->indices = [metal_device
    newBufferWithBytes: metil_object->mesh.indices
    length: (
      metil_object->mesh.length_indices *
      sizeof(unsigned int)
    )
    options: MTLResourceStorageModeShared
  ];

  metil_object->vertices = [metal_device
    newBufferWithBytes: metil_object->mesh.vertices
    length: (
      metil_object->mesh.length_vertices *
      sizeof(struct clic3_vector4_float)
    )
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
    sizeof(struct metil_renderer_data_object)
  );
}

void metil_object_texture_add(
  struct metil_object* metil_object,
  id<MTLTexture> texture
) {
  metil_object->length_textures = (
    metil_object->length_textures + 1
  );

  metil_object->textures = realloc(
    metil_object->textures,
    sizeof(id<MTLTexture>) *
    metil_object->length_textures
  );

  metil_object->textures[
    metil_object->length_textures - 1
  ] = texture;
}

void metil_object_poll(
  struct metil_object* metil_object,
  matrix_float3x4* matrix_projection_static,
  matrix_float4x4* matrix_object_projection,
  matrix_float4x4* matrix_player_projection,
  struct metil_camera* metil_camera
) {
  struct metil_renderer_data_object* data = (
    metil_object->data.contents
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
    metil_camera
  );

  data->size.x = metil_object->mesh.size.x;
  data->size.y = metil_object->mesh.size.y;
  data->size.z = metil_object->mesh.size.z;
}

void metil_object_destroy(
  struct metil_object* object
) {
  if (
    object->data != (void*)0
  ) {
    [object->data release];
  }

  if (
    object->indices != (void*)0
  ) {
    [object->indices release];
  }

  if (
    object->vertices != (void*)0
  ) {
    [object->vertices release];
  }

  free(
    object->textures
  );

  metil_mesh_destroy(
    &object->mesh
  );
}

void metil_object_destroy_with_textures(
  struct metil_object* metil_object
) {
  for (
    unsigned char index_texture = 0;
    index_texture < metil_object->length_textures;
    ++index_texture
  ) {
    [metil_object->textures[
      index_texture
    ] release];
  }

  metil_object_destroy(
    metil_object
  );
}
