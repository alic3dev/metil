# metil

rendering_framework.utilizing(`apple::metal`)

## intialization

- `metil_initialize`: must be called within your `main` function and it's value returned as the exit status code.
- `metil_library`: must be initialized within the `metil_renderer_on_initialize_function` passed to `metil_initialize`
- - `metil_library.library`: must be set to an instance of a `metal` library (`id<MTLLibrary>`)
- - `metil_library.function_vertex`: must be set to an instance of a `metal` vertex function (`id<MTLFunction>`)
- - `metil_library.function_fragment`: must be set to an instance of a `metal` fragment function (`id<MTLFunction>`)

```obj-c
#include <metil_initialize.h>
#include <metil_library.h>
#include <metil_rendering/rendering_properties.h>

#include <Metal/MTLDevice.h>

int main(
  int length_parameters,
  const char** parameters
) {
  return metil_initialize(
    length_parameters,
    parameters,
    "example_initialization",
    example_initialization_renderer_on_initialize
  );
}

void example_initialization_renderer_on_initialize(
  id<MTLDevice> metal_kit_device,
  struct metil_rendering_properties* metil_rendering_properties
) {
  metil_library.library = [metal_kit_device newDefaultLibrary];

  metil_library.function_vertex = [
    metil_library.library
    newFunctionWithName: @"example_initialization_vertex"
  ];

  metil_library.function_fragment = [
    metil_library.library
    newFunctionWithName: @"example_initialization_fragment"
  ];
}
```

## includes

all header files can be included within a single `#include` of `metil.h`

```h
#include <metil.h>
```

otherwise individual header files can be included as such

```h
#include <metil_mesh/mesh.h>
#include <metil_input/controller.h>
#include <metil_input/controller_state.h>
```

## units

`metil` presupposes that 10 units is equivalent to 1 metre

## development

### prerequisites

- [`alic3`](https://github.com/alic3dev):libraries
- - [`cer0`](https://github.com/alic3dev/cer0)
- - [`clic3`](https://github.com/alic3dev/clic3)
- - [`interrupt_handler`](https://github.com/alic3dev/interrupt_handler)

### build

```zsh
make
```

#### examples

```zsh
make examples
```

#### all

```zsh
make all
```

### clean

```zsh
make clean
```

#### examples

```zsh
make clean_examples
```

#### all

```zsh
make clean_all
```

## projects

- [`alic3`](https://github.com/alic3dev)
- - [`c938`](https://github.com/alic3dev/c938)
- - [`zoe`](https://github.com/alic3dev/zoe)

## examples

### 2d_rendering

<img width="1692" height="1292" alt="metil_2d_rendering" src="https://github.com/user-attachments/assets/6dad5a45-1c4e-4777-a288-255750aa2ef1" />

### 3d_rendering

<img width="1692" height="1292" alt="metil_3d_rendering" src="https://github.com/user-attachments/assets/2ffd8a4f-154a-4ea7-af1f-430a82decaa5" />

## copyright

> ©️ [copyleft|copyright]->{alic3dev(2025)}:[all_rights_reserved|all_lefts_reserved]
