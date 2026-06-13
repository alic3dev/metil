#include <metil_example_audio_output_object.h>

#include <metil.h>
#include <metil_object/metil_object.h>

void metil_example_audio_output_object_destroy(
  struct metil* metil,
  struct metil_object* metil_object
) {
  metil_object->buffers_vertex[
    metil_object->length_buffers_vertex -
    0x01
  ].buffer = (
    0x00
  );
  
  metil_object_destroy(
    metil,
    metil_object
  );
}
