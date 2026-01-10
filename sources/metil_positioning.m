#include <metil_positioning.h>

#include <metil_rendering/metil_camera/metil_camera.h>
#include <metil_rendering/metil_camera/metil_camera_mode.h>
#include <metil_scenes/metil_scene_controller.h>

#include <math_c_vector.h>

#include <math.h>
#include <simd/simd.h>

void metil_positioning_view_model_matrix_projection_set(
  enum metil_positioning positioning,
  matrix_float4x4* view_model_matrix_projection,
  matrix_float3x4* matrix_projection_static,
  matrix_float4x4* matrix_object_projection,
  matrix_float4x4* matrix_player_projection,
  struct math_c_vector3_float* position,
  struct math_c_vector3_float* rotation,
  struct math_c_vector3_float* position_player,
  struct metil_camera* metil_camera
) {
  metil_positioning_view_model_matrix_projection_with_offsets_set(
    positioning,
    view_model_matrix_projection,
    matrix_projection_static,
    matrix_object_projection,
    matrix_player_projection,
    position,
    rotation,
    position_player,
    (void*) 0,
    (void*) 0,
    metil_camera
  );
}

void metil_positioning_view_model_matrix_projection_with_offsets_set(
  enum metil_positioning positioning,
  matrix_float4x4* view_model_matrix_projection,
  matrix_float3x4* matrix_projection_static,
  matrix_float4x4* matrix_object_projection,
  matrix_float4x4* matrix_player_projection,
  struct math_c_vector3_float* position,
  struct math_c_vector3_float* rotation,
  struct math_c_vector3_float* position_player,
  struct math_c_vector3_float* position_offset,
  struct math_c_vector3_float* rotation_offset,
  struct metil_camera* metil_camera
) {
  if (
    positioning == metil_positioning_absolute
  ) {
    if (
      position_offset != (void*) 0
    ) {
      *view_model_matrix_projection = (matrix_float4x4) {{
        { 1.0f, 0.0f, 0.0f, 0.0f },
        { 0.0f, 1.0f, 0.0f, 0.0f },
        { 0.0f, 0.0f, 1.0f, 0.0f },
        { (
            position->x +
            position_offset->x
          ), (
            position->y +
            position_offset->y
          ), (
            position->z +
            position_offset->z
          ),
          1.0f
        }
      }};
    } else {
      *view_model_matrix_projection = (matrix_float4x4) {{
        { 1.0f, 0.0f, 0.0f, 0.0f },
        { 0.0f, 1.0f, 0.0f, 0.0f },
        { 0.0f, 0.0f, 1.0f, 0.0f },
        {
          position->x,
          position->y,
          position->z,
          1.0f
        }
      }};
    }
  } else if (
    positioning == metil_positioning_static
  ) {
    if (
      position_offset != (void*) 0
    ) {
      *view_model_matrix_projection = (matrix_float4x4) {{
        matrix_projection_static->columns[0],
        matrix_projection_static->columns[1],
        matrix_projection_static->columns[2],
        { (
            position->x +
            position_offset->x
          ), (
            position->y +
            position_offset->y
          ), (
            position->z +
            position_offset->z
          ),
          1.0f
        }
      }};
    } else {
      *view_model_matrix_projection = (matrix_float4x4) {{
        matrix_projection_static->columns[0],
        matrix_projection_static->columns[1],
        matrix_projection_static->columns[2],
        {
          position->x,
          position->y,
          position->z,
          1.0f
        }
      }};
    }
  } else {
    struct math_c_vector3_float position_translated;

    if (
      position_offset != (void*) 0
    ) {
      position_translated.x = (
        position_offset->x -
        position_player->x
      );

      position_translated.y = (
        position_offset->y -
        position_player->y -
        metil_camera->height
      );

      position_translated.z = (
        position_offset->z -
        position_player->z
      );
    } else {
      position_translated.x = -position_player->x;
      position_translated.y = (
        -position_player->y -
        metil_camera->height
      );
      position_translated.z = -position_player->z;
    }

    matrix_float4x4* matrix_projection = (void*) 0;

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
          position->x,
          position->y,
          position->z,
          1.0f
        }
      }},
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
        { 1.0f, 0.0f, 0.0f, 0.0f },
        { 0.0f, cos(rotation->x), -sin(rotation->x), 0.0f },
        { 0.0f, sin(rotation->x), cos(rotation->x), 0.0f },
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

    matrix_float4x4 matrix_projection_object_offset_with_rotation = {{
      { 1.0f, 0.0f, 0.0f, 0.0f },
      { 0.0f, 1.0f, 0.0f, 0.0f },
      { 0.0f, 0.0f, 1.0f, 0.0f },
      {
        position_translated.x,
        position_translated.y,
        position_translated.z,
        1.0f
      }
    }};

    if (
      rotation_offset != (void*)0
    ) {
      matrix_projection_object_offset_with_rotation = matrix_multiply(
        matrix_projection_object_offset_with_rotation,
        (matrix_float4x4) {{
          { cos(rotation_offset->y), 0.0f, -sin(rotation_offset->y), 0.0f },
          { 0.0f, 1.0f, 0.0f, 0.0f },
          { sin(rotation_offset->y), 0.0f, cos(rotation_offset->y), 0.0f },
          { 0.0f, 0.0f, 0.0f, 1.0f }
        }}
      );

      matrix_projection_object_offset_with_rotation = matrix_multiply(
        matrix_projection_object_offset_with_rotation,
        (matrix_float4x4) {{
          { 1.0f, 0.0f, 0.0f, 0.0f },
          { 0.0f, cos(rotation_offset->x), -sin(rotation_offset->x), 0.0f },
          { 0.0f, sin(rotation_offset->x), cos(rotation_offset->x), 0.0f },
          { 0.0f, 0.0f, 0.0f, 1.0f }
        }}
      );

      matrix_projection_object_offset_with_rotation = matrix_multiply(
        matrix_projection_object_offset_with_rotation,
        (matrix_float4x4) {{
          { cos(rotation_offset->z), -sin(rotation_offset->z), 0.0f, 0.0f },
          { sin(rotation_offset->z), cos(rotation_offset->z), 0.0f, 0.0f },
          { 0.0f, 0.0f, 1.0f, 0.0f },
          { 0.0f, 0.0f, 0.0f, 1.0f }
        }}
      );

      *view_model_matrix_projection = matrix_multiply(
        matrix_projection_object_offset_with_rotation,
        matrix_projection_object_with_rotation
      );

      *view_model_matrix_projection = matrix_multiply(
        *matrix_projection,
        *view_model_matrix_projection
      );
    } else {
      *view_model_matrix_projection = matrix_multiply(
        matrix_projection_object_offset_with_rotation,
        matrix_projection_object_with_rotation
      );

      *view_model_matrix_projection = matrix_multiply(
        *matrix_projection,
        *view_model_matrix_projection
      );
    }
  }

  if (
    positioning == metil_positioning_absolute ||
    positioning == metil_positioning_static
  ) {
    *view_model_matrix_projection = matrix_multiply(
      *view_model_matrix_projection,
      (matrix_float4x4) {{
        { cos(rotation->y), 0.0f, -sin(rotation->y), 0.0f },
        { 0.0f, 1.0f, 0.0f, 0.0f },
        { sin(rotation->y), 0.0f, cos(rotation->y), 0.0f },
        { 0.0f, 0.0f, 0.0f, 1.0f }
      }}
    );

    *view_model_matrix_projection = matrix_multiply(
      *view_model_matrix_projection,
      (matrix_float4x4) {{
        { 1.0f, 0.0f, 0.0f, 0.0f },
        { 0.0f, cos(rotation->x), -sin(rotation->x), 0.0f },
        { 0.0f, sin(rotation->x), cos(rotation->x), 0.0f },
        { 0.0f, 0.0f, 0.0f, 1.0f }
      }}
    );

    *view_model_matrix_projection = matrix_multiply(
      *view_model_matrix_projection,
      (matrix_float4x4) {{
        { cos(rotation->z), -sin(rotation->z), 0.0f, 0.0f },
        { sin(rotation->z), cos(rotation->z), 0.0f, 0.0f },
        { 0.0f, 0.0f, 1.0f, 0.0f },
        { 0.0f, 0.0f, 0.0f, 1.0f }
      }}
    );
  }
}
