#include <metil_metal/metil_metal_model_object.h>

#include <metil_metal/metil_metal_joint.h>

#include <math_c_vector.h>

#include <simd/simd.h>

void metil_model_object_vertex_transform(
  thread float4* position_vertex_to_transform,
  const device float4* position_vertex,
  thread float4* position_object,
  thread float4* position_joint,
  thread float4* position_joint_translation,
  thread matrix_float4x4* matrix_projection_rotation_joint
) {
  float4 position_vertex_object_relation = (
    *position_vertex +
    *position_object
  );

  float4 position_vertex_object_relation_offset_joint_origin = (
    position_vertex_object_relation - 
    *position_joint
  );

  float4 position_vertex_object_relation_offset_joint_origin_rotated = (
    position_vertex_object_relation_offset_joint_origin *
    *matrix_projection_rotation_joint
  );
  
  *position_vertex_to_transform = (
    position_vertex_object_relation_offset_joint_origin_rotated +
    *position_joint +
    *position_joint_translation -
    *position_object
  );
}

float4 metil_model_object_position_calcluate(
  unsigned int id_vertex,
  const device float4* position_vertex,
  constant struct math_c_vector3_float* position_object,
  constant unsigned int* vertex_joint_map,
  constant struct math_c_vector3_float* joints
) {
  float4 position_joint;
  math_c_vector3_float rotation_joint;
  float4 position_joint_translation;

  matrix_float4x4 matrix_projection_rotation_joint;
  
  float4 position_vertex_transformed;

  float4 position_object_simd = {
    position_object->x,
    position_object->y,
    position_object->z,
    0.0f
  };
  
  unsigned int id_joint = (
    metil_metal_joint_id_get(
      id_vertex,
      vertex_joint_map
    )
  );

  metil_metal_joint_values_set(
    id_joint,
    joints,
    &position_joint,
    &rotation_joint,
    &position_joint_translation
  );

  metil_metal_joint_matrix_projection_rotation_set(
    &matrix_projection_rotation_joint,
    &rotation_joint
  );

  metil_model_object_vertex_transform(
    &position_vertex_transformed,
    position_vertex,
    &position_object_simd,
    &position_joint,
    &position_joint_translation,
    &matrix_projection_rotation_joint
  );

  return (
    position_vertex_transformed
  );
}
