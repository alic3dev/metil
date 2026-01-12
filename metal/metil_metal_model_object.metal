#include <metil_metal/metil_metal_model_object.h>

#include <metil_joint/metil_joint_id_offset.h>

#include <math_c_vector.h>

#include <simd/simd.h>

float4 metil_model_object_position_calcluate(
  unsigned int id_vertex,
  const device float4* position_vertex,
  constant struct math_c_vector3_float* position,
  constant unsigned int* vertex_joint_map,
  constant struct math_c_vector3_float* joints
) {
  unsigned int id_joint = (
    vertex_joint_map[
      id_vertex
    ] *
    metil_joint_id_offset_length
  );

  unsigned int id_joint_position = (
    id_joint +
    metil_joint_id_offset_position
  );

  unsigned int id_joint_rotation = (
    id_joint +
    metil_joint_id_offset_rotation
  );

  unsigned int id_joint_translation = (
    id_joint +
    metil_joint_id_offset_translation
  );

  matrix_float4x4 matrix_projection_object_with_rotation = (
    (matrix_float4x4) {{
      { metal::cos(joints[id_joint_rotation].y), 0.0f, -metal::sin(joints[id_joint_rotation].y), 0.0f },
      { 0.0f, 1.0f, 0.0f, 0.0f },
      { metal::sin(joints[id_joint_rotation].y), 0.0f, metal::cos(joints[id_joint_rotation].y), 0.0f },
      { 0.0f, 0.0f, 0.0f, 1.0f }
    }} *
    (matrix_float4x4) {{
      { 1.0f, 0.0f, 0.0f, 0.0f },
      { 0.0f, metal::cos(joints[id_joint_rotation].x), -metal::sin(joints[id_joint_rotation].x), 0.0f },
      { 0.0f, metal::sin(joints[id_joint_rotation].x), metal::cos(joints[id_joint_rotation].x), 0.0f },
      { 0.0f, 0.0f, 0.0f, 1.0f }
    }} *
    (matrix_float4x4) {{
      { metal::cos(joints[id_joint_rotation].z), -metal::sin(joints[id_joint_rotation].z), 0.0f, 0.0f },
      { metal::sin(joints[id_joint_rotation].z), metal::cos(joints[id_joint_rotation].z), 0.0f, 0.0f },
      { 0.0f, 0.0f, 1.0f, 0.0f },
      { 0.0f, 0.0f, 0.0f, 1.0f }
    }}
  );

  float4 position_object = {
    position->x,
    position->y,
    position->z,
    0.0f
  };

  float4 position_vertex_object_relation = (
    *position_vertex +
    position_object
  );

  float4 position_joint = {
    joints[id_joint_position].x,
    joints[id_joint_position].y,
    joints[id_joint_position].z,
    0.0f
  };

  float4 position_joint_translation = {
    joints[id_joint_translation].x,
    joints[id_joint_translation].y,
    joints[id_joint_translation].z,
    0.0f
  };

  float4 position_vertex_object_relation_offset_joint_origin = (
    position_vertex_object_relation - 
    position_joint
  );

  float4 position_vertex_object_relation_offset_joint_origin_rotated = (
    position_vertex_object_relation_offset_joint_origin *
    matrix_projection_object_with_rotation
  );
  
  float4 position_vertex_transformed = (
    position_vertex_object_relation_offset_joint_origin_rotated +
    position_joint +
    position_joint_translation -
    position_object
  );

  return (
    position_vertex_transformed
  );
}
