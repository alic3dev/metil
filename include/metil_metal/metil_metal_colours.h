#ifndef __metil_metal_metil_metal_colours_h
#define __metil_metal_metil_metal_colours_h

#include <math_c_vector.h>

void metil_metal_colours_math_c_vector3_float_brightness_apply(
  thread struct math_c_vector3_float*,
  float
);

void metil_metal_colours_math_c_vector4_float_brightness_apply(
  thread struct math_c_vector4_float*,
  float
);

void metil_metal_colours_float4_brightness_apply(
  thread float4*,
  float
);

#endif
