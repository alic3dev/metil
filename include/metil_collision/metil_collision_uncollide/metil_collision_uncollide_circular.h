#ifndef __metil_collision_metil_collision_uncollide_metil_collision_uncollide_circular_h
#define __metil_collision_metil_collision_uncollide_metil_collision_uncollide_circular_h

#include <clic3_vector.h>

void metil_collision_uncollide_circular_xz(
  struct clic3_vector3_float*,
  struct clic3_vector3_float*,
  struct clic3_vector3_float*,
  struct clic3_vector3_float*
);

void metil_collision_uncollide_circular_distance_xz(
  struct clic3_vector3_float*,
  struct clic3_vector3_float*,
  float
);

#endif
