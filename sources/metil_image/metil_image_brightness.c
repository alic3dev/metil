#include <metil_image/metil_image_brightness.h>

#include <metil_image/metil_image.h>
#include <metil_image/metil_image_offsets.h>
#include <metil_image/metil_image_type.h>

void metil_image_brightness_linear(
  struct metil_image* metil_image,
  float brightness
) {
  if (
    brightness < 0.0f
  ) {
    brightness = 0.0f;
  }

  unsigned char* metil_image_data = (
    metil_image->data
  );

  for (
    unsigned int index_metil_image_data = 0;
    index_metil_image_data < metil_image->length;
    ++index_metil_image_data
  ) {
    if (
      (
        index_metil_image_data %
        metil_image->offsets->bytes
      ) == (
        metil_image->offsets->a
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
