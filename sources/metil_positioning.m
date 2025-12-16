#include <metil_positioning.h>

#include <metil_rendering/camera/camera.h>
#include <metil_rendering/camera/camera_mode.h>
#include <metil_scenes/scene_controller.h>

#include <clic3_vector.h>

#include <math.h>
#include <simd/simd.h>

void metil_positioning_view_model_matrix_projection_set(
  enum metil_positioning positioning,
  matrix_float4x4* view_model_matrix_projection,
  matrix_float3x4* matrix_projection_static,
  matrix_float4x4* matrix_object_projection,
  matrix_float4x4* matrix_player_projection,
  struct clic3_vector3_float* position,
  struct clic3_vector3_float* rotation,
  struct metil_camera* metil_camera
) {
  if (
    positioning == metil_positioning_absolute
  ) {
    *view_model_matrix_projection = (matrix_float4x4) {{
      { 1.0f, 0.0f, 0.0f, 0.0f },
      { 0.0f, 1.0f, 0.0f, 0.0f },
      { 0.0f, 0.0f, 1.0f, 0.0f },
      { position->x, position->y, position->z, 1.0f }
    }};
  } else if (
    positioning == metil_positioning_static
  ) {
    *view_model_matrix_projection = (matrix_float4x4) {{
      matrix_projection_static->columns[0],
      matrix_projection_static->columns[1],
      matrix_projection_static->columns[2],
      { position->x, position->y, position->z, 1.0f }
    }};
  } else {
    struct clic3_vector3_float position_translated = {
      .x = (
        position->x -
        metil_scene_controller.scene.player.position.x
      ),
      .y = (
        position->y -
        metil_scene_controller.scene.player.position.y -
        metil_camera->height
      ),
      .z = (
        position->z -
        metil_scene_controller.scene.player.position.z
      )
    };

    matrix_float4x4* matrix_projection = (void*)0;

    if (
      positioning == metil_positioning_player
    ) {
      matrix_projection = matrix_player_projection;
    } else {
      matrix_projection = matrix_object_projection;
    }

    matrix_float4x4 matrix_projection_object_with_rotation = matrix_multiply(
      (matrix_float4x4) {{
        { 1.0f, 0.0f, 0.0f, 0.0f },
        { 0.0f, 1.0f, 0.0f, 0.0f },
        { 0.0f, 0.0f, 1.0f, 0.0f },
        {
          position_translated.x,
          position_translated.y,
          position_translated.z,
          1
        }
      }},
      (matrix_float4x4) {{
        { 1.0f, 0.0f, 0.0f, 0.0f },
        { 0.0f, cos(rotation->x), -sin(rotation->x), 0.0f },
        { 0.0f, sin(rotation->x), cos(rotation->x), 0.0f },
        { 0.0f, 0.0f, 0.0f, 1.0f }
      }}
    );

    matrix_projection_object_with_rotation = matrix_multiply(
      matrix_projection_object_with_rotation,
      (matrix_float4x4) {{
        { cos(rotation->y), 0.0f, -sin(rotation->y), 0.0f },
        { 0.0f, 1.0f, 0.0f, 0.0f },
        { sin(rotation->y), 0.0f, cos(rotation->y), 0.0f },
        { 0.0f, 0.0f, 0.0f, 1.0f }
      }}
    );

    matrix_projection_object_with_rotation = matrix_multiply(
      matrix_projection_object_with_rotation,
      (matrix_float4x4) {{
        { cos(rotation->z), -sin(rotation->z), 0.0f, 0.0f },
        { sin(rotation->z), cos(rotation->z), 0.0f, 0.0f },
        { 0.0f, 0.0f, 1.0f, 0.0f },
        { 0.0f, 0.0f, 0.0f, 1.0f }
      }}
    );

    *view_model_matrix_projection = matrix_multiply(
      *matrix_projection,
      matrix_projection_object_with_rotation
    );
  }
}
