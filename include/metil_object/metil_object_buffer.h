#ifndef __metil_object_metil_object_buffer_h
#define __metil_object_metil_object_buffer_h

#include <Metal/MTLDevice.h>

enum metil_object_buffer_default_index {
  metil_object_buffer_default_index_data = 1,
  metil_object_buffer_default_index_joints = 3,
  metil_object_buffer_default_index_vertex_joint_map = 2,
  metil_object_buffer_default_index_vertices = 0
};

enum metil_object_buffer_type {
  metil_object_buffer_type_fragment = 0,
  metil_object_buffer_type_vertex = 1
};

struct metil_object_buffer {
  _Nonnull id<MTLBuffer> buffer;
  unsigned int offset;
  unsigned int index;
};

#endif
