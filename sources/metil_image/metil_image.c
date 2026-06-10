#include <metil_image/metil_image.h>

#include <metil_image/metil_image_offsets.h>
#include <metil_image/metil_image_type.h>

#include <clic3_memory.h>

void metil_image_initialize(
  struct metil_image* metil_image
) {
  metil_image->data = (
    clic3_memory_allocate_raw(
      0x00
    )
  );

  metil_image->size.x = (
    0x00
  );
  
  metil_image->size.y = (
    0x00
  );

  metil_image->length_row = (
    0x00
  );
  
  metil_image->length = (
    0x00
  );

  metil_image->offsets = (
    &metil_image_offsets_unknown
  );

  metil_image->type = (
    metil_image_type_unknown
  );
}

void metil_image_destroy(
  struct metil_image* metil_image
) {
  clic3_memory_free_raw(
    metil_image->data
  );
}
