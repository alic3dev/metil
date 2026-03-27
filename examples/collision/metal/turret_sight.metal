#include <metil_joint/metil_joint_id_offset.h>
#include <metil_metal/metil_metal_model_object.h>
#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>
#include <metil_rendering/metil_renderer_data_model_object.h>

#include <metal_stdlib>

struct data_vertex {
  float4 position [[position]];
  float4 colour;
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
    metil_model_object_position_calculate(
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

  data_vertex.colour = float4(
    data_object->colour.x,
    data_object->colour.y,
    data_object->colour.z,
    data_object->colour.w
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

  float4 texture_colour = float4(
    texture.sample(
      sampler_texture,
      data_vertex.position_texture
    )
  );

  return float4(
    texture_colour.r * data_vertex.colour.r,
    texture_colour.g * data_vertex.colour.g,
    texture_colour.b * data_vertex.colour.b,
    texture_colour.a * data_vertex.colour.a
  );
}
