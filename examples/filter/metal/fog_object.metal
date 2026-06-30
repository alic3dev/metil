#include <example_fog_values.h>

#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>

struct data_vertex {
  float4 position [[position]];
  float4 colour;
  float brightness;
  float distance;
};

[[vertex]] struct data_vertex fog_object_vertex(
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
  unsigned int id_vertex [[vertex_id]]
) {
  struct data_vertex data_vertex;

  data_vertex.position = (
    data_object->view_model_matrix_projection *
    vertices[id_vertex]
  );

  data_vertex.colour = float4(
    metal::fmod(
      data_object->colour.x * (float) (
        id_vertex +
        4234.23842398
      ),
      1.0f
    ),
    metal::fmod(
      data_object->colour.y * (float) (
        id_vertex +
        1489.8924489
      ),
      1.0f
    ),
    metal::fmod(
      data_object->colour.z * (float) (
        id_vertex +
        1.3892810472
      ),
      1.0f
    ),
    data_object->colour.w
  );

  data_vertex.brightness = (
    (vertices[id_vertex].z + data_object->size.z / 2.0f) /
    (data_object->size.z)
  );

  data_vertex.distance = (
    metal::distance(
      float3(
        data_frame->position_player.x,
        data_frame->position_player.y,
        data_frame->position_player.z
      ),
      float3(
        data_object->position.x,
        data_object->position.y,
        data_object->position.z
      )
    )
  );

  return data_vertex;
}

float4 fog_apply(
  float4 colour,
  float distance
) {
  float distance_offset = metal::fmin(
    metal::fmax(
      (
        distance -
        fog_distance_minimum
      ),
      0.0f
    ),
    fog_distance_maximum
  );

  float distance_percentage = (
    distance_offset /
    fog_distance_maximum
  );

  float fog_thickness = (
    distance_percentage *
    fog_thickness_range +
    fog_thickness_minimum
  );

  return float4(
    metal::fmin(
      (
        colour.r +
        fog_thickness
      ),
      1.0f
    ),
    metal::fmin(
      (
        colour.g +
        fog_thickness
      ),
      1.0f
    ),
    metal::fmin(
      (
        colour.b +
        fog_thickness
      ),
      1.0f
    ),
    colour.a
  );
}

[[fragment]] float4 fog_object_fragment(
  struct data_vertex data_vertex [[stage_in]]
) {
  float4 colour_lighted = float4(
    data_vertex.colour.r * data_vertex.brightness,
    data_vertex.colour.g * data_vertex.brightness,
    data_vertex.colour.b * data_vertex.brightness,
    data_vertex.colour.a
  );

  float4 colour_fogged = fog_apply(
    colour_lighted,
    data_vertex.distance
  );

  return colour_fogged;
}
