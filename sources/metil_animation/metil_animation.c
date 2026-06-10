#include <metil_animation/metil_animation.h>

#include <metil_utilities/metil_stopwatch.h>

void metil_animation_initialize(
  struct metil_animation* metil_animation
) {
  metil_animation->start = (
    0x00
  );
  
  metil_animation->poll = (
    0x00
  );
  
  metil_animation->end = (
    0x00
  );

  metil_animation->direction = (
    metil_animation_direction_forwards
  );

  metil_animation->loops = (
    metil_animation_loop_loops_mirrored
  );

  metil_animation->state = (
    metil_animation_state_inactive
  );

  metil_animation->length = (
    0x03e8
  );

  metil_animation->data = (
    0x00
  );
}

void metil_animation_start(
  struct metil_animation* metil_animation,
  enum metil_renderable_type metil_renderable_type,
  void* metil_renderable
) {
  metil_stopwatch_start(
    &metil_animation->stopwatch
  );

  if (
    metil_animation->start !=
    0x00
  ) {
    metil_animation->start(
      metil_animation,
      metil_renderable_type,
      metil_renderable
    );
  }

  metil_animation->state = (
    metil_animation_state_active
  );
}

void metil_animation_poll(
  struct metil_animation* metil_animation,
  enum metil_renderable_type metil_renderable_type,
  void* metil_renderable
) {
  switch (
    metil_animation->state
  ) {
    case metil_animation_state_starting:
    case metil_animation_state_restarting: {
      metil_animation_start(
        metil_animation,
        metil_renderable_type,
        metil_renderable
      );

      break;
    }
    case metil_animation_state_pausing: {
      metil_animation_pause(
        metil_animation
      );

      return;
    }
    case metil_animation_state_unpausing: {
      metil_animation_resume(
        metil_animation
      );

      break;
    }
    case metil_animation_state_active: {
      break;
    }
    default: {
      return;
    }
  }

  float percentage_complete = (
    (float) metil_stopwatch_elapsed(
      &metil_animation->stopwatch
    ) /
    (float)
    metil_animation->length
  );

  if (
    percentage_complete >=
    0x01
  ) {
    metil_animation_end(
      metil_animation,
      metil_renderable_type,
      metil_renderable
    );
  } else if (
    metil_animation->poll !=
    0x00
  ) {
    if (
      metil_animation->direction == metil_animation_direction_backwards
    ) {
      percentage_complete = (
        0x01 -
        percentage_complete
      );
    }

    metil_animation->poll(
      metil_animation,
      metil_renderable_type,
      metil_renderable,
      percentage_complete
    );
  }
}

void metil_animation_end(
  struct metil_animation* metil_animation,
  enum metil_renderable_type metil_renderable_type,
  void* metil_renderable
) {
  if (
    metil_animation->end !=
    0x00
  ) {
    metil_animation->end(
      metil_animation,
      metil_renderable_type,
      metil_renderable
    );
  }

  if (
    metil_animation->loops ==
    metil_animation_loop_none
  ) {
    metil_animation->state = (
      metil_animation_state_complete
    );
  } else if (
    (
      metil_animation->loops &
      metil_animation_loop_loops
    ) !=
    0x00
  ) {
    metil_animation->state = (
      metil_animation_state_restarting
    );

    if (
      (
        metil_animation->loops &
        metil_animation_loop_loops_mirrored
      ) == (
        metil_animation_loop_loops_mirrored
      )
    ) {
      metil_animation->direction = (
        metil_animation->direction ^
        0xff
      );
    }

    metil_animation_poll(
      metil_animation,
      metil_renderable_type,
      metil_renderable
    );
  }
}

void metil_animation_pause(
  struct metil_animation* metil_animation
) {
  metil_animation->state = (
    metil_animation_state_paused
  );

  metil_animation->timevalue_paused.tv_sec = (
    metil_animation->stopwatch.timeval.tv_sec
  );

  metil_animation->timevalue_paused.tv_usec = (
    metil_animation->stopwatch.timeval.tv_usec
  );
}

void metil_animation_resume(
  struct metil_animation* metil_animation
) {
  metil_animation->state = (
    metil_animation_state_active
  );

  metil_stopwatch_start(
    &metil_animation->stopwatch
  );

  metil_animation->stopwatch.timeval.tv_sec = (
    metil_animation->timevalue_paused.tv_sec + (
      metil_animation->stopwatch.timeval.tv_sec -
      metil_animation->timevalue_paused.tv_sec
    )
  );

  metil_animation->stopwatch.timeval.tv_usec = (
    metil_animation->timevalue_paused.tv_usec + (
      metil_animation->stopwatch.timeval.tv_usec -
      metil_animation->timevalue_paused.tv_usec
    )
  );
}
