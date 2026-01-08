#include <metil_collision/metil_collision_uncollide/metil_collision_uncollide_circular.h>

#include <metil_object/metil_object.h>
#include <metil_player/metil_player.h>

#include <math_c_vector.h>
#include <math_c_vector_scale.h>
#include <math_c_vector_uncollide.h>

#include <math_c_maximum.h>
#include <math_c_power.h>
#include <math_c_square_root.h>

unsigned char metil_collision_object_uncollide_circular_xz(
  struct math_c_vector3_float* position_collidable,
  struct math_c_vector3_float* size_collidable,
  struct metil_object* metil_object_collider
) {
  return math_c_vector3_float_uncollide_circular_xz(
    position_collidable,
    size_collidable,
    &metil_object_collider->position,
    &metil_object_collider->mesh.size
  );
}

unsigned char metil_collision_object_uncollide_circular_distance_xz(
  struct math_c_vector3_float* position_collidable,
  struct metil_object* metil_object_collider,
  float distance_collision_minimum
) {
  return math_c_vector3_float_uncollide_circular_distance_xz(
    position_collidable,
    &metil_object_collider->position,
    distance_collision_minimum
  );
}

unsigned char metil_collision_player_uncollide_circular_xz(
  struct math_c_vector3_float* position_collidable,
  struct math_c_vector3_float* size_collidable,
  struct metil_player* metil_player_collider
) {
  return math_c_vector3_float_uncollide_circular_xz(
    position_collidable,
    size_collidable,
    &metil_player_collider->position,
    &metil_player_collider->size
  );
}

unsigned char metil_collision_player_uncollide_circular_distance_xz(
  struct math_c_vector3_float* position_collidable,
  struct metil_player* metil_player_collider,
  float distance_collision_minimum
) {
  return math_c_vector3_float_uncollide_circular_distance_xz(
    position_collidable,
    &metil_player_collider->position,
    distance_collision_minimum
  );
}

unsigned char metil_collision_object_object_uncollide_circular_xz(
  struct metil_object* metil_object_collidable,
  struct metil_object* metil_object_collider
) {
  return math_c_vector3_float_uncollide_circular_xz(
    &metil_object_collidable->position,
    &metil_object_collidable->mesh.size,
    &metil_object_collider->position,
    &metil_object_collider->mesh.size
  );
}

unsigned char metil_collision_object_object_uncollide_circular_distance_xz(
  struct metil_object* metil_object_collidable,
  struct metil_object* metil_object_collider,
  float distance_collision_minimum
) {
  return math_c_vector3_float_uncollide_circular_distance_xz(
    &metil_object_collidable->position,
    &metil_object_collider->position,
    distance_collision_minimum
  );
}

unsigned char metil_collision_player_object_uncollide_circular_xz(
  struct metil_object* metil_object_collidable,
  struct metil_player* metil_player_collider
) {
  return math_c_vector3_float_uncollide_circular_xz(
    &metil_object_collidable->position,
    &metil_object_collidable->mesh.size,
    &metil_player_collider->position,
    &metil_player_collider->size
  );
}

unsigned char metil_collision_player_object_uncollide_circular_distance_xz(
  struct metil_object* metil_object_collidable,
  struct metil_player* metil_player_collider,
  float distance_collision_minimum
) {
  return math_c_vector3_float_uncollide_circular_distance_xz(
    &metil_object_collidable->position,
    &metil_player_collider->position,
    distance_collision_minimum
  );
}

unsigned char metil_collision_object_player_uncollide_circular_xz(
  struct metil_player* metil_player_collidable,
  struct metil_object* metil_object_collider
) {
  return math_c_vector3_float_uncollide_circular_xz(
    &metil_player_collidable->position,
    &metil_player_collidable->size,
    &metil_object_collider->position,
    &metil_object_collider->mesh.size
  );
}

unsigned char metil_collision_object_player_uncollide_circular_distance_xz(
  struct metil_player* metil_player_collidable,
  struct metil_object* metil_object_collider,
  float distance_collision_minimum
) {
  return math_c_vector3_float_uncollide_circular_distance_xz(
    &metil_player_collidable->position,
    &metil_object_collider->position,
    distance_collision_minimum
  );
}

unsigned char metil_collision_vector_object_uncollide_circular_xz(
  struct metil_object* metil_object_collidable,
  struct math_c_vector3_float* position_collider,
  struct math_c_vector3_float* size_collider
) {
  return math_c_vector3_float_uncollide_circular_xz(
    &metil_object_collidable->position,
    &metil_object_collidable->mesh.size,
    position_collider,
    size_collider
  );
}

unsigned char metil_collision_vector_object_uncollide_circular_distance_xz(
  struct metil_object* metil_object_collidable,
  struct math_c_vector3_float* position_collider,
  float distance_collision_minimum
) {
  return math_c_vector3_float_uncollide_circular_distance_xz(
    &metil_object_collidable->position,
    position_collider,
    distance_collision_minimum
  );
}

unsigned char metil_collision_vector_player_uncollide_circular_xz(
  struct metil_player* metil_player_collidable,
  struct math_c_vector3_float* position_collider,
  struct math_c_vector3_float* size_collider
) {
  return math_c_vector3_float_uncollide_circular_xz(
    &metil_player_collidable->position,
    &metil_player_collidable->size,
    position_collider,
    size_collider
  );
}

unsigned char metil_collision_vector_player_uncollide_circular_distance_xz(
  struct metil_player* metil_player_collidable,
  struct math_c_vector3_float* position_collider,
  float distance_collision_minimum
) {
  return math_c_vector3_float_uncollide_circular_distance_xz(
    &metil_player_collidable->position,
    position_collider,
    distance_collision_minimum
  );
}
