#ifndef __metil_collision_metil_collision_uncollide_metil_collision_uncollide_circular_h
#define __metil_collision_metil_collision_uncollide_metil_collision_uncollide_circular_h

#include <metil_object/metil_object.h>
#include <metil_player/metil_player.h>

#include <math_c_vector.h>

unsigned char metil_collision_object_uncollide_circular_xz(
  struct math_c_vector3_float*,
  struct math_c_vector3_float*,
  struct metil_object*
);

unsigned char metil_collision_object_uncollide_circular_distance_xz(
  struct math_c_vector3_float*,
  struct metil_object*,
  float
);

unsigned char metil_collision_player_uncollide_circular_xz(
  struct math_c_vector3_float*,
  struct math_c_vector3_float*,
  struct metil_player*
);

unsigned char metil_collision_player_uncollide_circular_distance_xz(
  struct math_c_vector3_float*,
  struct metil_player*,
  float
);

unsigned char metil_collision_object_object_uncollide_circular_xz(
  struct metil_object*,
  struct metil_object*
);

unsigned char metil_collision_object_object_uncollide_circular_distance_xz(
  struct metil_object*,
  struct metil_object*,
  float
);

unsigned char metil_collision_player_object_uncollide_circular_xz(
  struct metil_object*,
  struct metil_player*
);

unsigned char metil_collision_player_object_uncollide_circular_distance_xz(
  struct metil_object*,
  struct metil_player*,
  float
);

unsigned char metil_collision_object_player_uncollide_circular_xz(
  struct metil_player*,
  struct metil_object*
);

unsigned char metil_collision_object_player_uncollide_circular_distance_xz(
  struct metil_player*,
  struct metil_object*,
  float
);

unsigned char metil_collision_vector_object_uncollide_circular_xz(
  struct metil_object*,
  struct math_c_vector3_float*,
  struct math_c_vector3_float*
);

unsigned char metil_collision_vector_object_uncollide_circular_distance_xz(
  struct metil_object*,
  struct math_c_vector3_float*,
  float
);

unsigned char metil_collision_vector_player_uncollide_circular_xz(
  struct metil_player*,
  struct math_c_vector3_float*,
  struct math_c_vector3_float*
);

unsigned char metil_collision_vector_player_uncollide_circular_distance_xz(
  struct metil_player*,
  struct math_c_vector3_float*,
  float
);

#endif
