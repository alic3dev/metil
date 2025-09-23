#include <example_2d_rendering.h>

#include <example_2d_scene.h>

#include <metil_initialize.h>
#include <metil_library.h>
#include <metil_player.h>
#include <metil_rendering/rendering_properties.h>
#include <metil_scenes/scene.h>
#include <metil_scenes/scene_controller.h>

int main(
  int length_parameters,
  const char** parameters
) {
  return metil_initialize(
    length_parameters,
    parameters,
    "example_2d_rendering",
    example_2d_rendering_renderer_on_initialize
  );
}


void example_2d_rendering_renderer_on_initialize(
  id<MTLDevice> metil_metal_kit_device,
  struct metil_rendering_properties* metil_rendering_properties
) {
  metil_library.library = [metil_metal_kit_device newDefaultLibrary];

  metil_library.function_vertex = [
    metil_library.library
    newFunctionWithName: @"shader_2d_vertex"
  ];

  metil_library.function_fragment = [
    metil_library.library
    newFunctionWithName: @"shader_2d_fragment"
  ];

  metil_rendering_properties->camera.height = 0.0f;

  metil_rendering_properties->color_clear.w = 1.0f;

  example_2d_scene_initialize(
    &metil_scene_controller.scene,
    metil_metal_kit_device
  );

  metil_scene_controller.scene.data = metil_rendering_properties;
}
