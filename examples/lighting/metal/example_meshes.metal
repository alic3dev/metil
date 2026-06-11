#include <metil_metal/basic_3d_shaders.h>

#include <metil_metal/metil_metal_data_vertex.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_texture>

struct data_vertex {
  float4 position [[position]];
  float3 position_raw;
  float4 colour;
};

[[vertex]] struct data_vertex shader_example_meshes_vertex(
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
  constant struct metil_renderer_data_object* data_object [[
    buffer(
      metil_renderer_vertex_index_parameter_data_object
    )
  ]],
  unsigned int index_vertex [[
    vertex_id
  ]]
) {
  struct data_vertex data_vertex;

  data_vertex.position = (
    data_object->view_model_matrix_projection *
    vertices[
      index_vertex
    ]
  );

  data_vertex.colour = (
    float4(
      (
        data_object->colour.x *
        data_frame->brightness
      ),
      (
        data_object->colour.y *
        data_frame->brightness
      ),
      (
        data_object->colour.z *
        data_frame->brightness
      ),
      data_object->colour.w
    )
  );
  
  data_vertex.position_raw.x = data_object->position.x + vertices[index_vertex].x;
  data_vertex.position_raw.y = data_object->position.y + vertices[index_vertex].y;
  data_vertex.position_raw.z = data_object->position.z + vertices[index_vertex].z;
 
  return (
    data_vertex
  );
}

[[fragment]] float4 shader_example_meshes_fragment(
  struct data_vertex data_vertex [[
    stage_in
  ]],
  metal::texture3d<float> texture_lighting [[
    texture(
      0x00
    )
  ]],
  metal::texture3d<float> texture_shadows [[
    texture(
      0x01
    )
  ]]
) {
  constexpr metal::sampler sampler(
    metal::mag_filter::linear
  );
  
  float3 position_texture;
  
  position_texture.x = (
    data_vertex.position_raw.x /
    0x31 +
    1.0
  ) / 2.0;
  
  position_texture.y = (
    data_vertex.position_raw.y /
    0x31 +
    1.0  ) / 2.0;
  
  position_texture.z = (
    data_vertex.position_raw.z /
    0x31 +
    1.0
  ) / 2.0;
  if (
    position_texture.x <
    0x00 ||
    position_texture.y <
    0x00 ||
    position_texture.z <
    0x00
  ) {
    return data_vertex.colour;
  } else {  return (
    data_vertex.colour *
    texture_lighting.sample(
      sampler,
      position_texture
    ) *
    texture_shadows.sample(
      sampler,
      position_texture
    )
  );
  }
}
