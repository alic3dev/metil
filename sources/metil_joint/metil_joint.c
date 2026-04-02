#include <metil_joint/metil_joint.h>

#include <clic3_memory.h>

#include <math_c_pi.h>
#include <math_c_sine.h>

#include <simd/simd.h>

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

  metil_joint->translation.x = 0.0f;
  metil_joint->translation.y = 0.0f;
  metil_joint->translation.z = 0.0f;

  metil_joint->length_joints = 0;

  metil_joint->joints = (
    clic3_memory_allocate_raw(
      0
    )
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

  clic3_memory_reallocate_raw(
    &metil_joint->joints,
    (
      sizeof(
        struct metil_joint*
      ) *
      metil_joint->length_joints
    )
  );

  metil_joint->joints[
    metil_joint->length_joints -
    1
  ] = (
    metil_joint_attaching
  );
}

void metil_joint_propagate_reset(
  struct metil_joint* metil_joint
) {
  metil_joint->translation.x = (
    0x00
  );

  metil_joint->translation.y = (
    0x00
  );

  metil_joint->translation.z = (
    0x00
  );

  metil_joint->rotation.x = (
    0x00
  );

  metil_joint->rotation.y = (
    0x00
  );

  metil_joint->rotation.z = (
    0x00
  );

  metil_joint->rotation_applied.x = (
    0x00
  );

  metil_joint->rotation_applied.y = (
    0x00
  );

  metil_joint->rotation_applied.z = (
    0x00
  );

  for (
    unsigned char index_joint = (
      0x00
    );
    (
      index_joint <
      metil_joint->length_joints
    );
    ++index_joint
  ) {
    metil_joint_propagate_reset(
      metil_joint->joints[
        index_joint
      ]
    );
  }
}

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

    metil_joint_propagation_selection->rotation_applied.x = (
      metil_joint->rotation.x +
      metil_joint->rotation_applied.x
    );

    metil_joint_propagation_selection->rotation_applied.y = (
      metil_joint->rotation.y +
      metil_joint->rotation_applied.y
    );

    metil_joint_propagation_selection->rotation_applied.z = (
      metil_joint->rotation.z +
      metil_joint->rotation_applied.z
    );

    matrix_float4x4 matrix_metil_joint_propagation_selection_rotation = (
      matrix_multiply(
        (matrix_float4x4) {{
          { math_c_cosine(metil_joint_propagation_selection->rotation_applied.y, math_c_pi), 0.0f, -math_c_sine(metil_joint_propagation_selection->rotation_applied.y, math_c_pi), 0.0f },
          { 0.0f, 1.0f, 0.0f, 0.0f },
          { math_c_sine(metil_joint_propagation_selection->rotation_applied.y, math_c_pi), 0.0f, math_c_cosine(metil_joint_propagation_selection->rotation_applied.y, math_c_pi), 0.0f },
          { 0.0f, 0.0f, 0.0f, 1.0f }
        }},
        (matrix_float4x4) {{
          { 1.0f, 0.0f, 0.0f, 0.0f },
          { 0.0f, math_c_cosine(metil_joint_propagation_selection->rotation_applied.x, math_c_pi), -math_c_sine(metil_joint_propagation_selection->rotation_applied.x, math_c_pi), 0.0f },
          { 0.0f, math_c_sine(metil_joint_propagation_selection->rotation_applied.x, math_c_pi), math_c_cosine(metil_joint_propagation_selection->rotation_applied.x, math_c_pi), 0.0f },
          { 0.0f, 0.0f, 0.0f, 1.0f }
        }}
      )
    );

    matrix_metil_joint_propagation_selection_rotation = (
      matrix_multiply(
        matrix_metil_joint_propagation_selection_rotation,
        (matrix_float4x4) {{
          { math_c_cosine(metil_joint_propagation_selection->rotation_applied.z, math_c_pi), -math_c_sine(metil_joint_propagation_selection->rotation_applied.z, math_c_pi), 0.0f, 0.0f },
          { math_c_sine(metil_joint_propagation_selection->rotation_applied.z, math_c_pi), math_c_cosine(metil_joint_propagation_selection->rotation_applied.z, math_c_pi), 0.0f, 0.0f },
          { 0.0f, 0.0f, 1.0f, 0.0f },
          { 0.0f, 0.0f, 0.0f, 1.0f }
        }}
      )
    );

    simd_float4 position_joint = {
      metil_joint->position.x,
      metil_joint->position.y,
      metil_joint->position.z,
      0.0f
    };

    simd_float4 position_joint_translation = {
      metil_joint->translation.x,
      metil_joint->translation.y,
      metil_joint->translation.z,
      0.0f
    };

    simd_float4 position_joint_propagation_selection = {
      metil_joint_propagation_selection->position.x,
      metil_joint_propagation_selection->position.y,
      metil_joint_propagation_selection->position.z,
      1.0f
    };

    simd_float4 position_joint_origin_offset = (
      position_joint_propagation_selection -
      position_joint
    );

    simd_float4 position_joint_propagation_selection_translation_rotated_origin = (
      matrix_multiply(
        position_joint_origin_offset,
        matrix_metil_joint_propagation_selection_rotation
      )
    );

    simd_float4 metil_joint_propagation_selection_translation = (
      position_joint_propagation_selection_translation_rotated_origin +
      position_joint +
      position_joint_translation -
      position_joint_propagation_selection
    );

    metil_joint_propagation_selection->translation.x = (
      metil_joint_propagation_selection_translation.x
    );

    metil_joint_propagation_selection->translation.y = (
      metil_joint_propagation_selection_translation.y
    );
    metil_joint_propagation_selection->translation.z = (
      metil_joint_propagation_selection_translation.z
    );

    metil_joint_propagate(
      metil_joint_propagation_selection
    );
  }
}

void metil_joint_destroy(
  struct metil_joint* metil_joint
) {
  clic3_memory_free_raw(
    metil_joint->joints
  );
}
