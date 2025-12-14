#include <example_face_scene.h>

#include <metil_mesh/mesh_box.h>
#include <metil_object.h>
#include <metil_player.h>
#include <metil_rendering/metil_renderable.h>
#include <metil_rendering/metil_renderer_data_object.h>
#include <metil_scenes/scene.h>

#include <clic3_vector.h>

#include <Metal/MTLDevice.h>

#include <math.h>
#include <stdlib.h>

void example_face_scene_initialize(
  struct metil_scene* scene,
  struct metil_renderer_interface* metil_renderer_interface
) {
  metil_scene_initialize_with_renderables(
    scene,
    metil_renderer_interface,
    0
  );

  scene->poll = example_face_scene_poll;
}

void example_face_scene_poll(
  struct metil_scene* scene
) {
  metil_scene_poll_default(
    scene
  );
}
