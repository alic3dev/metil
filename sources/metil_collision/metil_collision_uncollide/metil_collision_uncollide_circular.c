#include <metil_collision/metil_collision_uncollide/metil_collision_uncollide_circular.h>

#include <clic3_vector.h>

#include <math_c_maximum.h>
#include <math_c_power.h>
#include <math_c_square_root.h>

void metil_collision_uncollide_circular_xz(
  struct clic3_vector3_float* position_collidable,
  struct clic3_vector3_float* size_collidable,
  struct clic3_vector3_float* position_collider,
  struct clic3_vector3_float* size_collider
) {  
  float distance_collision_minimum = (
    math_c_maximum_float(
      size_collidable->x,
      size_collidable->z
    ) /
    2.0f +
    math_c_maximum_float(
      size_collider->x,
      size_collider->z
    ) /
    2.0f
  );

  metil_collision_uncollide_circular_distance_xz(
    position_collidable,
    position_collider,
    distance_collision_minimum
  );
}

void metil_collision_uncollide_circular_distance_xz(
  struct clic3_vector3_float* position_collidable,
  struct clic3_vector3_float* position_collider,
  float distance_collision_minimum
) {
  struct clic3_vector2_float distances_collidable_collider = {
    .x = (
      position_collidable->x -
      position_collider->x
    ),
    .y = (
      position_collidable->z -
      position_collider->z
    )
  };

  float distance_total_collidable_collider = (
    math_c_square_root(
      math_c_power_float(
        distances_collidable_collider.x,
        2.0f
      ) +
      math_c_power_float(
        distances_collidable_collider.y,
        2.0f
      )
    )
  );

  if (
    distance_total_collidable_collider >= distance_collision_minimum
  ) {
    return;
  }

  struct clic3_vector2_float distance_percentages_collidable_collider;

  if (
    distance_total_collidable_collider == 0.0f
  ) {
    distance_percentages_collidable_collider.x = (
      0.5f
    );

    distance_percentages_collidable_collider.y = (
      0.5f
    );
  } else {
    distance_percentages_collidable_collider.x = (
      distances_collidable_collider.x /
      distance_total_collidable_collider
    );

    distance_percentages_collidable_collider.y = (
      distances_collidable_collider.y /
      distance_total_collidable_collider
    );
  }

  float distance_difference = (
    distance_collision_minimum -
    distance_total_collidable_collider
  );

  position_collider->x = (
    position_collider->x -
    distance_percentages_collidable_collider.x *
    distance_difference
  );

  position_collider->z = (
    position_collider->z -
    distance_percentages_collidable_collider.y *
    distance_difference
  );
}
