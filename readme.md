# `metil`

rendering_framework.utilizing(`apple::metal`)

## usage

### linking

- library_files (`x` is current major version)
- - dynamic library: `library/metil.x.dylib`
- - dynamic library: `library/metil.dylib`: symbolically linked to `metil.x.dylib`
- - dynamic shared library: `library/metil.x.so`
- - dynamic shared library: `library/metil.so`: symbolically linked to `metil.x.so`
- - library archive: `library/metil.a`
- - object: `library/metil.o`
- `%.metalar`
- - `library/metil_all.metalar`: metal archive of all `air/*.air` files
- - - `metal/basic_2d_shaders.metal`->`air/basic_2d_shaders.air`
- - - `metal/basic_3d_shaders.metal`->`air/basic_3d_shaders.air`
- - - `metal/metil_fps_display.metal`->`air/metil_fps_display.air`
- - - `metal/metil_wireframe.metal`->`air/metil_wireframe.air`
- - `library/metil_fps_display.metalar`: archive of `metil_fps_display`
- - `library/metil_wireframe.metalar`: archive of `metil_wireframe`
- `library/metil.metallib`: metallib built from `library/metil_all.metalar`
- `%.plist`
- - `library/Info.plist`: sets the storyboard name to use
- `%.storyboardc`
- - `library/metil.storyboardc`: default storyboard

#### dynamic libraries

using a dynamic library will require the produced executable to be able to find `%.x.dylib` files for

- [`alic3dev/cer0`](https://github.com/alic3dev/cer0)
- [`alic3dev/clic3`](https://github.com/alic3dev/clic3)
- [`alic3dev/interrupt_handler`](https://github.com/alic3dev/interrupt_handler)
- [`alic3dev/math_c`](https://github.com/alic3dev/math_c)

the target version of these libraries that `metil` expects can be found within the `makefile`

#### static libraries

using a static library or archive requires linking the previously mentioned libraries in any format

### `%.metalar`

`%.metalar` files can be added during the compilation of a `metallib` for default implementations provided by `metil`

```zsh
# adds metil_fps_display shaders and metil_wireframe shaders
xcrun -sdk macosx metallib metal_archive.metalar metil_fps_display.metalar metil_wireframe.metalar -o default.metallib
```

### includes

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

### intialization

- `metil_initialize`: must be called within your `main` function and it's value returned as the exit status code.
- `metil_library`: must be initialized within the `metil_renderer_on_initialize_function` passed to `metil_initialize` (`metil_library_initialize` is provided to simplify this)
- - `metil_library.library`: must be set to an instance of a `metal` library (`id<MTLLibrary>`)
- - `metil_library.function_vertex`: must be set to an instance of a `metal` vertex function (`id<MTLFunction>`)
- - `metil_library.function_fragment`: must be set to an instance of a `metal` fragment function (`id<MTLFunction>`)
- - `metil_library.function_fragment_fps_display`: optional | required for usage of built in `fps_display`
- - `metil_library.function_vertex_fps_display`: optional | required for usage of built in `fps_display`
- - `metil_library.function_fragment_wireframe`: optional | required for usage of built in `wireframe` rendering mode
- - `metil_library.function_vertex_wireframe`: optional | required for usage of built in `wireframe` rendering mode

```obj-c
#include <metil_initialize.h>
#include <metil_library.h>
#include <metil_rendering/metil_renderer_interface.h>

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
  struct metil_renderer_interface* metil_renderer_interface,
  void* data
) {
  metil_library_initialize(
    metil_renderer_interface->metal_device,
    @"example_initialization_fragment",
    @"example_initialization_vertex"
  );

  /*
    - set: rendering_properties
    - initialize: scene
    - set: on scene change
  */
}
```

## units

`metil` presupposes that 10 units is equivalent to 1 metre

## coordinates

- `x` values go from left to right as -1 to 1
- `y` values go from bottom to top as -1 to 1
- `z` values go from front to back as -1 to 1

```
     y +1.0  ^
             |   / z +1.0
             |  /
             | /
x -1.0       |/
     <-------*------->
            /|       x +1.0
           / |
          /  |
  z -1.0 /   |
             v y -1.0
```

## rotations

### viewport

viewport rotations are set via `scene_controller.scene.player.rotation`

- `x`:
- - rotations in the positive rotate the viewport to look upwards
- - rotations in the negative rotate the viewport to look downwards
- `y`:
- - rotations in the positive rotate the viewport to look towards the right
- - rotations in the negative rotate the viewport to look towards the left

```
`struct metil_renderable renderable;`
`renderable.position.x = 0.0f;`
`renderable.position.y = 0.0f;`
`renderable.position.z = 1.0f;`

`scene.player.rotation.x = 0.0;`
`scene.player.rotation.y = 0.45;`
     ___________________
    |                   |
1.0 -                   |
    |                   |
0.75-                   |
    |         X         |
0.5 -                   |
    |                   |
0.25-                   |
    |___|___|___|___|___|
0.0   0.25 0.5 0.75 1.0

`scene.player.rotation.x = 0.0;`
`scene.player.rotation.y = 0.45;`
     ___________________
    |                   |
1.0 -                   |
    |                   |
0.75-                   |
    |   X               |
0.5 -                   |
    |                   |
0.25-                   |
    |___|___|___|___|___|
0.0   0.25 0.5 0.75 1.0

`scene.player.rotation.x = 0.0;`
`scene.player.rotation.y = -0.45;`
     ___________________
    |                   |
1.0 -                   |
    |                   |
0.75-                   |
    |               X   |
0.5 -                   |
    |                   |
0.25-                   |
    |___|___|___|___|___|
0.0   0.25 0.5 0.75 1.0

`scene.player.rotation.x = 0.45;`
`scene.player.rotation.y = 0.0;`
     ___________________
    |                   |
1.0 -                   |
    |                   |
0.75-                   |
    |                   |
0.5 -                   |
    |                   |
0.25-         X         |
    |___|___|___|___|___|
0.0   0.25 0.5 0.75 1.0

`scene.player.rotation.x = -0.45;`
`scene.player.rotation.y = 0.0;`
     ___________________
    |                   |
1.0 -         X         |
    |                   |
0.75-                   |
    |                   |
0.5 -                   |
    |                   |
0.25-                   |
    |___|___|___|___|___|
0.0   0.25 0.5 0.75 1.0

`scene.player.rotation.x = 0.45;`
`scene.player.rotation.y = 0.45;`
     ___________________
    |                   |
1.0 -                   |
    |                   |
0.75-                   |
    |                   |
0.5 -                   |
    |                   |
0.25-   X               |
    |___|___|___|___|___|
0.0   0.25 0.5 0.75 1.0

`scene.player.rotation.x = 0.45;`
`scene.player.rotation.y = -0.45;`
     ___________________
    |                   |
1.0 -                   |
    |                   |
0.75-                   |
    |                   |
0.5 -                   |
    |                   |
0.25-               X   |
    |___|___|___|___|___|
0.0   0.25 0.5 0.75 1.0

`scene.player.rotation.x = -0.45;`
`scene.player.rotation.y = 0.45;`
     ___________________
    |                   |
1.0 -   X               |
    |                   |
0.75-                   |
    |                   |
0.5 -                   |
    |                   |
0.25-                   |
    |___|___|___|___|___|
0.0   0.25 0.5 0.75 1.0

`scene.player.rotation.x = -0.45;`
`scene.player.rotation.y = -0.45;`
     ___________________
    |                   |
1.0 -               X   |
    |                   |
0.75-                   |
    |                   |
0.5 -                   |
    |                   |
0.25-                   |
    |___|___|___|___|___|
0.0   0.25 0.5 0.75 1.0
```

## `metil_positioning`

`metil_positioning` is an enumeration that can be set for `metil_object`s with the parameter `positioning`

- `metil_positioning_normal`:
- - positions and sizes the object according to the cameras viewport projection matrix (`self->rendering_properties.camera.matrix_viewport_projection`: a combination of FOV/aspect ratio calculations) while applying `x` and `y` rotation transforms from `metil_scene_controller.scene.player.rotation` and subtractive translation transforms from `metil_scene_controller.scene.player.position`
- `metil_positioning_player`:
- - positions and sizes the object the same as `metil_positioning_normal` but does not apply `y` rotation transforms allowing the object to rotate with the camera instead of against it
- `metil_positioning_static`:
- - positions and sizes the object in viewport units with respect to the targeted rendering aspect ratio versus the actual aspect ratio of the viewport
- - ex: at `1920x1080` with a rendering aspect ratio of `16/9` a object of size `x: 0.1f, y: 0.1f` and a position of `x: -0.5f, y: 0.5f` will render 1:1 in viewport units, if the viewport size changes to `1920x540` then that same object will render with a relative size of `x: 0.05, y: 0.05` at a position of `x: -0.5f, y: 0.5f`, while a viewport size of `960x1080` will render at `x: 0.1f, y: 0.1f` at a position of `x: -0.5f, y: 0.5f`
- `metil_positioning_absolute`:
- - positions and sizes the object in aboslute viewport units regardless of aspect ratio
- - ex: `x: -1.0f, y: 1.0f` is top left, `x: 0.0f, y: 0.0f` is center, `x: 0.0f, y: -1.0f` is bottom center

## `metil_rendering_properties->mode`

- `metil_rendering_properties_mode_default`: normal rendering
- `metil_rendering_properties_mode_wireframe`: renders wireframes (requires `metil_library.function_[fragment|vertex]_wireframe` to be set)

any combination of rendering mode flags may be set using `|` operators

```c
// Enable wireframe rendering overtop of default rendering
metil_rendering_properties->mode = (
  metil_rendering_properties_mode_default |
  metil_rendering_properties_mode_wireframe
);

// Only render wireframes
metil_rendering_properties->mode = (
  metil_rendering_properties_mode_wireframe
);
```

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
0.3: for->{`scene`.`renderables`.as(`renderable`)}
0.3.0: `switch->{`renderable->type`}
0.3.0.0: case[`metil_renderable_type_object`]->{`poll_object`(`renderable->renderable`))[[instantiate|update]:data_properties]}
1: `render`
1.0: for->{`scene`.`renderables`.as(`renderable`)}
1.0.0: `switch->{`renderable->type`}
1.0.0.0: case[`metil_renderable_type_object`]->{`render_object`(`renderable->renderable`)}
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
0.0.1.0.0: `object->destroy(object)`
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

see `usage->linking->[dynamic libraries | static libraries]` for further information

- [`alic3`](https://github.com/alic3dev):libraries
- - [`cer0`](https://github.com/alic3dev/cer0)
- - [`clic3`](https://github.com/alic3dev/clic3)
- - [`interrupt_handler`](https://github.com/alic3dev/interrupt_handler)
- - [`math_c`](https://github.com/alic3dev/math_c)

### `make`:targets

```zsh
# build metil
make

# build metil
make metil

# build metil examples
make examples

# build metil and examples
make all

# clean metil
make clean

# clean metil examples
make clean_examples

# clean metil and metil examples
make clean_all
```

### `make`:flags

these flags can be applied to any build target

- `debug=1`:adds->{`debugging_symbols`}:disables->{`optimizations`};
- `disable_metal_fast_options=1`:disables->{`metal`::`fast_modes`};
- `target_device`:sets_the_target_device_platform->{values::[`mac`|`iphone`]}
- `target_device_version`:sets_the_target_device_version.for->{`macos`|`ios`};
- - platforms
- - - macos->{`arm64-apple-macos${target_device_version}`}
- - - ios->{`arm64-apple-ios${target_device_version}`}
- - sdks
- - - macos->{`macosx${target_device_version}`}
- - - ios->{`iphoneos${target_device_version}`}
- `target_metal_version`:sets_the_target_metal_version::(will_use->{`target_device_version`}_if_not_set)
- - platforms
- - - macos->{`arm64-apple-macos${target_metal_version}`}
- - - ios->{`arm64-apple-ios${target_metal_version}`}

```zsh
# build a debugging version of metil
make metil debug=1

# build metil for macos version 26.0 with fast modes disabled for metal
make metil disable_metal_fast_options=1 target_macos_version=26.0

# build an ios version of metil
make target_device=iphone
```

## usage

## projects

### macos

- [`alic3`](https://github.com/alic3dev)
- - [`c938`](https://github.com/alic3dev/c938)
- - [`zoe`](https://github.com/alic3dev/zoe)

### ios

- [`alic3`](https://github.com/alic3dev)
- - [`ff`](https://github.com/alic3dev/ff)

## examples

### [2d_rendering](examples/2d_rendering/)

<img width="1966" height="1250" alt="metil_example_2d_rendering_2" src="https://github.com/user-attachments/assets/cd5c4b5e-f4ec-4bc1-a69e-f64b54d19c12" />
<img width="1966" height="1250" alt="metil_example_2d_rendering" src="https://github.com/user-attachments/assets/eed4ec93-5284-43a3-a5f2-2c2abff9527a" />

### [3d_rendering](examples/3d_rendering/)

<img width="1966" height="1250" alt="metil_example_3d_rendering" src="https://github.com/user-attachments/assets/6da49b26-0001-4e5c-8af4-47191ac57aa5" />

## copyright|copyleft

> ©️ [copyleft|copyright]->{alic3dev(2025)}:[all_rights_reserved|all_lefts_reserved]
