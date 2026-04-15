#include <metil_metal/basic_3d_shaders.h>

#include <metil_metal/metil_metal_data_vertex.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_texture>

[[vertex]] struct data_vertex_basic_textured_coloured example_3d_rendering_door_vertex(
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
  unsigned int index_vertex [[vertex_id]]
) {
  struct data_vertex_basic_textured_coloured data_vertex_basic_coloured;

  data_vertex_basic_coloured.position = (
    data_object->view_model_matrix_projection *
    vertices[
      index_vertex
    ]
  );

  data_vertex_basic_coloured.colour = (
    float4(
      (
        data_frame->brightness *
 
        data_object->colour.x    ),
      (
        data_frame->brightness *
        data_object->colour.y
      ),
      (
        data_frame->brightness *
        data_object->colour.z
      ),
      data_object->colour.w
    )
  );

  data_vertex_basic_coloured.position_texture.x = (  
    (0x28 + vertices[index_vertex].x) / 0x50
  );

  data_vertex_basic_coloured.position_texture.y = (
    (vertices[index_vertex].y) / 0x50
  );

  return data_vertex_basic_coloured;
}

[[fragment]] float4 example_3d_rendering_door_fragment(
  struct data_vertex_basic_textured_coloured data_vertex_basic_coloured [[stage_in]],
  metal::texture2d<float> texture [[texture(0)]]
) {

  constexpr metal::sampler sam(
    metal::mag_filter::nearest
);

  return (
    data_vertex_basic_coloured.colour * texture.sample(sam, data_vertex_basic_coloured.position_texture)
  );
}
