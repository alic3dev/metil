#include <example_2d_rendering.h>

#include <example_2d_scene.h>

#include <metil_initialize.h>
#include <metil_library.h>
#include <metil_rendering/metil_renderer_interface.h>
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
  struct metil_renderer_interface* metil_renderer_interface,
  void* data
) {
  metil_library.library = [
    metil_renderer_interface->metal_device
    newDefaultLibrary
  ];

  metil_library.function_vertex = [
    metil_library.library
    newFunctionWithName: @"shader_2d_vertex"
  ];

  metil_library.function_fragment = [
    metil_library.library
    newFunctionWithName: @"shader_2d_fragment"
  ];

  metil_library_fps_display_initialize(
    metil_renderer_interface->metal_device,
    (void*)0
  );

  metil_renderer_interface->rendering_properties->color_clear.x = 0.0f;
  metil_renderer_interface->rendering_properties->color_clear.y = 0.0f;
  metil_renderer_interface->rendering_properties->color_clear.z = 0.0f;
  metil_renderer_interface->rendering_properties->color_clear.w = 1.0f;

  example_2d_scene_initialize(
    &metil_scene_controller.scene,
    metil_renderer_interface->metal_device
  );
}
