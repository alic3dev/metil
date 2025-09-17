#ifndef __metil_example_shader_types_h
#define __metil_example_shader_types_h

#include <clic3_vector.h>

#include <simd/simd.h>

#ifndef __METAL_VERSION__
#define constant
#endif

typedef enum {
  metil_kit_vertex_input_index_positions = 2,
  metil_kit_vertex_input_index_frame_data = 1,
  metil_kit_vertex_input_index_data = 0
} metil_kit_vertex_input_index;

typedef struct {
  matrix_float4x4 view_model_matrix_projection;
  struct clic3_vector3_float position;
  float width;
  float height;
  float depth;
  unsigned int noise;
  unsigned int id;
  int mode_texture;
} metil_kit_data_frame_object;

typedef struct {
  unsigned int frame;
  struct clic3_vector3_float rotation_camera;
  struct clic3_vector3_float position_player;
  float brightness;
  float brightness_text;
} metil_kit_data_frame;

#endif
