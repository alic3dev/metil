#include <metil_metal/metil_metal_data_vertex.h>

#include <metal_texture>

kernel void metil_example_filter_compute(
  metal::texture2d<
    float,
    metal::access::read_write
  > texture [[
    texture(
      0x00
    )
  ]],
  metal::texture2d<
    float,
    metal::access::read_write
  > texture_output [[
    texture(
      0x01
    )
  ]],
  unsigned int index[[
    thread_position_in_grid
  ]]
) {
  ushort2 l = (
    ushort2(
      (
        index %
        texture.get_width()
      ),
      (
        index /
        texture.get_width()
      )
    )
  );

  float4 j = (
    texture.read(
      ushort2(
        (l.x * 0x2) % texture.get_width(),
        (l.y * 0x2) % texture.get_height()
      )
    )
  );

  float4 r = (
    texture.read(
      ushort2(
        (l.x * 0x8) % texture.get_width(),
        (l.y * 0x8) % texture.get_height()
      )
    )
  );

  float4 q = (
    j *
    r *
    texture.read(
      l
    )
  );

  q.w = (
    0x01
  );

  while (
    q.x >
    0x01
  ) {
    q.x = (
      q.x -
      0x01
    );
  }

  while (
    q.y >
    0x01
  ) {
    q.y = (
      q.y -
      0x01
    );
  }

  while (
    q.z >
    0x01
  ) {
    q.z = (
      q.z -
      0x01
    );
  }

  texture_output.write(
    q,
    l,
    0x00
  );
}

kernel void metil_example_filter_second_compute(
  metal::texture2d<
    float,
    metal::access::read_write
  > texture [[
    texture(
      0x00
    )
  ]],
  metal::texture2d<
    float,
    metal::access::read_write
  > texture_output [[
    texture(
      0x01
    )
  ]],
  unsigned int index[[
    thread_position_in_grid
  ]]
) {
  ushort2 l = (
    ushort2(
      (
        index %
        texture.get_width()
      ),
      (
        index /
        texture.get_width()
      )
    )
  );

  float4 q = (
    texture.read(
      l
    )
  );

  q = (
    0x01 -
    q
  );

  q.w = (
    0x01
  );

  texture_output.write(
    q,
    l,
    0x00
  );
}
