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

## [data|control]->{flow}

```
# initialization

0: `metil_initialize`
1: `metil_renderer`->{`metil_renderer_on_initialize_function()`}

# frame_draw (loop until termination)
## [may_render_up_to->{`metil_count_max_frames`}.frames_at_a_time]

0: `poll`
0.0: `metil_controller_state_poll`
0.1: `scene_poll_input`
0.1.0: set->{`scene`.[`time_elapsed`|`time_input*`]}
0.1.1: default[overrideable]:`scene->poll_input()`
0.1.1.0: default[overrideable]:`scene->player.poll_input()`
0.2: `scene_poll`
0.2.0: set->{`scene`.[`time_[![input|elapsed]]*`]}
0.2.1: default[overrideable]:`scene->poll()`
0.2.1.0: default[overrideable]:`scene->player.poll()`
0.3: for->{`scene`.`objects`.as(`object`)}
0.3.0: `poll_object`(`object`)[[instantiate|update]:data_properties]
1: `render`
1.0: for->{`scene`.`objects`.as(`object`)}
1.0.0: `render_object`(`object`)
2: display->{commands_sent_to_gpu_for_output}
3: wait_for.next_frame_call().then->{goto->{0}};

# termination (process_initialized_from_signal_interrupts_or_application_termination)

0. for->{`metil_termination_on_functions`.as(`termination_function`, `index_termination_function`)}
0.0: `termination_function(metil_termination_on_functions_data[index_termination_function])`

## termination_functions_default_ordering

0. `metil_scene_controller_destroy`
0.0: `metil_scene_destroy`
0.0.1: default[overrideable]:`scene->destroy`
0.0.1.0: for->{`scene`.`objects`.as(`object`)}
0.0.1.0.0: `metil_object_destroy(object)`
0.0.1.0.0.0: `metil_mesh_destroy(object.mesh)`
0.0.1.1: for->{`scene`.`textures`.as(`texture`)}
0.0.1.1.0: `release(texture)`
0.0.1.2: `scene->player.destroy`
1: `interrupt_handler_destroy`
2: `metil_paths_destroy`
3: `metil_audio_destroy`
4: `metil_text_destroy`
4.0: `release(color_space)`
4.1: `release(font_reference)`
5: `metil_configuration_destroy`
6: `metil_renderer_on_termination`
6.0: `metil_renderer->destroy()`
6.0.0: `metil_rendering_properties_destory(metil_renderer->rendering_properties)`
7: [...remaining_added_termination_functions]
```

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
