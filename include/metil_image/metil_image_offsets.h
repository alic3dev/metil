#ifndef __metil_image_metil_image_offsets_h
#define __metil_image_metil_image_offsets_h

#include <metil_image/metil_image_type.h>

enum metil_image_offset {
  metil_image_offset_rgba_8_bytes = 4,
  metil_image_offset_rgba_8_r = 0,
  metil_image_offset_rgba_8_g = 1,
  metil_image_offset_rgba_8_b = 2,
  metil_image_offset_rgba_8_a = 3,

  metil_image_offset_bgra_8_bytes = 4,
  metil_image_offset_bgra_8_r = 2,
  metil_image_offset_bgra_8_g = 1,
  metil_image_offset_bgra_8_b = 0,
  metil_image_offset_bgra_8_a = 3,

  metil_image_offset_unknown_bytes = 1,
  metil_image_offset_unknown_r = 0,
  metil_image_offset_unknown_g = 0,
  metil_image_offset_unknown_b = 0,
  metil_image_offset_unknown_a = 0
};

struct metil_image_offsets {
  unsigned char bytes;
  unsigned char r;
  unsigned char g;
  unsigned char b;
  unsigned char a;
};

extern const struct metil_image_offsets metil_image_offsets_rgba_8;
extern const struct metil_image_offsets metil_image_offsets_bgra_8;
extern const struct metil_image_offsets metil_image_offsets_unknown;

const struct metil_image_offsets* metil_image_offsets_get_by_type(
  enum metil_image_type
);

#endif
