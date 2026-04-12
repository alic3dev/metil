#include <3d_rendering_objects/3d_rendering_ground.h>

#include <example_3d_rendering_index_pipeline.h>

#include <math_c_pi.h>
#include <math_c_vector.h>

#include <metil.h>
#include <metil_mesh/metil_mesh_2d/metil_mesh_grid.h>
#include <metil_object/metil_object.h>

void metil_example_3d_rendering_ground_initialize(
  struct metil* metil,
  struct metil_object* metil_object_ground
) {
  metil_mesh_celled_triangles_quadruple_grid_initialize(
    &metil_object_ground->mesh,
    (struct math_c_vector2_float) {
      .x = (
        0xffff
      ),
      .y = (
        0xffff
      )
    },
    (struct math_c_vector2_unsigned_long_int) {
      .x = (
        0x01f4
      ),
      .y = (
        0x01f4
      )
    }
  );

  metil_object_buffers_initialize(
    metil_object_ground,
    metil->renderer_interface.metal_device
  );

  metil_object_ground->index_pipeline_render = (
    example_3d_rendering_index_pipeline_ground
  );

  metil_object_ground->rotation.x = (
    math_c_pi_half
  );
}
