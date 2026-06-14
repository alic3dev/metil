#ifndef __metil_tools_metil_editor_metil_editor_player_h
#define __metil_tools_metil_editor_metil_editor_player_h

#include <metil.h>
#include <metil_player/metil_player.h>

void metil_editor_player_poll_input(
  struct metil* _Nonnull,
  struct metil_player* _Nonnull,
  unsigned long int,
  unsigned long int
);

#endif
