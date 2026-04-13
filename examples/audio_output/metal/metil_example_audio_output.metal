#include <metil_example_audio_output_metal.h>

#include <math_c_absolute.h>

#include <metil_metal/basic_3d_shaders.h>

#include <metil_metal/metil_metal_data_vertex.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

[[vertex]] struct data_vertex_basic_coloured metil_example_audio_output_vertex(
  const device float4* vertices [[
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
  unsigned int id_vertex [[vertex_id]]
) {
  struct data_vertex_basic_coloured data_vertex_basic_coloured;

  data_vertex_basic_coloured.position = (
    data_object->view_model_matrix_projection *
    vertices[
      id_vertex
    ]
  );

  data_vertex_basic_coloured.colour = (
    float4(
      (
        data_object->colour.x *
        data_frame->brightness *
        (
          1.0f -
          math_c_absolute_float(
            vertices[
              id_vertex
            ].y
          )
        )
      ),
      0x00,      (
        data_object->colour.z *
        data_frame->brightness *        math_c_absolute_float(
          vertices[
            id_vertex
          ].y
        )
      ),
      data_object->colour.w
    )
  );

  return data_vertex_basic_coloured;
}

[[fragment]] float4 metil_example_audio_output_fragment(
  struct data_vertex_basic_coloured data_vertex_basic_coloured [[stage_in]]
) {
  return (
    data_vertex_basic_coloured.colour
  );
}
