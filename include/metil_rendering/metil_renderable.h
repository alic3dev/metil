#ifndef __metil_renderable_h
#define __metil_renderable_h

enum metil_renderable_type {
  metil_renderable_type_group = 0,
  metil_renderable_type_object = 1,
  metil_renderable_type_menu = 2,
  metil_renderable_type_model = 3
};

struct metil_renderable {
  void* _Nonnull renderable;
  enum metil_renderable_type type;
};

void metil_renderable_allocate_group(
  struct metil_renderable* _Nonnull
);

void metil_renderable_allocate_model(
  struct metil_renderable* _Nonnull
);

void metil_renderable_allocate_object(
  struct metil_renderable* _Nonnull
);

void metil_renderable_allocate(
  struct metil_renderable* _Nonnull,
  enum metil_renderable_type type
);

void metil_renderable_initialize(
  struct metil_renderable* _Nonnull,
  enum metil_renderable_type
);

void metil_renderable_allocate_at_index(
  struct metil_renderable* _Nonnull,
  unsigned int,
  enum metil_renderable_type
);

void metil_renderable_initialize_at_index(
  struct metil_renderable* _Nonnull,
  unsigned int,
  enum metil_renderable_type
);

void metil_renderable_destroy(
  struct metil_renderable* _Nonnull
);

#endif
