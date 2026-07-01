#include <metil_filter/metil_filter.h>

void metil_filter_initialize(
  struct metil_filter* metil_filter,
  unsigned short int index_pipeline_compute,
  unsigned char mode
) {
  if (
    mode ==
    0x00
  ) {
    metil_filter->mode = (
      metil_filter_mode_default
    );
  } else {
    metil_filter->mode = (
      mode
    );
  }
  
  metil_filter->index_pipeline_compute = (
    index_pipeline_compute
  );
}
