#include <3d_rendering_textures/3d_rendering_texture_ground.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

id<MTLTexture> metil_example_3d_rendering_texture_ground_generate(
  id<MTLDevice> metal_device
) {
  static id<MTLTexture> metil_example_3d_rendering_texture_ground;

  return (
    metil_example_3d_rendering_texture_ground
  );
}

