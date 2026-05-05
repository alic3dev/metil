#ifndef __examples_input_example_input_pipeline_index_h
#define __examples_input_example_input_pipeline_index_h

struct example_input_pipeline_index {
  unsigned short int model_player_body;
  unsigned short int model_player_pants;
  unsigned short int model_player_shirt;

  unsigned short int model_skateboard_deck;
  unsigned short int model_skateboard_truck;
  unsigned short int model_skateboard_wheel;
};

void example_input_pipeline_index_initialize(
  struct example_input_pipeline_index*
);

#endif
