#ifndef __metil_rendering_camera_camera_h
#define __metil_rendering_camera_camera_h

#include <metil_rendering/camera/lens.h>
#include <metil_rendering/camera/near_far.h>

#include <clic3_vector.h>

#include <simd/simd.h>

struct metil_camera {
  struct metil_lens lens;

  float ratio_aspect;

  struct clic3_vector2_float field_of_view;

  struct metil_near_far distance_view;

  struct clic3_vector3_float vector_normalization;
  simd_float4x4 matrix_viewport_projection;
};

void metil_camera_initialize(
  struct metil_camera*
);

void metil_camera_ratio_aspect_set(
  struct metil_camera*,
  float
);

float metil_camera_field_of_view_calculate(
  struct metil_camera*
);

float metil_camera_field_of_view_horizontal_calculate(
  struct metil_camera*
);

void metil_camera_field_of_view_set(
  struct metil_camera*
);

#endif
