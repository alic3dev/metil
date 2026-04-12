
#include <metil_metal/metil_metal_data_vertex.h>
#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

#include <metal_texture>

[[vertex]] struct data_vertex_basic_textured_coloured metil_example_3d_rendering_sky_vertex(
  constant float4* vertices [[
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
  struct data_vertex_basic_textured_coloured data_vertex_basic_textured_coloured;

  data_vertex_basic_textured_coloured.position = (
    data_object->view_model_matrix_projection *
    vertices[
      index_vertex
    ]      );

  unsigned int index_offset = (
    index_vertex
  );

  float shift = (
    (float)
    data_frame->frame /
    100.0f
  );

  if (
    (
      (unsigned int)
      shift %
      0x02
    ) ==
    0x00
  ) {
    shift = (
      shift -
      (unsigned int)
      (
        shift -
        0x01
      )
    );
  } else {
    shift = (
      shift -
      (unsigned int)
      shift
    );
  } 
  if (
    shift >
    0x02
  ) {
    shift = (
      shift -
      (unsigned int)
      (
        shift -
        0x01
      )
    );
  }
  if (
    shift >
    0x01
  ) {
    shift = (
      1.0f -
      (
        shift -
        0x01
      )
    );
  }

  data_vertex_basic_textured_coloured.colour.x = (
    0.4f
  );

  data_vertex_basic_textured_coloured.colour.y = (
    0.4f +
    shift *
    0.2f
  );

  shift = (
    shift *
    shift
  );

  if (
    shift >
    0x02
  ) {
    shift = (
      shift -
      (unsigned int)
      (
        shift -
        0x01
      )
    );
  }

  if (
    shift >
    0x01
  ) {
    shift = (
      1.0f -
      (
        shift -
        0x01
      )
    );
  }
  data_vertex_basic_textured_coloured.colour.z = (
    0.6f +
    (float)
    (
      index_offset %
      0x06
    ) *
    shift /
    5.0f *
    0.4f
  );

  data_vertex_basic_textured_coloured.colour.w = (
    0x01
  );

  data_vertex_basic_textured_coloured.colour = (
    data_vertex_basic_textured_coloured.colour *
    (
      (float)
      (
        index_offset %
        0x07
      ) /
      6.0f *
      0.3f +
      0.7f
    ) *
    (
      ((((index_vertex + 0x01) + (data_frame->frame / 0x08)) % (0x13 * 0x16 )) == 0x00)
      ? 0x00
      : 0x01
    )
  );

  return (
    data_vertex_basic_textured_coloured
  );
}

[[fragment]] float4 metil_example_3d_rendering_sky_fragment(
  struct data_vertex_basic_textured_coloured data_vertex_basic_textured_coloured [[stage_in]]
  //metal::texture2d<float> texture_sky [[texture(0x00)]]
) {
  float4 colour_output = (
    data_vertex_basic_textured_coloured.colour
  );

  constexpr metal::sampler sampler_texture_sky(
    metal::mag_filter::linear
  );
  /*float4 sample_texture_sky = (
    texture_sky.sample(
      sampler_texture_sky,
      data_vertex_basic_textured_coloured.position_texture
    )
  );
  colour_output = (
    colour_output *
    sample_texture_sky
  );*/
  return (
    colour_output
  );
}
