#ifndef __metil_image_metil_image_brightness_h
#define __metil_image_metil_image_brightness_h

#include <metil_image/metil_image_offsets.h>
#include <metil_image/metil_image_type.h>

void metil_image_brightness_linear_with_offsets(
  unsigned char*,
  unsigned int,
  enum metil_image_type,
  const struct metil_image_offsets*,
  float
);

void metil_image_brightness_linear(
  unsigned char*,
  unsigned int,
  enum metil_image_type,
  float
);

#endif
