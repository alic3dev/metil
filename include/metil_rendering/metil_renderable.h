#ifndef __metil_renderable_h
#define __metil_renderable_h

enum metil_renderable_type {
  metil_renderable_type_object = 0,
  metil_renderable_type_menu = 1,
  metil_renderable_type_model = 2
};

struct metil_renderable {
  void* _Nonnull renderable;
  enum metil_renderable_type type;
};

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

#endif
