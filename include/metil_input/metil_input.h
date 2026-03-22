#ifndef __metil_input_metil_input_h
#define __metil_input_metil_input_h

#include <metil_input/metil_controller.h>
#include <metil_input/metil_controller_state.h>
#include <metil_input/metil_cursor.h>
#include <metil_input/metil_input_map.h>
#include <metil_input/metil_touch.h>

struct metil_input {
  struct metil_controller controller;
  struct metil_controller_state controller_state;

  struct metil_cursor cursor;

  struct metil_touch touch;

  unsigned char keydown_map[
    metil_input_map_keydown_length
  ];
};

void metil_input_initialize(
  struct metil_input* _Nonnull
);

#endif
