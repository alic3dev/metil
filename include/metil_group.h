#ifndef __metil_group_h
#define __metil_group_h

#include <metil.h>
#include <metil_rendering/metil_renderable.h>

struct metil_group {
  unsigned int length;
  struct metil_renderable* _Nonnull * _Nonnull renderables;
};

void metil_group_initialize(
  struct metil_group* _Nonnull
);

void metil_group_allocate(
  struct metil_group* _Nonnull,
  enum metil_renderable_type
);

void metil_group_add_initialize(
  struct metil_group* _Nonnull,
  enum metil_renderable_type
);

void metil_group_add(
  struct metil_group* _Nonnull,
  struct metil_renderable* _Nonnull
);

void metil_group_remove(
  struct metil_group* _Nonnull,
  struct metil_renderable* _Nonnull
);

void metil_group_remove_at_index(
  struct metil_group* _Nonnull,
  unsigned int
);

void metil_group_destroy_renderable(
  struct metil* _Nonnull,
  struct metil_group* _Nonnull,
  struct metil_renderable* _Nonnull
);

void metil_group_destroy_renderable_at_index(
  struct metil* _Nonnull,
  struct metil_group* _Nonnull,
  unsigned int
);

void metil_group_destroy(
  struct metil* _Nonnull,
  struct metil_group* _Nonnull
);

#endif
