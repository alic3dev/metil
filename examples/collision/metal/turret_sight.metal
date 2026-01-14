#include <metil_joint/metil_joint_id_offset.h>
#include <metil_metal/metil_metal_model_object.h>
#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>
#include <metil_rendering/metil_renderer_data_model_object.h>

#include <metal_stdlib>

struct data_vertex {
  float4 position [[position]];
  float4 color;
  float2 position_texture;
};

[[vertex]] struct data_vertex turret_sight_vertex(
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
  constant struct math_c_vector3_float* joints [[
    buffer(
      metil_renderer_vertex_index_parameter_joints
    )
  ]],
  unsigned int id_vertex [[vertex_id]]
) {
  struct data_vertex data_vertex;

  float4 position_vertex = (
    metil_model_object_position_calcluate(
      id_vertex,
      &vertices[
        id_vertex
      ],
      &data_object->position,
      vertex_joint_map,
      joints
    )
  );

  data_vertex.position = (
    data_object->view_model_matrix_projection *
    position_vertex
  );

  data_vertex.color = float4(
    data_object->color.x,
    data_object->color.y,
    data_object->color.z,
    data_object->color.w
  );

  data_vertex.position_texture.x = (
    id_vertex %
    4
  );

  data_vertex.position_texture.y = (
    id_vertex /
    4
  );

  return (
    data_vertex
  );
}

[[fragment]] float4 turret_sight_fragment(
  struct data_vertex data_vertex [[stage_in]],
  metal::texture2d<float> texture [[ texture(0) ]]
) {
  constexpr metal::sampler sampler_texture(
    metal::filter::linear,
    metal::mip_filter::linear,
    metal::t_address::repeat,
    metal::r_address::repeat,
    metal::s_address::repeat
  );

  float4 texture_color = float4(
    texture.sample(
      sampler_texture,
      data_vertex.position_texture
    )
  );

  return float4(
    texture_color.r * data_vertex.color.r,
    texture_color.g * data_vertex.color.g,
    texture_color.b * data_vertex.color.b,
    texture_color.a * data_vertex.color.a
  );
}
