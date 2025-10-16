#include <metil_object.h>

#include <metil_mesh/mesh.h>
#include <metil_rendering/metil_renderer_data_object.h>

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
  metil_object->texture = (void*)0;
  metil_object->texture_secondary = (void*)0;

  metil_object->position.x = 0.0f;
  metil_object->position.y = 0.0f;
  metil_object->position.z = 0.0f;

  metil_object->rotation.x = 0.0f;
  metil_object->rotation.y = 0.0f;
  metil_object->rotation.z = 0.0f;

  metil_object->index_pipeline_render = 0;

  metil_object->depth_disabled = 0;

  metil_object->type_primitive = MTLPrimitiveTypeTriangle;
  metil_object->type_index = MTLIndexTypeUInt32;
}

void metil_object_buffers_initialize(
  struct metil_object* metil_object,
  id<MTLDevice> metal_device
) {
  metil_object->data = [metal_device
    newBufferWithLength: sizeof(struct metil_renderer_data_object)
    options: MTLResourceStorageModeShared
  ];

  metil_object->indices = [metal_device
    newBufferWithBytes: metil_object->mesh.indices
    length: metil_object->mesh.length_indices * sizeof(unsigned int)
    options: MTLResourceStorageModeShared
  ];

  metil_object->vertices = [metal_device
    newBufferWithBytes: metil_object->mesh.vertices
    length: metil_object->mesh.length_vertices * sizeof(struct clic3_vector4_float)
    options: MTLResourceStorageModeShared
  ];
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

  metil_mesh_destroy(
    &object->mesh
  );
}
