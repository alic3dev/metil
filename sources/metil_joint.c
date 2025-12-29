#include <metil_joint.h>

#include <simd/simd.h>

#include <stdlib.h>

void metil_joint_initialize(
  struct metil_joint* metil_joint
) {
  metil_joint->position.x = 0.0f;
  metil_joint->position.y = 0.0f;
  metil_joint->position.z = 0.0f;

  metil_joint->rotation.x = 0.0f;
  metil_joint->rotation.y = 0.0f;
  metil_joint->rotation.z = 0.0f;

  metil_joint->rotation_applied.x = 0.0f;
  metil_joint->rotation_applied.y = 0.0f;
  metil_joint->rotation_applied.z = 0.0f;

  metil_joint->length_joints = 0;

  metil_joint->joints = malloc(
    sizeof(struct metil_joint*) *
    metil_joint->length_joints
  );
}

void metil_joint_attach(
  struct metil_joint* metil_joint,
  struct metil_joint* metil_joint_attaching
) {
  metil_joint->length_joints = (
    metil_joint->length_joints +
    1
  );

  metil_joint->joints = realloc(
    metil_joint->joints,
    sizeof(struct metil_joint*) *
    metil_joint->length_joints
  );

  metil_joint->joints[
    metil_joint->length_joints -
    1
  ] = (
    metil_joint_attaching
  );
}

#include <stdio.h>

void metil_joint_propagate(
  struct metil_joint* metil_joint
) {
  for (
    unsigned char index_joint = 0;
    index_joint < metil_joint->length_joints;
    ++index_joint
  ) {
    struct metil_joint* metil_joint_propagation_selection = (
      metil_joint->joints[
        index_joint
      ]
    );

    matrix_float4x4 matrix_projection_object_with_rotation = matrix_multiply(
      matrix_multiply(
        (matrix_float4x4) {{
          { cos(metil_joint->rotation.y + metil_joint->rotation_applied.y), 0.0f, -sin(metil_joint->rotation.y + metil_joint->rotation_applied.y), 0.0f },
          { 0.0f, 1.0f, 0.0f, 0.0f },
          { sin(metil_joint->rotation.y + metil_joint->rotation_applied.y), 0.0f, cos(metil_joint->rotation.y + metil_joint->rotation_applied.y), 0.0f },
          { 0.0f, 0.0f, 0.0f, 1.0f }
        }},
        (matrix_float4x4) {{
          { 1.0f, 0.0f, 0.0f, 0.0f },
          { 0.0f, cos(metil_joint->rotation.x + metil_joint->rotation_applied.x), -sin(metil_joint->rotation.x + metil_joint->rotation_applied.x), 0.0f },
          { 0.0f, sin(metil_joint->rotation.x + metil_joint->rotation_applied.x), cos(metil_joint->rotation.x + metil_joint->rotation_applied.x), 0.0f },
          { 0.0f, 0.0f, 0.0f, 1.0f }
        }}
      ),
      (matrix_float4x4) {{
        { cos(metil_joint->rotation.z + metil_joint->rotation_applied.z), -sin(metil_joint->rotation.z + metil_joint->rotation_applied.z), 0.0f, 0.0f },
        { sin(metil_joint->rotation.z + metil_joint->rotation_applied.z), cos(metil_joint->rotation.z + metil_joint->rotation_applied.z), 0.0f, 0.0f },
        { 0.0f, 0.0f, 1.0f, 0.0f },
        { 0.0f, 0.0f, 0.0f, 1.0f }
      }}
    );

    simd_float4 l = (
      (
        matrix_multiply(
          (simd_float4) {
            metil_joint_propagation_selection->position.x,
            metil_joint_propagation_selection->position.y,
            metil_joint_propagation_selection->position.z,
            1.0f
          } -
          (simd_float4) {
            metil_joint->position.x,
            metil_joint->position.y,
            metil_joint->position.z,
            0.0f
          },
          matrix_projection_object_with_rotation
        )
      ) + (simd_float4) {
        metil_joint->position.x,
        metil_joint->position.y,
        metil_joint->position.z,
        0.0f
      } + (simd_float4) {
        metil_joint->translation.x,
        metil_joint->translation.y,
        metil_joint->translation.z,
        0.0f
      } -
      (simd_float4) {
        metil_joint_propagation_selection->position.x,
        metil_joint_propagation_selection->position.y,
        metil_joint_propagation_selection->position.z,
        1.0f
      }
    );

    metil_joint_propagation_selection->translation.x = l.x;
    metil_joint_propagation_selection->translation.y = l.y;
    metil_joint_propagation_selection->translation.z = l.z;

    metil_joint_propagation_selection->rotation_applied.x = metil_joint->rotation.x + metil_joint->rotation_applied.x;
    metil_joint_propagation_selection->rotation_applied.y = metil_joint->rotation.y + metil_joint->rotation_applied.y;
    metil_joint_propagation_selection->rotation_applied.z = metil_joint->rotation.z + metil_joint->rotation_applied.z;

    metil_joint_propagate(
      metil_joint_propagation_selection
    );
  }
}

void metil_joint_destroy(
  struct metil_joint* metil_joint
) {
  free(
    metil_joint->joints
  );
}
