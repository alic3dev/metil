#include <metil_image/metil_image_offsets.h>

#include <metil_image/metil_image_type.h>

const struct metil_image_offsets metil_image_offsets_rgba_8 = {
  .bytes = metil_image_offset_rgba_8_bytes,
  .r = metil_image_offset_rgba_8_r,
  .g = metil_image_offset_rgba_8_g,
  .b = metil_image_offset_rgba_8_b,
  .a = metil_image_offset_rgba_8_a
};

const struct metil_image_offsets metil_image_offsets_bgra_8 = {
  .bytes = metil_image_offset_bgra_8_bytes,
  .r = metil_image_offset_bgra_8_r,
  .g = metil_image_offset_bgra_8_g,
  .b = metil_image_offset_bgra_8_b,
  .a = metil_image_offset_bgra_8_a
};

const struct metil_image_offsets metil_image_offsets_unknown = {
  .bytes = metil_image_offset_unknown_bytes,
  .r = metil_image_offset_unknown_r,
  .g = metil_image_offset_unknown_g,
  .b = metil_image_offset_unknown_b,
  .a = metil_image_offset_unknown_a
};

const struct metil_image_offsets* metil_image_offsets_get_by_type(
  enum metil_image_type metil_image_type
) {
  switch (
    metil_image_type
  ) {
    case metil_image_type_rgba_8: {
      return &(
        metil_image_offsets_rgba_8
      );
    }
    case metil_image_type_bgra_8: {
      return &(
        metil_image_offsets_bgra_8
      );
    }
    default: {
      return &(
        metil_image_offsets_unknown
      );
    }
  };
}
