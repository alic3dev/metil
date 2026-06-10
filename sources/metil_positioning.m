#include <metil_positioning.h>

#include <metil_rendering/metil_camera/metil_camera.h>
#include <metil_rendering/metil_camera/metil_camera_mode.h>
#include <metil_scenes/metil_scene_controller.h>

#include <math_c_pi.h>
#include <math_c_sine.h>
#include <math_c_vector.h>

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
    0x00,
    0x00,
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
    positioning ==
    metil_positioning_absolute
  ) {
    if (
      position_offset !=
      0x00
    ) {
      *view_model_matrix_projection = (
        (matrix_float4x4)
        {{
          {
            0x01,
            0x00,
            0x00,
            0x00
          },
          {
            0x00,
            0x01,
            0x00,
            0x00
          },
          {
            0x00,
            0x00,
            0x01,
            0x00
          },
          {
            (
              position->x +
              position_offset->x
            ),
            (
              position->y +
              position_offset->y
            ),
            (
              position->z +
              position_offset->z
            ),
            0x01
          }
        }}
      );
    } else {
      *view_model_matrix_projection = (
        (matrix_float4x4)
        {{
          {
            0x01,
            0x00,
            0x00,
            0x00
          },
          {
            0x00,
            0x01,
            0x00,
            0x00
          },
          {
            0x00,
            0x00,
            0x01,
            0x00
          },
          {
            position->x,
            position->y,
            position->z,
            0x01
          }
        }}
      );
    }
  } else if (
    positioning ==
    metil_positioning_static
  ) {
    if (
      position_offset !=
      0x00
    ) {
      *view_model_matrix_projection = (
        (matrix_float4x4)
        {{
          matrix_projection_static->columns[
            0x00
          ],
          matrix_projection_static->columns[
            0x01
          ],
          matrix_projection_static->columns[
            0x02
          ],
          {
            (
              position->x +
              position_offset->x
            ),
            (
              position->y +
              position_offset->y
            ),
            (
              position->z +
              position_offset->z
            ),
            0x01
          }
        }}
      );
    } else {
      *view_model_matrix_projection = (
        (matrix_float4x4)
        {{
          matrix_projection_static->columns[
            0x00
          ],
          matrix_projection_static->columns[
            0x01
          ],
          matrix_projection_static->columns[
            0x02
          ],
          {
            position->x,
            position->y,
            position->z,
            0x01
          }
        }}
      );
    }
  } else {
    struct math_c_vector3_float position_translated;

    if (
      position_offset !=
      0x00
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
      position_translated.x = -(
        position_player->x
      );

      position_translated.y = (
        -position_player->y -
        metil_camera->height
      );

      position_translated.z = -(
        position_player->z
      );
    }

    matrix_float4x4* matrix_projection = (
      0x00
    );

    if (
      positioning ==
      metil_positioning_player
    ) {
      matrix_projection = (
        matrix_player_projection
      );
    } else {
      matrix_projection = (
        matrix_object_projection
      );
    }

    matrix_float4x4 matrix_projection_object_with_rotation = (
      matrix_multiply(
        (matrix_float4x4)
        {{
          {
            0x01,
            0x00,
            0x00,
            0x00
          },
          {
            0x00,
            0x01,
            0x00,
            0x00
          },
          {
            0x00,
            0x00,
            0x01,
            0x00
          },
          {
            position->x,
            position->y,
            position->z,
            0x01
          }
        }},
        (matrix_float4x4)
        {{
          {
            math_c_cosine(
              rotation->y,
              math_c_pi
            ),
            0x00,
            -math_c_sine(
              rotation->y,
              math_c_pi
            ),
            0x00
          },
          {
            0x00,
            0x01,
            0x00,
            0x00
          },
          {
            math_c_sine(
              rotation->y,
              math_c_pi
            ),
            0x00,
            math_c_cosine(
              rotation->y,
              math_c_pi
            ),
            0x00
          },
          {
            0x00,
            0x00,
            0x00,
            0x01
          }
        }}
      )
    );

    matrix_projection_object_with_rotation = (
      matrix_multiply(
        matrix_projection_object_with_rotation,
        (matrix_float4x4)
        {{
          {
            0x01,
            0x00,
            0x00,
            0x00
          },
          {
            0x00,
            math_c_cosine(
              rotation->x,
              math_c_pi
            ),
            -math_c_sine(
              rotation->x,
              math_c_pi
            ),
            0x00
          },
          {
            0x00,
            math_c_sine(
              rotation->x,
              math_c_pi
            ),
            math_c_cosine(
              rotation->x,
              math_c_pi
            ),
            0x00
          },
          {
            0x00,
            0x00,
            0x00,
            0x01
          }
        }}
      )
    );

    matrix_projection_object_with_rotation = (
      matrix_multiply(
        matrix_projection_object_with_rotation,
        (matrix_float4x4)
        {{
          {
            math_c_cosine(
              rotation->z,
              math_c_pi
            ),
            -math_c_sine(
              rotation->z,
              math_c_pi
            ),
            0x00,
            0x00
          },
          {
            math_c_sine(
              rotation->z,
              math_c_pi
            ),
            math_c_cosine(
              rotation->z,
              math_c_pi
            ),
            0x00,
            0x00
          },
          {
            0x00,
            0x00,
            0x01,
            0x00
          },
          {
            0x00,
            0x00,
            0x00,
            0x01
          }
        }}
      )
    );

    matrix_float4x4 matrix_projection_object_offset_with_rotation = {{
      {
        0x01,
        0x00,
        0x00,
        0x00
      },
      {
        0x00,
        0x01,
        0x00,
        0x00
      },
      {
        0x00,
        0x00,
        0x01,
        0x00
      },
      {
        position_translated.x,
        position_translated.y,
        position_translated.z,
        0x01
      }
    }};

    if (
      rotation_offset !=
      0x00
    ) {
      matrix_projection_object_offset_with_rotation = (
        matrix_multiply(
          matrix_projection_object_offset_with_rotation,
          (matrix_float4x4)
          {{
            {
              math_c_cosine(
                rotation_offset->y,
                math_c_pi
              ),
              0x00,
              -math_c_sine(
                rotation_offset->y,
                math_c_pi
              ),
              0x00
            },
            {
              0x00,
              0x01,
              0x00,
              0x00
            },
            {
              math_c_sine(
                rotation_offset->y,
                math_c_pi
              ),
              0x00,
              math_c_cosine(
                rotation_offset->y,
                math_c_pi
              ),
              0x00
            },
            {
              0x00,
              0x00,
              0x00,
              0x01
            }
          }}
        )
      );

      matrix_projection_object_offset_with_rotation = (
        matrix_multiply(
          matrix_projection_object_offset_with_rotation,
          (matrix_float4x4)
          {{
            {
              0x01,
              0x00,
              0x00,
              0x00
            },
            {
              0x00,
              math_c_cosine(
                rotation_offset->x,
                math_c_pi
              ),
              -math_c_sine(
                rotation_offset->x,
                math_c_pi
              ),
              0x00
            },
            {
              0x00,
              math_c_sine(
                rotation_offset->x,
                math_c_pi
              ),
              math_c_cosine(
                rotation_offset->x,
                math_c_pi
              ),
              0x00
            },
            {
              0x00,
              0x00,
              0x00,
              0x01
            }
          }}
        )
      );

      matrix_projection_object_offset_with_rotation = (
        matrix_multiply(
          matrix_projection_object_offset_with_rotation,
          (matrix_float4x4)
          {{
            {
              math_c_cosine(
                rotation_offset->z,
                math_c_pi
              ),
              -math_c_sine(
                rotation_offset->z,
                math_c_pi
              ),
              0x00,
              0x00
            },
            {
              math_c_sine(
                rotation_offset->z,
                math_c_pi
              ),
              math_c_cosine(
                rotation_offset->z,
                math_c_pi
              ),
              0x00,
              0x00
            },
            {
              0x00,
              0x00,
              0x01,
              0x00
            },
            {
              0x00,
              0x00,
              0x00,
              0x01
            }
          }}
        )
      );

      *view_model_matrix_projection = (
        matrix_multiply(
          matrix_projection_object_offset_with_rotation,
          matrix_projection_object_with_rotation
        )
      );

      *view_model_matrix_projection = (
        matrix_multiply(
          *matrix_projection,
          *view_model_matrix_projection
        )
      );
    } else {
      *view_model_matrix_projection = (
        matrix_multiply(
          matrix_projection_object_offset_with_rotation,
          matrix_projection_object_with_rotation
        )
      );

      *view_model_matrix_projection = (
        matrix_multiply(
          *matrix_projection,
          *view_model_matrix_projection
        )
      );
    }
  }

  if (
    (
      positioning ==
      metil_positioning_absolute
    ) ||
    (
      positioning ==
      metil_positioning_static
    )
  ) {
    *view_model_matrix_projection = (
      matrix_multiply(
        *view_model_matrix_projection,
        (matrix_float4x4)
        {{
          {
            math_c_cosine(
              rotation->y,
              math_c_pi
            ),
            0x00,
            -math_c_sine(
              rotation->y,
              math_c_pi
            ),
            0x00
          },
          {
            0x00,
            0x01,
            0x00,
            0x00
          },
          {
            math_c_sine(
              rotation->y,
              math_c_pi
            ),
            0x00,
            math_c_cosine(
              rotation->y,
              math_c_pi
            ),
            0x00
          },
          {
            0x00,
            0x00,
            0x00,
            0x01
          }
        }}
      )
    );

    *view_model_matrix_projection = (
      matrix_multiply(
        *view_model_matrix_projection,
        (matrix_float4x4)
        {{
          {
            0x01,
            0x00,
            0x00,
            0x00
          },
          {
            0x00,
            math_c_cosine(
              rotation->x,
              math_c_pi
            ),
            -math_c_sine(
              rotation->x,
              math_c_pi
            ),
            0x00
          },
          {
            0x00,
            math_c_sine(
              rotation->x,
              math_c_pi
            ),
            math_c_cosine(
              rotation->x,
              math_c_pi
            ),
            0x00
          },
          {
            0x00,
            0x00,
            0x00,
            0x01
          }
        }}
      )
    );

    *view_model_matrix_projection = (
      matrix_multiply(
        *view_model_matrix_projection,
        (matrix_float4x4)
        {{
          {
            math_c_cosine(
              rotation->z,
              math_c_pi
            ),
            -math_c_sine(
              rotation->z,
              math_c_pi
            ),
            0x00,
            0x00
          },
          {
            math_c_sine(
              rotation->z,
              math_c_pi
            ),
            math_c_cosine(
              rotation->z,
              math_c_pi
            ),
            0x00,
            0x00
          },
          {
            0x00,
            0x00,
            0x01,
            0x00
          },
          {
            0x00,
            0x00,
            0x00,
            0x01
          }
        }}
      )
    );
  }
}
