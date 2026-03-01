#include <metil_rendering/metil_camera/metil_camera.h>

#include <metil_rendering/metil_camera/metil_camera_mode.h>

#include <simd/simd.h>

void metil_camera_initialize(
  struct metil_camera* metil_camera
) {
  metil_camera->mode = (
    metil_camera_mode_first_person
  );

  metil_camera->field_of_view.x = 1.45f;
  metil_camera->field_of_view.y = (
    metil_camera->field_of_view.x *
    (
      9.0f /
      16.0f
    )
  );

  if (
    metil_camera->initialized == 0
  ) {
    metil_camera->height_default = (
      metil_camera_height_default
    );

    metil_camera->initialized = 1;
  }

  metil_camera->height = (
    metil_camera->height_default
  );

  metil_camera->distance_view.near = 0.5f;
  metil_camera->distance_view.far = 10000.0f;

  metil_camera->matrix_viewport_projection = (simd_float4x4) {{
    { 1.0f, 0.0f, 0.0f, 0.0f },
    { 0.0f, 1.0f, 0.0f, 0.0f },
    { 0.0f, 0.0f, 1.0f, -1.0f },
    { 0.0f, 0.0f, 0.0f, 1.0f }
  }};
}

void metil_camera_ratio_aspect_set(
  struct metil_camera* metil_camera,
  struct math_c_vector2_float* metil_camera_size_view
) {
  metil_camera->ratio_aspect_view = (
    metil_camera_size_view->x /
    metil_camera_size_view->y
  );

  metil_camera_normalization_set(
    metil_camera
  );
}

void metil_camera_field_of_view_set(
  struct metil_camera* metil_camera,
  struct math_c_vector2_float metil_camera_field_of_view
) {
  metil_camera->field_of_view.x = (
    metil_camera_field_of_view.x
  );

  metil_camera->field_of_view.y = (
    metil_camera_field_of_view.y
  );

  metil_camera_normalization_set(
    metil_camera
  );
}

void metil_camera_normalization_set(
  struct metil_camera* metil_camera
) {
  metil_camera->vector_normalization.x = (
    (
      1.0f /
      metil_camera->ratio_aspect_view
    )
  );

  metil_camera->vector_normalization.y = (
    1.0f
  );

  metil_camera->vector_normalization.z = (
    metil_camera->distance_view.near *
    metil_camera->distance_view.far /
    (
      metil_camera->distance_view.near -
      metil_camera->distance_view.far
    )
  );

  metil_camera_matrix_projection_set(
    metil_camera
  );
}

void metil_camera_matrix_projection_set(
  struct metil_camera* metil_camera
) {
   metil_camera->matrix_viewport_projection.columns[
    0
  ].x = (
    metil_camera->vector_normalization.x
  );

  metil_camera->matrix_viewport_projection.columns[
    1
  ].y = (
    metil_camera->vector_normalization.y
  );

  metil_camera->matrix_viewport_projection.columns[
    2
  ].z = (
    metil_camera->vector_normalization.z
  );
}
