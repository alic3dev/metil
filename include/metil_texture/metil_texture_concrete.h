#ifndef __metil_texture_metil_texture_concrete_h
#define __metil_texture_metil_texture_concrete_h

#include <math_c_vector.h>

#include <Metal/MTLDevice.h>
#include <Metal/MTLTexture.h>

id<MTLTexture> _Nonnull metil_texture_concrete_generate(
  struct math_c_vector2_unsigned_short_int,
  unsigned char* _Nonnull,
  unsigned int,
  id<MTLDevice> _Nonnull
);

id<MTLTexture> _Nonnull metil_texture_concrete_secondary_generate(
  struct math_c_vector2_unsigned_short_int,
  unsigned char* _Nonnull,
  unsigned int,
  id<MTLDevice> _Nonnull
);


#endif
