#include <3d_rendering_objects/3d_rendering_sky.h>

#include <example_3d_rendering_index_pipeline.h>

#include <math_c_vector.h>

#include <metil.h>
#include <metil_mesh/metil_mesh_sphere.h>
#include <metil_object/metil_object.h>

void metil_example_3d_rendering_sky_initialize(
  struct metil* metil,
  struct metil_object* metil_object_sky
) {
  metil_mesh_sphere_initialize(
    &metil_object_sky->mesh,
    10000.0f,
    (struct math_c_vector2_unsigned_short_int) {
      .x = (
        0x13
      ),
      .y = (
        0x15
      )
    }
  );

  metil_object_buffers_initialize(
    metil_object_sky,
    metil->renderer_interface.metal_device
  );

  metil_object_sky->index_pipeline_render = (
    example_3d_rendering_index_pipeline_sky
  );
}

