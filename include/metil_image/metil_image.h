#ifndef __metil_image_metil_image_h
#define __metil_image_metil_image_h

#include <metil_image/metil_image_offsets.h>
#include <metil_image/metil_image_type.h>

#include <math_c_vector.h>

struct metil_image {
  void* data;

  struct math_c_vector2_unsigned_int size;

  unsigned int length_row;
  unsigned int length;

  const struct metil_image_offsets* offsets;

  enum metil_image_type type;
};

void metil_image_initialize(
  struct metil_image*
);

void metil_image_destroy(
  struct metil_image*
);

#endif
