#ifndef __metil_image_metil_image_offsets_h
#define __metil_image_metil_image_offsets_h

#include <metil_image/metil_image_type.h>

enum metil_image_offset {
  metil_image_offset_rgba_8_bytes  = 0x04,
  metil_image_offset_rgba_8_r      = 0x00,
  metil_image_offset_rgba_8_g      = 0x01,
  metil_image_offset_rgba_8_b      = 0x02,
  metil_image_offset_rgba_8_a      = 0x03,

  metil_image_offset_bgra_8_bytes  = 0x04,
  metil_image_offset_bgra_8_r      = 0x02,
  metil_image_offset_bgra_8_g      = 0x01,
  metil_image_offset_bgra_8_b      = 0x00,
  metil_image_offset_bgra_8_a      = 0x03,

  metil_image_offset_unknown_bytes = 0x01,
  metil_image_offset_unknown_r     = 0x00,
  metil_image_offset_unknown_g     = 0x00,
  metil_image_offset_unknown_b     = 0x00,
  metil_image_offset_unknown_a     = 0x00
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
