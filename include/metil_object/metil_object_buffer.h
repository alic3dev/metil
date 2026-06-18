#ifndef __metil_metil_object_metil_object_buffer_h
#define __metil_metil_object_metil_object_buffer_h

#include <Metal/MTLDevice.h>

enum metil_object_buffer_default_index {
  metil_object_buffer_default_index_data             = 0x01,
  metil_object_buffer_default_index_joints           = 0x03,
  metil_object_buffer_default_index_vertex_joint_map = 0x02,
  metil_object_buffer_default_index_vertices         = 0x00
};

enum metil_object_buffer_type {
  metil_object_buffer_type_fragment = 0x00,
  metil_object_buffer_type_vertex   = 0x01
};

struct metil_object_buffer {
  _Nonnull id<MTLBuffer> buffer;
  unsigned int offset;
  unsigned int index;
};

#endif
