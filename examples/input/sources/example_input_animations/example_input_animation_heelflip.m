#include <example_input_animations/example_input_animation_heelflip.h>

#include <example_input_data.h>
#include <example_input_stance.h>

#include <math_c_pi.h>

#include <metil_animation/metil_animation.h>
#include <metil_model/metil_model.h>
#include <metil_rendering/metil_renderable_type.h>
#include <metil_scenes/metil_scene.h>

void example_input_animation_heelflip(
  struct metil_animation* metil_animation,
  enum metil_renderable_type metil_renderable_type,
  void* data,
  float progress
) {
  struct metil_scene* scene = (
    data
  );

  struct example_input_data* example_input_data = (
    scene->data
  );

  struct metil_model* metil_model_player = (
    scene->renderables[
      0x01
    ].renderable
  );

  struct metil_model* metil_model_skateboard = (
    scene->renderables[
      0x02
    ].renderable
  );

  metil_model_skateboard->rotation.z = (
    progress *
    (
      (
        example_input_data->stance ==
        example_input_stance_goofy
      )
      ? -0x01
      :  0x01
    ) *
    math_c_pi_doubled
  );
}
