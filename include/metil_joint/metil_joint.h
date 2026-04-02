#ifndef __metil_joint_metil_joint_h
#define __metil_joint_metil_joint_h

#include <math_c_vector.h>

struct metil_joint {
  struct math_c_vector3_float position;
  struct math_c_vector3_float rotation;
  struct math_c_vector3_float rotation_applied;
  struct math_c_vector3_float translation;

  struct metil_joint* _Nonnull * _Nonnull joints;
  unsigned char length_joints;
};

void metil_joint_initialize(
  struct metil_joint* _Nonnull
);

void metil_joint_attach(
  struct metil_joint* _Nonnull,
  struct metil_joint* _Nonnull
);

void metil_joint_propagate_reset(
  struct metil_joint* _Nonnull
);

void metil_joint_propagate(
  struct metil_joint* _Nonnull
);

void metil_joint_destroy(
  struct metil_joint* _Nonnull
);

#endif
