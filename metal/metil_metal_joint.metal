#include <metil_metal/metil_metal_joint.h>

#include <metil_joint/metil_joint_id_offset.h>

#include <math_c_vector.h>

#include <simd/simd.h>

unsigned int metil_metal_joint_id_get(
  unsigned int id_vertex,
  constant unsigned int* vertex_joint_map
) {
  unsigned int id_joint = (
    vertex_joint_map[
      id_vertex
    ] *
    metil_joint_id_offset_length
  );

  return (
    id_joint
  );
}

void metil_metal_joint_values_set(
  unsigned int id_joint,
  constant struct math_c_vector3_float* joints,
  thread float4* position_joint,
  thread math_c_vector3_float* rotation_joint,
  thread float4* position_joint_translation
) {
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

  position_joint->x = (
    joints[
      id_joint_position
    ].x
  );

  position_joint->y = (
    joints[
      id_joint_position
    ].y
  );

  position_joint->z = (
    joints[
      id_joint_position
    ].z
  );

  position_joint->w = (
    0.0f
  );

  rotation_joint->x = (
    joints[
      id_joint_rotation
    ].x
  );

  rotation_joint->y = (
    joints[
      id_joint_rotation
    ].y
  );

  rotation_joint->z = (
    joints[
      id_joint_rotation
    ].z
  );

  position_joint_translation->x = (
    joints[
      id_joint_translation
    ].x
  );

  position_joint_translation->y = (
    joints[
      id_joint_translation
    ].y
  );

  position_joint_translation->z = (
    joints[
      id_joint_translation
    ].z
  );

  position_joint_translation->w = (
    0.0f
  );
}

void metil_metal_joint_matrix_projection_rotation_set(
  thread matrix_float4x4* matrix_projection_rotation_joint,
  thread struct math_c_vector3_float* rotation_joint
) {
  math_c_vector3_float rotation_joint_sines = {
    .x = (
      metal::sin(
        rotation_joint->x
      )
    ),
    .y = (
      metal::sin(
        rotation_joint->y
      )
    ),
    .z = (
      metal::sin(
        rotation_joint->z
      )
    )
  };

  math_c_vector3_float rotation_joint_cosines = {
    .x = (
      metal::cos(
        rotation_joint->x
      )
    ),
    .y = (
      metal::cos(
        rotation_joint->y
      )
    ),
    .z = (
      metal::cos(
        rotation_joint->z
      )
    )
  };

  *matrix_projection_rotation_joint = (
    (matrix_float4x4) {{
      { rotation_joint_cosines.y, 0.0f, -rotation_joint_sines.y, 0.0f },
      { 0.0f, 1.0f, 0.0f, 0.0f },
      { rotation_joint_sines.y, 0.0f, rotation_joint_cosines.y, 0.0f },
      { 0.0f, 0.0f, 0.0f, 1.0f }
    }} *
    (matrix_float4x4) {{
      { 1.0f, 0.0f, 0.0f, 0.0f },
      { 0.0f, rotation_joint_cosines.x, -rotation_joint_sines.x, 0.0f },
      { 0.0f, rotation_joint_sines.x, rotation_joint_cosines.x, 0.0f },
      { 0.0f, 0.0f, 0.0f, 1.0f }
    }} *
    (matrix_float4x4) {{
      { rotation_joint_cosines.z, -rotation_joint_sines.z, 0.0f, 0.0f },
      { rotation_joint_sines.z, rotation_joint_cosines.z, 0.0f, 0.0f },
      { 0.0f, 0.0f, 1.0f, 0.0f },
      { 0.0f, 0.0f, 0.0f, 1.0f }
    }}
  );
}
