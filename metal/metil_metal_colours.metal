#include <metil_metal/metil_metal_colours.h>

#include <math_c_vector.h>

#define metil_metal_colours_brightness_apply\
  metil_metal_colour->x = (\
    metil_metal_colour->x *\
    metil_metal_brightness\
  );\
\
  metil_metal_colour->y = (\
    metil_metal_colour->y *\
    metil_metal_brightness\
  );\
\
  metil_metal_colour->z = (\
    metil_metal_colour->z *\
    metil_metal_brightness\
  );

void metil_metal_colours_math_c_vector3_float_brightness_apply(
  thread struct math_c_vector3_float* metil_metal_colour,
  float metil_metal_brightness
) {
  metil_metal_colours_brightness_apply
}

void metil_metal_colours_math_c_vector4_float_brightness_apply(
  thread struct math_c_vector4_float* metil_metal_colour,
  float metil_metal_brightness
) {
  metil_metal_colours_brightness_apply
}

void metil_metal_colours_float4_brightness_apply(
  thread float4* metil_metal_colour,
  float metil_metal_brightness
) {
  metil_metal_colours_brightness_apply
}
