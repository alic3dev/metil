#include <metil_rendering/camera/camera.h>

#include <math.h>

#include <simd/simd.h>

float metil_camera_height_default = __metil_camera_height_default;

void metil_camera_initialize(
  struct metil_camera* camera
) {
  camera->field_of_view.x = 0.0f;
  camera->field_of_view.y = 0.0f;

  camera->height = metil_camera_height_default;

  camera->distance_view.near = 0.5f;
  camera->distance_view.far = 10000.0f;

  camera->lens.length_focal = 10.0f;
  camera->lens.size_sensor = 10.0f;

  camera->matrix_viewport_projection = (simd_float4x4) {{
    { 0.0f, 0.0f, 0.0f, 0.0f },
    { 0.0f, 0.0f, 0.0f, 0.0f },
    { 0.0f, 0.0f, 0.0f, -1.0f },
    { 0.0f, 0.0f, 0.0f, 0.0f }
  }};
}

void metil_camera_ratio_aspect_set(
  struct metil_camera* camera,
  float ratio_aspect,
  float width,
  float height
) {
  camera->ratio_aspect = ratio_aspect;
  camera->ratio_aspect_view = (
    width / height
  );

  metil_camera_field_of_view_set(
    camera
  );
}

float metil_camera_field_of_view_calculate(
  struct metil_camera* camera
) {
  return (
    2.0f * atanf(
      camera->lens.size_sensor / (
        2.0f *
        camera->lens.length_focal
      )
    )
  );
}

float metil_camera_field_of_view_horizontal_calculate(
  struct metil_camera* camera
) {
  return (
    camera->field_of_view.y *
    camera->ratio_aspect
  );
}

void metil_camera_field_of_view_set(
  struct metil_camera* camera
) {
  camera->field_of_view.y = metil_camera_field_of_view_calculate(
    camera
  );

  camera->field_of_view.x = metil_camera_field_of_view_horizontal_calculate(
    camera
  );

  camera->vector_normalization.x = 1.0f / camera->field_of_view.x;
  camera->vector_normalization.y = 1.0f / camera->field_of_view.y;
  camera->vector_normalization.z = (
    camera->distance_view.far / (
      camera->distance_view.near -
      camera->distance_view.far
    )
  );

  // TODO: This keeps objects sized properly, however, it also increases the FOV when Y shrinks. Will fix this later.
  camera->matrix_viewport_projection.columns[0].x = (
    camera->vector_normalization.x * (
      camera->ratio_aspect / camera->ratio_aspect_view
    )
  );
  camera->matrix_viewport_projection.columns[1].y = camera->vector_normalization.y;
  camera->matrix_viewport_projection.columns[2].z = camera->vector_normalization.z;
  camera->matrix_viewport_projection.columns[3].z = camera->distance_view.near * camera->vector_normalization.z;
}
