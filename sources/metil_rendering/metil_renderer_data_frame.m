#include <metil_rendering/metil_renderer_data_frame.h>

#include <metil.h>
#include <metil_scenes/metil_scene.h>
#include <metil_scenes/metil_scene_controller.h>

void metil_renderer_data_frame_poll(
  struct metil* metil,
  void* metil_renderer_data_frame_parameter,
  unsigned int index_poll_frame
) {
  struct metil_renderer_data_frame* metil_renderer_data_frame = (
    metil_renderer_data_frame_parameter
  );

  struct metil_scene_controller* metil_scene_controller = (
    metil->scene_controller
  );

  struct metil_scene* metil_scene = (
    &metil_scene_controller->scene
  );

  struct metil_player* metil_player = (
    &metil_scene->player
  );

  metil_renderer_data_frame->frame = (
    index_poll_frame
  );

  metil_renderer_data_frame->time = (
    metil_scene->time
  );

  metil_renderer_data_frame->time_elapsed = (
    metil_scene->time_elapsed
  );

  metil_renderer_data_frame->time_delta = (
    metil_scene->time_delta
  );

  metil_renderer_data_frame->rotation_camera.x = (
    metil_player->rotation.x
  );

  metil_renderer_data_frame->rotation_camera.y = (
    metil_player->rotation.y
  );

  metil_renderer_data_frame->rotation_camera.z = (
    metil_player->rotation.z
  );

  metil_renderer_data_frame->position_player.x = (
    metil_player->position.x
  );

  metil_renderer_data_frame->position_player.y = (
    metil_player->position.y
  );

  metil_renderer_data_frame->position_player.z = (
    metil_player->position.z
  );

  metil_renderer_data_frame->brightness = (
    metil->rendering_properties.brightness
  );

  metil_renderer_data_frame->brightness_text = (
    metil->rendering_properties.brightness_text
  );

  metil_renderer_data_frame->size_viewport.x = (
    metil->renderer_interface.size.x
  );

  metil_renderer_data_frame->size_viewport.y = (
    metil->renderer_interface.size.y
  );
}
