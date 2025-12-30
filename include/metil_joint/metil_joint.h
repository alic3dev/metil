#ifndef __metil_joint_h
#define __metil_joint_h

#include <clic3_vector.h>

struct metil_joint {
  struct clic3_vector3_float position;
  struct clic3_vector3_float rotation;
  struct clic3_vector3_float rotation_applied;
  struct clic3_vector3_float translation;

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

void metil_joint_propagate(
  struct metil_joint* _Nonnull
);

void metil_joint_destroy(
  struct metil_joint* _Nonnull
);

#endif
