#include <example_3d_rendering.h>

#include <example_3d_scene.h>

#include <metil_initialize.h>
#include <metil_library.h>
#include <metil_rendering/rendering_properties.h>
#include <metil_scenes/scene_controller.h>

int main(
  int length_parameters,
  const char** parameters
) {
  return metil_initialize(
    length_parameters,
    parameters,
    "example_3d_rendering",
    example_3d_rendering_renderer_on_initialize
  );
}

void example_3d_rendering_renderer_on_initialize(
  id<MTLDevice> metal_kit_device,
  struct metil_rendering_properties* metil_rendering_properties,
  void* data
) {
  metil_library.library = [metal_kit_device newDefaultLibrary];

  metil_library.function_vertex = [
    metil_library.library
    newFunctionWithName: @"shader_3d_vertex"
  ];

  metil_library.function_fragment = [
    metil_library.library
    newFunctionWithName: @"shader_3d_fragment"
  ];

  metil_library_initialize_fps_display(
    metal_kit_device,
    (void*)0
  );

  metil_rendering_properties->color_clear.x = 0.0f;
  metil_rendering_properties->color_clear.y = 0.0f;
  metil_rendering_properties->color_clear.z = 0.0f;
  metil_rendering_properties->color_clear.w = 1.0f;

  metil_rendering_properties->camera.height = 0.0f;

  example_3d_scene_initialize(
    &metil_scene_controller.scene,
    metal_kit_device
  );
}
