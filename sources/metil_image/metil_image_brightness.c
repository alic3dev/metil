#include <metil_image/metil_image_brightness.h>

#include <metil_image/metil_image_offsets.h>
#include <metil_image/metil_image_type.h>

void metil_image_brightness_linear(
  unsigned char* metil_image_data,
  unsigned int metil_image_data_length,
  enum metil_image_type metil_image_type,
  float brightness
) {
  if (
    brightness < 0.0f
  ) {
    brightness = 0.0f;
  }

  const struct metil_image_offsets* metil_image_offsets = (
    metil_image_offsets_get_by_type(
      metil_image_type
    )
  );

  for (
    unsigned int index_metil_image_data = 0;
    index_metil_image_data < metil_image_data_length;
    ++index_metil_image_data
  ) {
    if (
      (
        index_metil_image_data %
        metil_image_offsets->bytes
      ) == (
        metil_image_offsets->a
      )
    ) {
      continue;
    }

    float adjusted_value = (
      (float) metil_image_data[
        index_metil_image_data
      ] *
      brightness
    );

    if (
      adjusted_value > 0xff
    ) {
      adjusted_value = (
        0xff
      );
    }

    metil_image_data[
      index_metil_image_data
    ] = (
      adjusted_value
    );
  }
}
