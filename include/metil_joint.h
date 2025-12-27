#ifndef __metil_model_metil_joint_h
#define __metil_model_metil_joint_h

#include <clic3_vector.h>

struct metil_joint {
  struct clic3_vector3_float position;
  struct clic3_vector3_float rotation;

  struct metil_joint* _Nonnull joints;
  unsigned char length_joints;
};

void metil_joint_initialize(
  struct metil_joint* _Nonnull
);

void metil_joint_add(
  struct metil_joint* _Nonnull
);

void metil_joint_destroy(
  struct metil_joint* _Nonnull
);

#endif
