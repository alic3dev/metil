#ifndef __metil_example_shader_types_h
#define __metil_example_shader_types_h

#include <simd/simd.h>

#ifndef __METAL_VERSION__
#define constant
#endif

static constant const unsigned int length_objects_x = 7;
static constant const unsigned int length_objects_y = 7;
static constant const unsigned int length_objects_z = 7;

static constant const unsigned int length_objects_xyz = (
  length_objects_x * length_objects_y * length_objects_z
);

typedef enum {
  metal_kit_vertex_input_index_positions = 0,
  metal_kit_vertex_input_index_frame_data = 1,
  metal_kit_vertex_input_index_mesh_index = 2
} metal_kit_vertex_3d_input_index;

typedef enum metal_kit_vertex_input_index {
    metal_kit_vertex_input_index_vertices = 0,
    metal_kit_vertex_input_index_viewport_size = 1
} metal_kit_vertex_2d_input_index;

typedef struct {
    vector_float2 position;
    vector_float4 color;
} metal_kit_vertex_2d;

typedef struct {
  matrix_float4x4 view_model_matrix;
  matrix_float4x4 view_model_matrix_projection;
  vector_float3 color;
} metal_kit_data_frame_object;

typedef struct {
  metal_kit_data_frame_object objects[length_objects_xyz];
} metal_kit_data_frame;

#endif
