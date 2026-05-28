#ifndef __metil_tools_metil_editor_metil_editor_scene_h
#define __metil_tools_metil_editor_metil_editor_scene_h

#include <metil.h>
#include <metil_scenes/metil_scene.h>

#define metil_editor_scene_length_renderables 0x09

enum metil_editor_scene_index_renderable {
  metil_editor_scene_index_renderable_group_grids                = 0x00,
  metil_editor_scene_index_renderable_grid_lines                 = 0x01,
  metil_editor_scene_index_renderable_lines                      = 0x02,
  metil_editor_scene_index_renderable_points                     = 0x03,
  metil_editor_scene_index_renderable_triangles                  = 0x04,
  metil_editor_scene_index_renderable_cursor                     = 0x05,
  metil_editor_scene_index_renderable_group_text_position_cursor = 0x06,
  metil_editor_scene_index_renderable_group_text_position_vertex = 0x07,
  metil_editor_scene_index_renderable_group_text_length_vertices = 0x08
};

void metil_editor_scene_initialize(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void metil_editor_scene_poll(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

void metil_editor_scene_destroy(
  struct metil* _Nonnull,
  struct metil_scene* _Nonnull
);

#endif
