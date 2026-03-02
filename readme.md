# `metil`

rendering_framework.utilizing(`apple::metal`)

## releases

- [`latest`](https://github.com/alic3dev/metil/releases/latest)
- [`metil`:version->{`1.0.0`}](https://github.com/alic3dev/metil/releases/tag/release_version-%3E%7B1.0.0%7D%3B)::[introduction_of_ios_support]
- [`metil`:version->{`0.0.0`}](https://github.com/alic3dev/metil/releases/tag/release_version-%3E%7B0.0.0%7D%3B)::[macos_only]

### versioning

the current version being worked on is version `2.0.0`

### development

- [`core`](https://github.com/alic3dev/metil/tree/core)::[prone_to_changes:consider->{[`core`](https://github.com/alic3dev/metil/tree/core)}.as_a_development_or_nightly_build]

## supported_platforms

- `macos`
- `ios`

## supported_versions

development work is being done while targeting `macos26.1`, `iphoneos26.1`, and `metal4.0`

other versions and standards may or may not work: see [`make`:flags](#makeflags) for compilation options

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
- - `library/Info_ios.plist`: sets the storyboard name to use and additional required properties for ios
- `%.storyboardc`
- - `library/metil.storyboardc`: default storyboard
- - `library/metil_ios.storyboardc`: default storyboard for ios

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

### preprocessor

- `target_os_ios`:switches_conditionals_to_target_ios

### includes

all header files can be included within a single `#include` of `metil_all.h`

```h
#include <metil_all.h>
```

otherwise individual header files can be included as such

```h
#include <metil_mesh/metil_mesh.h>
#include <metil_input/metil_controller.h>
#include <metil_input/metil_controller_state.h>
```

### intialization

- [macos] `metil_initialize`: must be called within your `main` function and it's value returned as the exit status code.
- [ios] `metil_initialize`: must be called after `UIApplicationMain` and before `metil_renderer` initialization 
- - `metil_view_controller`: `viewDidLoad` is a spot in between these two that can be tapped into using `metil_view_controller_on_view_did_load`
- `metil->library`: must be initialized (`metil_library_initialize`) within the `metil_renderer_on_initialize_function` passed to `metil_initialize`
- - `metil->library.library`: must be set to an instance of a `metal` library (`id<MTLLibrary>`)
- - `metil->library.function_vertex`: must be set to an instance of a `metal` vertex function (`id<MTLFunction>`)
- - `metil->library.function_fragment`: must be set to an instance of a `metal` fragment function (`id<MTLFunction>`)
- - `metil->library.function_fragment_fps_display`: optional | required for usage of built in `fps_display`
- - `metil->library.function_vertex_fps_display`: optional | required for usage of built in `fps_display`
- - `metil->library.function_fragment_wireframe`: optional | required for usage of built in `wireframe` rendering mode
- - `metil->library.function_vertex_wireframe`: optional | required for usage of built in `wireframe` rendering mode

#### macos

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
    renderer_on_initialize
  );
}

void renderer_on_initialize(
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
    - etc...
  */
}
```

#### ios

ios requires `metil` to be initialized after `UIApplicationMain` is called.
using the global `metil_view_controller_on_view_did_load` you can initialize `metil` from the earliest available entry point within `metil_view_controller` at `viewDidLoad`

```obj-c
#include <metil_application/metil_application.h>
#include <metil_application/metil_application_delegate.h>
#include <metil_application/metil_view_controller.h>
#include <metil_initialize.h>
#include <metil_library.h>
#include <metil_rendering/metil_renderer_interface.h>

#import <UIKit/UIKit.h>

char* executable_path;

int main(
  int length_parameters,
  char** parameters
) {
  executable_path = (
    parameters[0]
  );

  metil_view_controller_on_view_did_load = (
    view_controller_on_view_did_load
  );

  return UIApplicationMain(
    length_parameters,
    parameters,
    NSStringFromClass([metil_application class]),
    NSStringFromClass([metil_application_delegate class])
  );
}

void view_controller_on_view_did_load() {
  metil_initialize(
    1,
    &executable_path,
    "example_initialization",
    renderer_on_initialize
  );
}

void renderer_on_initialize(
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
    - etc...
  */
}
```

## `metil`

`metil` is a structure found within [include/metil.h](include/metil.h) which encapsulates `metil` and its required structures into a singular self contained structure

### audio

`metil` stores audio data within `metil->audio`

this structure contains the attached audio_device as well as any io_procs that are set along with their data values

also is a place to set the volume

### configuration

`metil` loads configuration files from `~/.config/${name}` during `metil_initialize`

- `metil->configuration`:the_configuration_structure

#### key_value_pairs

by default these are the configuration keys and values that `metil` parses for

- `audio:volume`: floating point value greater than or equal to `0.0f`
- `rendering_properties:brightness`: floating point value greater than or equal to `0.0f`
- `rendering_properties:brightness_text`: floating point value greater than or equal to `0.0f`
- `rendering_properties:fps_display`: integer value (`0`: disable fps display, `1`: enable fps display)
- `rendering_properties:colour_fps_display_r`: floating point value greater than or equal to `0.0f` and less than or equal to `1.0f`
- `rendering_properties:colour_fps_display_g`: floating point value greater than or equal to `0.0f` and less than or equal to `1.0f`
- `rendering_properties:colour_fps_display_b`: floating point value greater than or equal to `0.0f` and less than or equal to `1.0f`
- `rendering_properties:colour_fps_display_a`: floating point value greater than or equal to `0.0f` and less than or equal to `1.0f`

#### key_value_pair_format

each configuration key_value pair must be on it's own line

the start of the line must be the configuration name (ex. `rendering_properties:brightness`) followed by `->` with the `value` contained within `{` `value` `};`

for example: `configuration_key_name->{configuration_value};`

##### key_value_pair_types

- `float`ing point types can be decimal representations or not, if they have a decimal they can end in `f` or not
- `int`eger types cannot have decimals

##### example_configuration_file

```
audio:volume->{0.01f};
rendering_properties:brightness->{1.0f};
rendering_properties:brightness_text->{1.0f};
rendering_properties:fps_display->{1};
rendering_properties:colour_fps_display_r->{0.923f};
rendering_properties:colour_fps_display_g->{0.843f};
rendering_properties:colour_fps_display_b->{0.114f};
rendering_properties:colour_fps_display_a->{1.0f};
```

### input

`metil` polls input every render frame.  
use `delta` time values in any functionalities which handle input for proper input handling

- `metil->input`
- - `controller_state`:state_of_the_currently_attached_controller(`metil->input.controller`)
- - `cursor`:state_of_the_cursor
- - `keydown_map`:a_map_of_key_values_and_whether_they_are_held_down_or_not

### library

- `metil-library`:a_library_structure_which_houses_metal_libraries_and_default_fragment_and_vertex_functions

### paths

`metil->paths` is used to store path information about various locations commonly used by `metil` for loading resources

### renderer_interface

`metil->renderer_interface` stores the currently used `MTLDevice`, the `metil_renderer`, and the `size` of the viewport.  
this structure is used to interact more closely with the graphics device and the rendering pipeline

### rendering_properties

`metil->rendering_properties` is a more high level way to interact with the graphical pipeline  
here you can set the rendering mode, change camera (`metil_camera`) settings, toggle fps display, set the brightness, or change the clear colour!

### scene_controller

`metil->scene_controller` is the standard way to interact with scenes within `metil`.

note that the type is set to `void*` so to use this structure directly you will need to cast it to `struct metil_scene_controller*` and treat it as a pointer to aforementioned structure

```c
struct metil_scene_controller* metil_scene_controller = (
  metil->scene_controller
);

// get the scene
struct metil_scene* metil_scene = &(
    metil_scene_controller->scene
);

int identifier_scene = 1;

// change the scene
metil_scene_controller_scene_change(
  metil,
  metil_scene_controller,
  identifier_scene
);
```

### system_information

`metil->system_information` stores information about the system it is running on.  

currently this only contains the number of cpu cores which is then used to maximize multi-threading performance by creating threads spread evenly amongst the count of available cores.

setting this value post-configuration will change the number of threads which are spawned during multi-threaded operations

### termination

`metil->termination` is used to store procedures to be executed during termination of `metil` which can occur through various means such as user input, programatically, or signal interruption.

note that `metil` does not catch or handle any form of segmentation faults or similar, any termination or cleanup functions you have will not run if your program encounters an error

the only signal caught by `metil` is `SIG_INT` (signal interruption), any other signals are not caught and whether or not termination/cleanup functions run will be dependent upon whether the signal sent to the application is one which bypasses standard application closure or not.

### defaults

`metil` contains structures containing default values used throughout `metil`

- `metil->player_defaults`:default_values_for->{`metil_player`}
- `metil->text_characters_default`:default_font_used_to_render_texts::monospace
- `metil->text_defaults`:default_text_characters_used_to_render_text_with_fonts


### data/destroy

these properties on the `metil` structure aren't required but may be utilized if it's beneficial to you

- `metil->data`:whatever_data_is_useful_for_you_to_store
- `metil->destroy`:called_as_one_of_the_last_functions_during_termination
- - this_may_be_set_to_whatever_you_like


## renderables

`metil_renderable` is the standard way to render things within `metil` and is typically used through `metil_scene->renderables`

- renderable_types
- - `metil_model`: multiple objects through one base model with `metil_joint` calculations
- - `metil_object`: a singular object
- - `metil_group`: a collection of renderables (useful to group renderables together in one location)

### `metil_object`

`metil_object`s contain a `metil_mesh` (`mesh`) which stores raw vertices and indices data as well as `size`. this mesh then gets used as the basis for `metal` gpu accesiible buffer objects set on `metil_object` through `buffers_vertex` and `indices`

`buffers_fragment` is used to set buffers passed to fragment functions during rendering of the object  
similiarly `buffers_vertex` is used to set buffers passed to vertex functions during rendering of the object  
`textures` is used to set textures for fragment functions, the position of the `MTLTexture` within the fragment is according to its own index within the array

the process of settings `metal` buffers for gpu usage is simplified through `metil_object_buffers_initialize` which will automatically set vertex and indices buffers for you according to the data within `mesh` as well as initializing a `metil_renderer_data_object` as a vertex buffer which stores information such as `view_model_matrix_projection` which is used to transform and render coordinates of vertices relative to the objects position rotation, player position, viewport sizes, etc.

the standard way to render an objects position within a vertex function is 

```metal
struct data_vertex {
  float4 position [[position]];
};

[[vertex]] struct data_vertex standard_vertex_rendering_vertex(
  const device simd_float4* vertices [[
    buffer(
      metil_renderer_vertex_index_parameter_vertices
    )
  ]],
  constant struct metil_renderer_data_frame* data_frame [[
    buffer(
      metil_renderer_vertex_index_parameter_data_frame
    )
  ]],
  constant struct metil_renderer_data_object* data_object [[
    buffer(
      metil_renderer_vertex_index_parameter_data_object
    )
  ]],
  unsigned int id_vertex [[vertex_id]]
) {
  struct data_vertex data_vertex;

  data_vertex.position = (
    data_object->view_model_matrix_projection *
    vertices[
      id_vertex
    ]
  );

  return data_vertex;
}
```

`view_model_matrix_projection` is set for you through the default `metil_object_poll`

specialized buffer allocation can be done through usage of `metil_object_buffers_initialize_with_data_size` which allocates the same buffers mentioned above but with a specified data size passed in as the last parameter. this will allow you to use custom structures instead of just the default `metil_renderer_data_object`

note that you will need to add a custom `poll` function to make sure some form of `view_model_matrix_projection` is set correctly within your custom structure in order to render vertices correctly

you can also create the buffers manually once you are more aware of what you are doing and how this system works and interacts with itself

### metil_model

`metil_model` is a collection of objects which get translations and rotations applied to them from the `metil_model` as well as from any attached `metil_joint` structures contained within the `metil_model`.

### metil_group

a group of renderables. useful for segmenting a section of renderables together as one group.

## metil_joint

`metil_joint` is a system of attached joint structures typically used through `metil_model`

these joints have a position value which is then used to apply rotations/translations to any attached joints

`metil_model` has functionality in place to handle most of this by default. 

joints are added to a model using `metil_model_joints_add_length`  
once all joints are added to a model then the vertex joint map should be initialized using `metil_model_vertex_joint_maps_initialize` which sets a `metal` buffer at the index of `metil_renderer_vertex_index_parameter_vertex_joint_map`  
after the vertex joint mapping is initialized then specific joints can be attached together through `metil_joint_attach` while vertices can be attached to specific joints using `metil_model_vertex_joint_attach`

when you update the rotation of `metil_joint` you can propagate any changes to attached joints using `metil_joint_propagate` (this function should be used from the topmost joint otherwise translation and rotation values will be lost)

during model polling these joints and their values are set within a `metal` buffer assigned to `metil_renderer_vertex_index_parameter_joints` mapped as `([position, rotation, translation])[id_joint]` (all joint indexes within this buffer are offset by 1 as `metil_model` creates a default joint with values set to `0.0f` for vertices to use as an `unattached` state value during calculations; if a vertex is set to a joint at index `0` on a model then the vertex joint map will have a value of `1`, this is something internal to `metil_model` which if using the standard functionality isn't something to concern yourself with unless your calculations within the vertex function require the value of the index of a specified joint)

vertex rendering functions then takes the buffer values from `metil_renderer_vertex_index_parameter_vertex_joint_map` and `metil_renderer_vertex_index_parameter_joints` to perform lookups to obtain the `position` `rotation` and `translation` values of any attached joints to then be applied to the `vertex` position  

the following example shows how to create and attach joints within a metil model

it first create 3 joints, attaches them from 0 to 1 to 2, attaches each object vertex to a specified joint based on the object index, then applies and propagates an `x` rotation of `0.1f` radians and a `y` rotation of `0.2f` radians from the first joint down to the last joint

see [`examples/model`](examples/model) for further examples of how to utilize `metil_joint`

#### metil_joint_vertex.m
```obj-c
void metil_joint_vertex_example(
  struct metil_model* metil_model
) {
  metil_model_joints_add_length(
    metil_model,
    3
  );

  metil_model_vertex_joint_maps_initialize(
    metil_model
  );

  for (
    unsigned char index_joint = 1;
    index_joint < metil_model->length_joints;
    ++index_joint
  ) {
    metil_joint_attach(
      &(
        metil_model->joints[
          index_joint -
          1
        ]
      ),
      &(
        metil_model->joints[
          index_joint
        ]
      )
    );
  }

  for (
    unsigned int index_object = 0;
    index_object < metil_model->length_objects;
    ++index_object
  ) {
    struct metil_object* metil_object = (
      metil_model->objects[
        index_object
      ]
    );

    for (
      unsigned int index_vertex = 0;
      index_vertex < metil_object->mesh.length_vertices;
      ++index_vertex
    ) {
      metil_model_vertex_joint_attach(
        metil_model,
        index_object,
        index_vertex, (
          index_object %
          metil_model->length_joints
        )
      );
    }
  }

  struct metil_joint* metil_joint = &(
    metil_model->joints[
      0
    ]
  );

  metil_joint->rotation.x = (
    metil_joint->rotation.x +
    0.1f
  );

  metil_joint->rotation.y = (
    metil_joint->rotation.y +
    0.2f
  );

  metil_joint_propagate(
    metil_joint
  );
}
```

#### metil_joint_vertex.metal

```metal
#include <metil_joint/metil_joint_id_offset.h>
#include <metil_rendering/metil_renderer_data_frame.h>
#include <metil_rendering/metil_renderer_vertex_index_parameter.h>
#include <metil_rendering/metil_renderer_data_model_object.h>

struct data_vertex {
  float4 position [[position]];
};

[[vertex]] struct data_vertex model_vertex(
  const device simd_float4* vertices [[
    buffer(
      metil_renderer_vertex_index_parameter_vertices
    )
  ]],
  constant struct metil_renderer_data_frame* data_frame [[
    buffer(
      metil_renderer_vertex_index_parameter_data_frame
    )
  ]],
  constant struct metil_renderer_data_model_object* data_object [[
    buffer(
      metil_renderer_vertex_index_parameter_data_object
    )
  ]],
  constant unsigned int* vertex_joint_map [[
    buffer(
      metil_renderer_vertex_index_parameter_vertex_joint_map
    )
  ]],
  constant struct math_c_vector3_float* joints [[
    buffer(
      metil_renderer_vertex_index_parameter_joints
    )
  ]],
  unsigned int id_vertex [[vertex_id]]
) {
  struct data_vertex data_vertex;

  unsigned int id_joint = (
    vertex_joint_map[
      id_vertex
    ] *
    metil_joint_id_offset_length
  );

  unsigned int id_joint_position = (
    id_joint +
    metil_joint_id_offset_position
  );

  unsigned int id_joint_rotation = (
    id_joint +
    metil_joint_id_offset_rotation
  );

  unsigned int id_joint_translation = (
    id_joint +
    metil_joint_id_offset_translation
  );

  matrix_float4x4 matrix_projection_object_with_rotation = (
    (matrix_float4x4) {{
      { math_c_cosine(joints[id_joint_rotation].y, math_c_pi), 0.0f, -math_c_sine(joints[id_joint_rotation].y, math_c_pi), 0.0f },
      { 0.0f, 1.0f, 0.0f, 0.0f },
      { math_c_sine(joints[id_joint_rotation].y, math_c_pi), 0.0f, math_c_cosine(joints[id_joint_rotation].y, math_c_pi), 0.0f },
      { 0.0f, 0.0f, 0.0f, 1.0f }
    }} *
    (matrix_float4x4) {{
      { 1.0f, 0.0f, 0.0f, 0.0f },
      { 0.0f, math_c_cosine(joints[id_joint_rotation].x, math_c_pi), -math_c_sine(joints[id_joint_rotation].x, math_c_pi), 0.0f },
      { 0.0f, math_c_sine(joints[id_joint_rotation].x, math_c_pi), math_c_cosine(joints[id_joint_rotation].x, math_c_pi), 0.0f },
      { 0.0f, 0.0f, 0.0f, 1.0f }
    }} *
    (matrix_float4x4) {{
      { math_c_cosine(joints[id_joint_rotation].z, math_c_pi), -math_c_sine(joints[id_joint_rotation].z, math_c_pi), 0.0f, 0.0f },
      { math_c_sine(joints[id_joint_rotation].z, math_c_pi), math_c_cosine(joints[id_joint_rotation].z, math_c_pi), 0.0f, 0.0f },
      { 0.0f, 0.0f, 1.0f, 0.0f },
      { 0.0f, 0.0f, 0.0f, 1.0f }
    }}
  );

  float4 position_object = {
    data_object->position.x,
    data_object->position.y,
    data_object->position.z,
    0.0f
  };

  float4 position_vertex_object_relation = (
    vertices[id_vertex] +
    position_object
  );

  float4 position_joint = {
    joints[id_joint_position].x,
    joints[id_joint_position].y,
    joints[id_joint_position].z,
    0.0f
  };

  float4 position_joint_translation = {
    joints[id_joint_translation].x,
    joints[id_joint_translation].y,
    joints[id_joint_translation].z,
    0.0f
  };

  float4 position_vertex_object_relation_offset_joint_origin = (
    position_vertex_object_relation - 
    position_joint
  );

  float4 position_vertex_object_relation_offset_joint_origin_rotated = (
    position_vertex_object_relation_offset_joint_origin *
    matrix_projection_object_with_rotation
  );
  
  float4 position_vertex = (
    position_vertex_object_relation_offset_joint_origin_rotated +
    position_joint +
    position_joint_translation -
    position_object
  );

  data_vertex.position = (
    data_object->view_model_matrix_projection *
    position_vertex
  );

  return data_vertex;
}
```

## using multiple render pipelines

multiple render pipelines are something you should be doing as soon as possible as it allows you to specify different render paths and use multiple different `metal` files during your renditions

you can create an additional render pipeline as such

```obj-c
unsigned short int pipeline_index_text = [
  metil->renderer_interface.renderer
  pipeline_add: [
    metil->library.library
    newFunctionWithName: @"text_fragment"
  ]
  function_vertex: [
    metil->library.library
    newFunctionWithName: @"text_vertex"
  ]
];

unsigned short int pipeline_index_object = [
  metil->renderer_interface.renderer
  pipeline_add: [
    metil->library.library
    newFunctionWithName: @"object_fragment"
  ]
  function_vertex: [
    metil->library.library
    newFunctionWithName: @"object_vertex"
  ]
];
```

then set the pipelines for specific objects to change their default renderings

```obj-c
struct metil_object* metil_object = &(
  metil_scene->renderables[
    0
  ].renderable
);

metil_object->index_pipeline_render = pipeline_index_object;

metil_object = &(
  metil_scene->renderables[
    1
  ].renderable
);

metil_object->index_pipeline_render = pipeline_index_text;
```

## rendering text

text rendering is a bit of convoluted process which can be simplified through the usage of `metil_object_text_initialize` as such

```c
metil_object_text_initialize(
  metil,
  metil_object,
  "Example text rendering::metil"
);
```

which renders text using the default font/size (`monospace 48px`) to a texture, allocates buffers, sets textures, sets vertices/indices as a square the size of the text

[`metil_text`](sources/metil_text/metil_text.m) itself can be utilized for more specific renditions of text by passing specific render properties containing font information, colour spaces, sizes, and then utilizing glyph encoding and text image rendering to create textures to be stored in metal buffers for gpu access

the size of text rendering does not correspond to it's displayed size of resolution but does however set the quality and scale of the text. The higher the initial `size` of text rendering the higher the quality of the font displayed, the actual size however is left up to the scaling factors of the renderer.

for example you can render a font at 10px but display it as 50% of the viewport, and you can also render a font at 100px but display it as 50% of the viewport, in both cases the actual size of the display of the font is the same but the quality of render is drastically different with the `10px` font rendering in a lower quality comparatively to the `100px` font. In essence, font size is nearly equivalent to font quality rather than displayed/percieved sizes.

## audio

`metil` makes use of [`cer0`](https://github.com/alic3dev/cer0) for audio output

audio io_procs can be added using `metil_audio_io_proc_add`

data can be passed to io_procs using `metil_audio_io_proc_add_with_data`

`metil` supports multiple io_procs and will loop through all added io_procs then set the final audio output buffer values as being the value of each individual io_proc divided by the total number of io_procs

io_procs should be removed using `metil_audio_io_proc_remove` when they are no longer in use

macos and ios require two different frameworks for audio output, macos requiring the use of `CoreAudio` and ios requiring the use of `AVFAudio`
because of this the type definition of the io_procs is slightly different and can be conditionally set using the preprocessor macro `target_os_ios`

the current channel can be obtained using a modulus operator on the index of the output buffer frame by the number of channels  
a stereo configuration would have the left channel as channel `0` and the right channel as `1`

every io_proc gets passed a pointer to a `metil_audio_io_proc_data` structure which contains a property for a pointer to `metil` and a parameter `data` for whatever data was passed in using `metil_audio_io_proc_add_with_data` (if `metil_audio_io_proc_add` was used instead then the `data` property is `0`)

```obj-c
void io_proc_set(
  struct metil* metil
) {
  metil_audio_io_proc_add(
    &metil->audio,
    io_proc
  );
}

void io_proc_set_with_data(
  struct metil* metil
  void* data
) {
  metil_audio_io_proc_add_with_data(
    &metil->audio,
    io_proc,
    data
  );
}

void io_proc_remove(
  struct metil* metil
) {
  metil_audio_io_proc_remove(
    &metil->audio,
    io_proc
  );
}

float io_proc_frame_value_get(
  unsigned int channel,
  unsigned int index_frame
) {
  if (
    channel == 0
  ) {
    return (
      (float) (
        index_frame %
        1000
      ) /
      1000.0f
    );
  } else {
    return (
      (float) (
        (
          index_frame *
          2
        ) %
        1000
      ) /
      1000.0f
    );
  }
}

#if target_os_ios
int io_proc(
  unsigned char silence,
  const AudioTimeStamp* _Nonnull timestamp,
  AVAudioFrameCount frame_count,
  AudioBufferList* _Nonnull output_data,
  void* data
) {
  struct metil_audio_io_proc_data* metil_audio_io_proc_data = (
    data
  );

  struct metil* metil = (
    metil_audio_io_proc_data->metil
  );

  // any data passed in through `metil_audio_io_proc_add_with_data`
  struct void* io_proc_data = (
    metil_audio_io_proc_data->data
  );

  for (
    unsigned long int index_buffer = 0;
    index_buffer < output_data->mNumberBuffers;
    ++index_buffer
  ) {
    AudioBuffer audio_buffer_current = output_data->mBuffers[
      index_buffer
    ];

    float* buffer_out = (
      audio_buffer_current.mData
    );

    unsigned long int count_channel_out = (
      audio_buffer_current.mNumberChannels
    );
    
    for (
      unsigned int index_frame = 0;
      index_frame < frame_count;
      ++index_frame
    ) {
      unsigned long int channel = (
        index_frame %
        count_channel_out
      );

      float value_audio = (
        io_proc_frame_value_get(
          channel,
          index_frame
        )
      );

      buffer_out[index_frame] = (
        value_audio
      );
    }
  }
  
  return 0;
}
#else
OSStatus io_proc(
  AudioObjectID id_audio_object,
  const AudioTimeStamp* time_stamp_audio,
  const AudioBufferList* list_buffer_audio_in,
  const AudioTimeStamp* time_stamp_audio_in,
  AudioBufferList* list_buffer_audio_out,
  const AudioTimeStamp* time_stamp_audio_out,
  void* data
) {
  struct metil_audio_io_proc_data* metil_audio_io_proc_data = (
    data
  );

  struct metil* metil = (
    metil_audio_io_proc_data->metil
  );

  // any data passed in through `metil_audio_io_proc_add_with_data`
  struct void* io_proc_data = (
    metil_audio_io_proc_data->data
  );

  for (
    unsigned long int index_buffer = 0;
    index_buffer < list_buffer_audio_out->mNumberBuffers;
    ++index_buffer
  ) {
    AudioBuffer audio_buffer_current = (
      list_buffer_audio_out->mBuffers[
        index_buffer
      ]
    );

    float* buffer_out = (
      audio_buffer_current.mData
    );

    unsigned long int size_buffer_out = (
      audio_buffer_current.mDataByteSize /
      sizeof(
        float
      )
    );

    unsigned long int count_channel_out = (
      audio_buffer_current.mNumberChannels
    );
    
    for (
      unsigned long int index_buffer_out = 0;
      index_buffer_out < size_buffer_out;
      ++index_buffer_out
    ) {
      unsigned long int channel = (
        index_buffer_out %
        count_channel_out
      );

      float value_audio = (
        io_proc_frame_value_get(
          channel,
          index_frame
        )
      );

      buffer_out[
        index_buffer_out
      ] = (
        value_audio
      );
    }
  }

  return 0;
}
#endif
```

## units

`metil` presupposes that 10 units is equivalent to 1 metre

## coordinates

- `x` values go from left to right as `-1.0f` to `1.0f`
- `y` values go from bottom to top as `-1.0f` to `1.0f`
- `z` values go from front to back as `-1.0f` to `1.0f`

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

all rotations are in radians

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

## macos

0: `metil_initialize`
1: `metil_view_controller`
1.0 `viewDidLoad`
2: `metil_renderer`
2.0:`metil->renderer_on_initialize`

## ios

0: `UIApplicationMain`
1: `metil_view_controller`
1.0 `viewDidLoad`
1.1: `metil_view_controller_on_view_did_load`
1.2: `metil_initialize`
2: `metil_renderer`
2.0:`metil->renderer_on_initialize`

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
0.0.1.0: for->{`scene`.`renderables`.as(`renderable`)}
0.0.1.0.0: `switch->{`renderable->type`}
0.0.1.0.0.0: case[`metil_renderable_type_object`]->{`renderable->renderable->destroy()`}
0.0.1.0.0.0.0: `metil_mesh_destroy(renderable->renderable.mesh)`
0.0.1.1: for->{`scene`.`textures`.as(`texture`)}
0.0.1.1.0: `release(texture)`
0.0.1.2: `scene->player.destroy`
1: `interrupt_handler_destroy`
2: `metil_paths_destroy`
3: `metil_audio_destroy`
4: `metil_text_destroy`
5: `metil_configuration_destroy`
6: `metil_renderer_on_termination`
6.0: `metil_renderer->destroy()`
6.0.0: `metil_rendering_properties_destory(metil_renderer->rendering_properties)`
7: [...remaining_added_termination_functions]
```

## development

### prerequisites

see [`usage->linking->[dynamic libraries | static libraries]`](#linking) for further information

- [`alic3dev`](https://github.com/alic3dev)
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
- `target_metal_standard`:sets_the_target_metal_standard::(will_use->{`metal4.0`}_if_not_set)
- `target_metal_version`:sets_the_target_metal_version::(will_use->{`target_device_version`}_if_not_set)
- - platforms
- - - macos->{`arm64-apple-macos${target_metal_version}`}
- - - ios->{`arm64-apple-ios${target_metal_version}`}

```zsh
# build a debugging version of metil
make metil debug=1

# build metil for macos version 26.1 with fast modes disabled for metal
make metil disable_metal_fast_options=1 target_device_version=26.1

# build an ios version of metil
make target_device=iphone
```

## usage

## projects

### macos

#### [`alic3dev`](https://github.com/alic3dev)

| [`c938`](https://github.com/alic3dev/c938) | [`zoe`](https://github.com/alic3dev/zoe) |
|---|---|
| <img width="640" height="407" alt="metil_zoe" src="https://github.com/user-attachments/assets/9ead54e1-db21-4145-ac1a-43993314c008" /> | <img width="1966" height="1250" alt="metil_c938" src="https://github.com/user-attachments/assets/536659aa-13e7-4591-848f-75aec95834ab" /> |

### ios

#### [`alic3dev`](https://github.com/alic3dev)

| [`ff`](https://github.com/alic3dev/ff) |
|---|
| <img width="590" height="1278" alt="metil_ff_ios" src="https://github.com/user-attachments/assets/a2b1407c-98ee-461a-96c1-2fe989a8bf45" /> |

## examples

| [2d_rendering](examples/2d_rendering/) | [3d_rendering](examples/3d_rendering/) | [face](examples/face/) |
|-------|-----|---|
| <img width="1966" height="1250" alt="metil_example_2d_rendering" src="https://github.com/user-attachments/assets/d61f70f0-7c05-4772-8fad-df52e550899f" /> | <img width="1966" height="1250" alt="metil_example_3d_rendering" src="https://github.com/user-attachments/assets/6da49b26-0001-4e5c-8af4-47191ac57aa5" /> | <img width="1966" height="1250" alt="metil_example_face" src="https://github.com/user-attachments/assets/466184c5-c724-4f80-b0c7-fa34aa55e7c2" /> |

| [fog](examples/fog/) | [model](examples/model/) |
|-------|-----|
| https://github.com/user-attachments/assets/0639ef29-43d6-4eb0-b12c-c42b1afd91ae | https://github.com/user-attachments/assets/6e3675f2-b369-4596-9d4f-ee68e24b98fe | 

## copyright|copyleft

> © [copyleft|copyright]->{alic3dev(2025|2026)}:[all_rights_reserved|all_lefts_reserved]
