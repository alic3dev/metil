#ifndef __metil_collision_metil_collision_uncollide_metil_collision_uncollide_circular_h
#define __metil_collision_metil_collision_uncollide_metil_collision_uncollide_circular_h

#include <math_c_vector.h>

void metil_collision_uncollide_circular_xz(
  struct math_c_vector3_float*,
  struct math_c_vector3_float*,
  struct math_c_vector3_float*,
  struct math_c_vector3_float*
);

void metil_collision_uncollide_circular_distance_xz(
  struct math_c_vector3_float*,
  struct math_c_vector3_float*,
  float
);

#endif
