#ifndef __metil_metil_filter_metil_filter_h
#define __metil_metil_filter_metil_filter_h

enum metil_filter_mode {
  metil_filter_mode_dual_target   = 0b0011,
  metil_filter_mode_single_target = 0b0001
};

#define metil_filter_mode_default metil_filter_mode_dual_target

struct metil_filter {
  unsigned short int index_pipeline_compute;

  unsigned char mode;
};

void metil_filter_initialize(
  struct metil_filter*,
  unsigned short int,
  unsigned char
);

#endif
