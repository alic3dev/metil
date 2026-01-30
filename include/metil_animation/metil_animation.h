#ifndef __metil_animation_metil_animation_h
#define __metil_animation_metil_animation_h

#include <metil_rendering/metil_renderable_type.h>
#include <metil_utilities/metil_stopwatch.h>

#include <sys/time.h>

struct metil_animation;

typedef void (*metil_animation_function_start)(
  struct metil_animation*,
  enum metil_renderable_type,
  void*
);

typedef void (*metil_animation_function_poll)(
  struct metil_animation*,
  enum metil_renderable_type,
  void*,
  float
);

typedef void (*metil_animation_function_end)(
  struct metil_animation*,
  enum metil_renderable_type,
  void*
);

enum metil_animation_direction {
  metil_animation_direction_backwards = 0x00,
  metil_animation_direction_forwards = 0xff
};

enum metil_animation_loop {
  metil_animation_loop_none = 0b00000000,
  metil_animation_loop_loops = 0b00000001,
  metil_animation_loop_loops_mirrored = 0b00000011,
};

enum metil_animation_state {
  metil_animation_state_inactive = 0x00,
  metil_animation_state_starting = 0x01,
  metil_animation_state_restarting = 0x02,
  metil_animation_state_active = 0x03,
  metil_animation_state_pausing = 0x04,
  metil_animation_state_paused = 0x05,
  metil_animation_state_unpausing = 0x06,
  metil_animation_state_complete = 0xff
};

struct metil_animation {
  metil_animation_function_start start;
  metil_animation_function_poll poll;
  metil_animation_function_end end;

  enum metil_animation_direction direction;
  enum metil_animation_loop loops;
  enum metil_animation_state state;

  struct metil_stopwatch stopwatch;
  unsigned long int length;
  struct timeval timevalue_paused;

  void* data;
};

void metil_animation_initialize(
  struct metil_animation*
);

void metil_animation_start(
  struct metil_animation*,
  enum metil_renderable_type,
  void*
);

void metil_animation_poll(
  struct metil_animation*,
  enum metil_renderable_type,
  void*
);

void metil_animation_end(
  struct metil_animation*,
  enum metil_renderable_type,
  void*
);

void metil_animation_pause(
  struct metil_animation*
);

void metil_animation_resume(
  struct metil_animation*
);

#endif
