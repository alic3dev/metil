#include <metil_configuration/metil_configuration.h>

#include <metil_audio/metil_audio_data.h>
#include <metil_debug/metil_log.h>
#include <metil_paths/metil_paths.h>

#include <clic3_bytes.h>
#include <clic3_char_arrays.h>

#include <limits.h>
#include <stdlib.h>
#include <stdio.h>

void metil_configuration_initialize(
  struct metil_configuration* metil_configuration
) {
  metil_configuration->audio.volume = (
    metil_configuration_default_audio_volume
  );

  metil_configuration_rendering_properties_initialize(
    &metil_configuration->rendering_properties
  );
}

unsigned char metil_configuration_load(
  struct metil_configuration* metil_configuration
) {
  metil_configuration_initialize(
    metil_configuration
  );

  unsigned char status_configuration_load = 0;

  FILE* file_configuration = fopen(
    metil_paths.file_configuration,
    "a+"
  );

  rewind(file_configuration);

  if (
    file_configuration == (void*)0
  ) {
    metil_debug_log_error(
      "failed_to_[open|create]->{configuration}"
    );

    status_configuration_load = 1;

    return status_configuration_load;
  }

  char* buffer;
  unsigned int length_buffer = 0;

  buffer = malloc(
    sizeof(char) *
    length_buffer
  );

  while (
    feof(file_configuration) == 0 &&
    status_configuration_load == 0
  ) {
    char c = getc(file_configuration);

    if (
      length_buffer + 1 >= UINT_MAX - 1
    ) {
      metil_debug_log_error(
        "configuration_file_contains_too_long_of_a_line"
      );

      status_configuration_load = 1;

      break;
    }

    if (
      c == EOF ||
      c == '\n'
    ) {
      if (length_buffer != 0) {
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
            "invalid_configuration_file"
          );

          status_configuration_load = 1;

          break;
        }

        char* buffer_parameter;
        unsigned int length_buffer_parameter = (
          index_pointer
        );

        buffer_parameter = malloc(
          sizeof(char) * length_buffer_parameter + 1
        );

        clic3_bytes_copy(
          buffer_parameter,
          buffer,
          length_buffer_parameter
        );

        buffer_parameter[length_buffer_parameter] = '\0';

        char* buffer_value;
        unsigned int length_buffer_value = (
          (length_buffer - 2) -
          (index_pointer + 3)
        );

        buffer_value = malloc(
          sizeof(char) * length_buffer_value + 1
        );

        clic3_bytes_copy(
          buffer_value,
          buffer + index_pointer + 3,
          length_buffer_value
        );

        buffer_value[length_buffer_value] = '\0';

        int index_parameter = clic3_char_arrays_within(
          buffer_parameter,
          4,
          "audio:volume",
          "rendering_properties:brightness",
          "rendering_properties:brightness_text",
          "rendering_properties:fps_display"
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
            message_debug_log_error
          );

          free(message_debug_log_error_prefix);
          free(message_debug_log_error);

          status_configuration_load = 1;

          break;
        }

        switch (index_parameter) {
          case 0: {
            float audio_volume = metil_configuration_value_float_parse(
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
        }

        free(buffer_parameter);
        free(buffer_value);

        length_buffer = 0;
      }
    } else {
      length_buffer = (
        length_buffer + 1
      );

      buffer = realloc(
        buffer,
        sizeof(char) * length_buffer
      );

      buffer[
        length_buffer - 1
      ] = c;
    }
  }

  free(buffer);

  fclose(file_configuration);

  return status_configuration_load;
}

int metil_configuration_value_int_parse(
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
      parameter,
      value
    );

    return -1;
  }

  return value_int;
}

float metil_configuration_value_float_parse(
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
      parameter,
      value
    );

    return -1.0f;
  }

  return value_float;
}

void metil_configuration_debug_log_parameter_invalid(
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
    message_debug_log_error
  );

  free(
    message_debug_log_error_prefix
  );

  free(
    message_debug_log_error_split
  );

  free(
    message_debug_log_error_value
  );

  free(
    message_debug_log_error
  );
}

void metil_configuration_values_set(
  struct metil_configuration* metil_configuration
) {
  #if !target_os_ios
  metil_audio_data.volume = metil_configuration->audio.volume;
  #endif
}

void metil_configuration_destroy(
  struct metil_configuration* metil_configuration
) {}
