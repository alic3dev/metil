#include <metil_joint.h>

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

  metil_joint->length_joints = 0;

  metil_joint->joints = malloc(
    sizeof(struct metil_joint) *
    metil_joint->length_joints
  );
}

void metil_joint_add(
  struct metil_joint* metil_joint
) {
  metil_joint->length_joints = (
    metil_joint->length_joints +
    1
  );

  metil_joint->joints = realloc(
    metil_joint->joints,
    sizeof(struct metil_joint) *
    metil_joint->length_joints
  );

  metil_joint_initialize(
    &metil_joint->joints[
      metil_joint->length_joints
    ]
  );
}

void metil_joint_destroy(
  struct metil_joint* metil_joint
) {
  for (
    unsigned char index_joint = 0;
    index_joint < metil_joint->length_joints;
    ++index_joint
  ) {
    metil_joint_destroy(
      &metil_joint->joints[
        index_joint
      ]
    );
  }

  free(metil_joint->joints);
}
