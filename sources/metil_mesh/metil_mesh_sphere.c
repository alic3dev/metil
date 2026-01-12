#include <metil_mesh/metil_mesh_ball.h>

#include <metil_mesh/metil_mesh.h>

#include <math_c_vector.h>

void metil_mesh_sphere_initialize(
  struct metil_mesh* metil_mesh,
  float diameter,
  struct math_c_vector2_unsigned_short_int segments
) {
  metil_mesh_ball_initialize(
    metil_mesh,
    diameter,
    segments
  );
}
