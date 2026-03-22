#ifndef __metil_input_metil_touch_h
#define __metil_input_metil_touch_h

#include <math_c_vector.h>

struct metil_touch {
  unsigned long int index_touch;

  unsigned char touching;

  float pressure;
  float maximum_pressure;

  struct math_c_vector2_float position;

  struct math_c_vector2_float delta;
};

void metil_touch_initialize(
  struct metil_touch* _Nonnull
);

#endif
