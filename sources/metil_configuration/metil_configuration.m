#include <metil_configuration/metil_configuration.h>

#include <metil.h>
#include <metil_audio/metil_audio_data.h>
#include <metil_debug/metil_debug_log.h>
#include <metil_paths/metil_paths.h>

#include <clic3_bytes.h>
#include <clic3_char_arrays.h>
#include <clic3_memory.h>

#include <limits.h>
#include <stdio.h>

void metil_configuration_initialize(
  struct metil_configuration* metil_configuration
) {
  metil_configuration->audio.volume = (
    metil_configuration_default_audio_volume
  );

  metil_configuration->debug_log_level = (
    metil_debug_log_level_error
  );

  metil_configuration_rendering_properties_initialize(
    &metil_configuration->rendering_properties
  );
}

unsigned char metil_configuration_load(
  struct metil_configuration* metil_configuration,
  struct metil_paths* metil_paths
) {
  metil_configuration_initialize(
    metil_configuration
  );

  unsigned char status_configuration_load = 0;

  FILE* file_configuration = fopen(
    metil_paths->file_configuration,
    "a+"
  );

  rewind(
    file_configuration
  );

  if (
    file_configuration == 0
  ) {
    metil_debug_log_error(
      metil_configuration->debug_log_level,
      "failed_to_[open|create]->{configuration}"
    );

    status_configuration_load = 1;

    return status_configuration_load;
  }

  char* buffer = 0;
  unsigned int length_buffer = 0;

  clic3_memory_allocate(
    &buffer,
    length_buffer
  );

  while (
    feof(file_configuration) == 0 &&
    status_configuration_load == 0
  ) {
    char c = (
      getc(
        file_configuration
      )
    );

    if (
      (
        length_buffer +
        1
      ) >= (
        UINT_MAX -
        1
      )
    ) {
      metil_debug_log_error(
        metil_configuration->debug_log_level,
        "configuration_file_contains_too_long_of_a_line"
      );

      status_configuration_load = 1;

      break;
    }

    if (
      c == EOF ||
      c == '\n'
    ) {
      if (
        length_buffer != 0
      ) {
        unsigned int index_pointer = 0;

        for (
          unsigned int index_buffer = 0;
          index_buffer < length_buffer;
          ++index_buffer
        ) {
          if (
            buffer[
              index_buffer
            ] == '-'
          ) {
            index_pointer = index_buffer;
            break;
          }
        }

        if (
          index_pointer == 0 ||
          index_pointer + 5 >= length_buffer ||
          buffer[index_pointer + 1] != '>' ||
          buffer[index_pointer + 2] != '{' ||
          buffer[length_buffer - 2] != '}' ||
          buffer[length_buffer - 1] != ';'
        ) {
          metil_debug_log_error(
            metil_configuration->debug_log_level,
            "invalid_configuration_file"
          );

          status_configuration_load = 1;

          break;
        }

        char* buffer_parameter = 0;
        unsigned int length_buffer_parameter = (
          index_pointer
        );

        clic3_memory_allocate(
          &buffer_parameter,
          (
            length_buffer_parameter +
            1
          )
        );

        clic3_bytes_copy(
          buffer_parameter,
          buffer,
          length_buffer_parameter
        );

        buffer_parameter[
          length_buffer_parameter
        ] = '\0';

        char* buffer_value = 0;
        unsigned int length_buffer_value = (
          (length_buffer - 2) -
          (index_pointer + 3)
        );

        clic3_memory_allocate(
          &buffer_value,
          (
            length_buffer_value +
            1
          )
        );

        clic3_bytes_copy(
          buffer_value,
          buffer + index_pointer + 3,
          length_buffer_value
        );

        buffer_value[
          length_buffer_value
        ] = '\0';

        int index_parameter = clic3_char_arrays_within(
          buffer_parameter,
          8,
          "audio:volume",
          "rendering_properties:brightness",
          "rendering_properties:brightness_text",
          "rendering_properties:fps_display",
          "rendering_properties:color_fps_display_r",
          "rendering_properties:color_fps_display_g",
          "rendering_properties:color_fps_display_b",
          "rendering_properties:color_fps_display_a"
        );

        if (
          index_parameter == -1
        ) {
          char* message_debug_log_error_prefix = clic3_char_arrays_concatenate(
            "unknown_configuration_parameter->{",
            buffer_parameter
          );

          char* message_debug_log_error = clic3_char_arrays_concatenate(
            message_debug_log_error,
            "};\n"
          );

          metil_debug_log_error(
            metil_configuration->debug_log_level,
            message_debug_log_error
          );

          clic3_memory_free(
            message_debug_log_error_prefix
          );

          clic3_memory_free(
            message_debug_log_error
          );

          status_configuration_load = 1;

          break;
        }

        switch (index_parameter) {
          case 0: {
            float audio_volume = metil_configuration_value_float_parse(
              metil_configuration,
              buffer_parameter,
              buffer_value
            );

            if (audio_volume >= 0.0f) {
              metil_configuration->audio.volume = audio_volume;
            } else {
              status_configuration_load = 1;
            }

            break;
          }
          case 1: {
            float rendering_brightness = metil_configuration_value_float_parse(
              metil_configuration,
              buffer_parameter,
              buffer_value
            );

            if (rendering_brightness >= 0.0f) {
              metil_configuration->rendering_properties.brightness = rendering_brightness;
            } else {
              status_configuration_load = 1;
            }

            break;
          }
          case 2: {
            float rendering_brightness_text = metil_configuration_value_float_parse(
              metil_configuration,
              buffer_parameter,
              buffer_value
            );

            if (rendering_brightness_text >= 0.0f) {
              metil_configuration->rendering_properties.brightness_text = rendering_brightness_text;
            } else {
              status_configuration_load = 1;
            }

            break;
          }
          case 3: {
            int fps_display = metil_configuration_value_int_parse(
              metil_configuration,
              buffer_parameter,
              buffer_value
            );

            if (
              fps_display != -1
            ) {
              metil_configuration->rendering_properties.fps_display = fps_display;
            } else {
              status_configuration_load = 1;
            }

            break;
          }
          case 4: {
            float color_fps_display_r = metil_configuration_value_float_parse(
              metil_configuration,
              buffer_parameter,
              buffer_value
            );

            if (
              color_fps_display_r >= 0.0f &&
              color_fps_display_r <= 1.0f
            ) {
              metil_configuration->rendering_properties.color_fps_display.x = (
                color_fps_display_r
              );
            } else {
              status_configuration_load = 1;
            }
            
            break;
          }
          case 5: {
            float color_fps_display_g = metil_configuration_value_float_parse(
              metil_configuration,
              buffer_parameter,
              buffer_value
            );

            if (
              color_fps_display_g >= 0.0f &&
              color_fps_display_g <= 1.0f
            ) {
              metil_configuration->rendering_properties.color_fps_display.y = (
                color_fps_display_g
              );
            } else {
              status_configuration_load = 1;
            }

            break;
          }
          case 6: {
            float color_fps_display_b = metil_configuration_value_float_parse(
              metil_configuration,
              buffer_parameter,
              buffer_value
            );

            if (
              color_fps_display_b >= 0.0f &&
              color_fps_display_b <= 1.0f
            ) {
              metil_configuration->rendering_properties.color_fps_display.z = (
                color_fps_display_b
              );
            } else {
              status_configuration_load = 1;
            }

            break;
          }
          case 7: {
            float color_fps_display_a = metil_configuration_value_float_parse(
              metil_configuration,
              buffer_parameter,
              buffer_value
            );

            if (
              color_fps_display_a >= 0.0f &&
              color_fps_display_a <= 1.0f
            ) {
              metil_configuration->rendering_properties.color_fps_display.w = (
                color_fps_display_a
              );
            } else {
              status_configuration_load = 1;
            }

            break;
          }
        }

        clic3_memory_free(
          buffer_parameter
        );

        clic3_memory_free(
          buffer_value
        );
                      
        length_buffer = 0;
      }
    } else {
      length_buffer = (
        length_buffer + 1
      );

      clic3_memory_allocate(
        &buffer,
        length_buffer
      );

      buffer[
        length_buffer - 1
      ] = (
        c
      );
    }
  }

  clic3_memory_free(buffer);

  fclose(file_configuration);

  return status_configuration_load;
}

int metil_configuration_value_int_parse(
  struct metil_configuration* metil_configuration,
  char* parameter,
  char* value
) {
  int value_int;

  unsigned char valid_parameter = clic3_char_array_to_int(
    value,
    &value_int
  );

  if (
    valid_parameter != 0 ||
    value_int != 0 &&
    value_int != 1
  ) {
    metil_configuration_debug_log_parameter_invalid(
      metil_configuration,
      parameter,
      value
    );

    return -1;
  }

  return value_int;
}

float metil_configuration_value_float_parse(
  struct metil_configuration* metil_configuration,
  char* parameter,
  char* value
) {
  float value_float;

  unsigned char valid_parameter = clic3_char_array_to_float(
    value,
    &value_float
  );

  if (
    valid_parameter != 0 ||
    value_float < 0.0f
  ) {
    metil_configuration_debug_log_parameter_invalid(
      metil_configuration,
      parameter,
      value
    );

    return -1.0f;
  }

  return value_float;
}

void metil_configuration_debug_log_parameter_invalid(
  struct metil_configuration* metil_configuration,
  char* parameter,
  char* value
) {
  char* message_debug_log_error_prefix = clic3_char_arrays_concatenate(
    "invalid_configuration_value->{",
    parameter
  );

  char* message_debug_log_error_split = clic3_char_arrays_concatenate(
    message_debug_log_error_prefix,
    ":"
  );

  char* message_debug_log_error_value = clic3_char_arrays_concatenate(
    message_debug_log_error_split,
    value
  );

  char* message_debug_log_error = clic3_char_arrays_concatenate(
    message_debug_log_error_value,
    "};\n"
  );

  metil_debug_log_error(
    metil_configuration->debug_log_level,
    message_debug_log_error
  );

  clic3_memory_free(
    message_debug_log_error_prefix
  );

  clic3_memory_free(
    message_debug_log_error_split
  );

  clic3_memory_free(
    message_debug_log_error_value
  );

  clic3_memory_free(
    message_debug_log_error
  );
}

void metil_configuration_destroy(
  struct metil_configuration* metil_configuration
) {}
