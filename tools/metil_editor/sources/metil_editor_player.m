#include <metil_editor_player.h>

#include <metil_editor_scene_data.h>

#include <metil.h>
#include <metil_player/metil_player.h>
#include <metil_scenes/metil_scene_controller.h>

void metil_editor_player_poll_input(
  struct metil* metil,
  struct metil_player* metil_player,
  unsigned long int time,
  unsigned long int time_delta
) {
  struct metil_scene_controller* metil_scene_controller = (
    metil->scene_controller
  );
  
  struct metil_editor_scene_data* metil_editor_scene_data = (
    metil_scene_controller->scene.data
  );

  if (
    metil_editor_scene_data->movement_free ==
    0x00
  ) {
    struct math_c_vector2_float delta_cursor = {
      .x = (
        metil->input.cursor.delta.x
      ),
      .y = (
        metil->input.cursor.delta.y
      )
    };
    
    metil->input.cursor.delta.x = (
      0x00
    );
    
    metil->input.cursor.delta.y = (
      0x00
    );
    
    metil_player_poll_input_free_flying_locked(
      metil,
      metil_player,
      time,
      time_delta
    );
    
    metil->input.cursor.delta.x = (
      delta_cursor.x
    );
    
    metil->input.cursor.delta.y = (
      delta_cursor.y
    );
  } else {
    metil_player_poll_input_free_flying_locked(
      metil,
      metil_player,
      time,
      time_delta
    );
  }
}

