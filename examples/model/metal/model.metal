#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>
#include <metil_rendering/metil_renderer_data_model_object.h>

struct data_vertex {
  float4 position [[position]];
  float4 color;
};

[[vertex]] struct data_vertex model_vertex(
  const device simd_float4* vertices [[
    buffer(
      metil_renderer_vertex_index_parameter_vertices
    )
  ]],
  constant struct metil_renderer_data_frame* data_frame [[
    buffer(
      metil_renderer_vertex_index_parameter_data_frame
    )
  ]],
  constant struct metil_renderer_data_model_object* data_object [[
    buffer(
      metil_renderer_vertex_index_parameter_data_object
    )
  ]],
  constant unsigned int* vertex_joint_map [[
    buffer(
      metil_renderer_vertex_index_parameter_vertex_joint_map
    )
  ]],
  constant struct clic3_vector3_float* joints [[
    buffer(
      metil_renderer_vertex_index_parameter_joints
    )
  ]],
  unsigned int id_vertex [[vertex_id]]
) {
  struct data_vertex data_vertex;

  unsigned int id_joint_position = (
    vertex_joint_map[
      id_vertex
    ] *
    3
  );

  unsigned int id_joint_translation = (
    id_joint_position +
    1
  );

  unsigned int id_joint_rotation = (
    id_joint_translation +
    1
  );

  matrix_float4x4 matrix_projection_object_with_rotation = (
    (matrix_float4x4) {{
      { metal::cos(joints[id_joint_rotation].y), 0.0f, -metal::sin(joints[id_joint_rotation].y), 0.0f },
      { 0.0f, 1.0f, 0.0f, 0.0f },
      { metal::sin(joints[id_joint_rotation].y), 0.0f, metal::cos(joints[id_joint_rotation].y), 0.0f },
      { 0.0f, 0.0f, 0.0f, 1.0f }
    }} *
    (matrix_float4x4) {{
      { 1.0f, 0.0f, 0.0f, 0.0f },
      { 0.0f, metal::cos(joints[id_joint_rotation].x), -metal::sin(joints[id_joint_rotation].x), 0.0f },
      { 0.0f, metal::sin(joints[id_joint_rotation].x), metal::cos(joints[id_joint_rotation].x), 0.0f },
      { 0.0f, 0.0f, 0.0f, 1.0f }
    }} *
    (matrix_float4x4) {{
      { metal::cos(joints[id_joint_rotation].z), -metal::sin(joints[id_joint_rotation].z), 0.0f, 0.0f },
      { metal::sin(joints[id_joint_rotation].z), metal::cos(joints[id_joint_rotation].z), 0.0f, 0.0f },
      { 0.0f, 0.0f, 1.0f, 0.0f },
      { 0.0f, 0.0f, 0.0f, 1.0f }
    }}
  );
  
  float4 l = (
    (
      (
        (
          (float4) {
            vertices[id_vertex].x,
            vertices[id_vertex].y,
            vertices[id_vertex].z,
            vertices[id_vertex].w
          } + (float4) {
            data_object->position.x,
            data_object->position.y,
            data_object->position.z,
            0.0f
          }
        ) - (float4) {
          joints[id_joint_position].x,
          joints[id_joint_position].y,
          joints[id_joint_position].z,
          0.0f
        }
      ) * matrix_projection_object_with_rotation 
    ) + (float4) {
      joints[id_joint_position].x,
      joints[id_joint_position].y,
      joints[id_joint_position].z,
      0.0f
    } + (float4) {
      joints[id_joint_translation].x,
      joints[id_joint_translation].y,
      joints[id_joint_translation].z,
      0.0f
    } - (float4) {
      data_object->position.x,
      data_object->position.y,
      data_object->position.z,
      0.0f
    }
  );

  data_vertex.position = (
    data_object->view_model_matrix_projection *
    l
  );

  float brightness = 1.0f;

  data_vertex.color = float4(
    1.0f * brightness,
    1.0f * brightness,
    1.0f * brightness,
    1.0f
  );

  return data_vertex;
}

[[fragment]] float4 model_fragment(
  struct data_vertex data_vertex [[stage_in]]
) {
  return data_vertex.color;
}
