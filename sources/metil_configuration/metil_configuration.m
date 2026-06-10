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

  unsigned char status_configuration_load = (
    0x00
  );

  FILE* file_configuration = fopen(
    metil_paths->file_configuration,
    "a+"
  );

  rewind(
    file_configuration
  );

  if (
    file_configuration ==
    0x00
  ) {
    metil_debug_log_error(
      metil_configuration->debug_log_level,
      "failed_to_[open|create]->{configuration}"
    );

    status_configuration_load = (
      status_configuration_load +
      0x01
    );

    return (
      status_configuration_load
    );
  }

  unsigned int length_buffer = (
    0x00
  );

  char* buffer = (
    clic3_memory_allocate_raw(
      length_buffer
    )
  );

  while (
    feof(
      file_configuration
    ) ==
    0x00
  ) {
    char c = (
      getc(
        file_configuration
      )
    );

    if (
      (
        length_buffer +
        0x01
      ) >= (
        UINT_MAX -
        0x01
      )
    ) {
      metil_debug_log_error(
        metil_configuration->debug_log_level,
        "configuration_file_contains_too_long_of_a_line"
      );

      status_configuration_load = (
        status_configuration_load +
        0x01
      );

      length_buffer = (
        0x00
      );

      continue;
    }

    if (
      (
        c ==
        EOF
      ) ||
      (
        c ==
        '\n'
      )
    ) {
      if (
        length_buffer !=
        0x00
      ) {
        unsigned int index_pointer = (
          0x00
        );

        for (
          unsigned int index_buffer = (
            0x00
          );
          (
            index_buffer <
            length_buffer
          );
          ++index_buffer
        ) {
          if (
            buffer[
              index_buffer
            ] ==
            '-'
          ) {
            index_pointer = (
              index_buffer
            );
            
            break;
          }
        }

        if (
          (
            index_pointer ==
            0x00
          ) ||
          (
            (
              index_pointer +
              0x05
            ) >=
            length_buffer
          ) ||
          (
            buffer[
              index_pointer +
              0x01
            ] !=
            '>'
          ) ||
          (
            buffer[
              index_pointer +
              0x02
            ] !=
            '{'
          ) ||
          (
            buffer[
              length_buffer -
              0x02
            ] !=
            '}'
          ) ||
          (
            buffer[
              length_buffer -
              0x01
            ] !=
            ';'
          )
        ) {
          metil_debug_log_error(
            metil_configuration->debug_log_level,
            "invalid_configuration_file"
          );

          status_configuration_load = (
            status_configuration_load +
            0x01
          );

          break;
        }

        unsigned int length_buffer_parameter = (
          index_pointer
        );

        char* buffer_parameter = (
          clic3_memory_allocate_raw(
            length_buffer_parameter +
            0x01
          )
        );

        clic3_bytes_copy(
          buffer_parameter,
          buffer,
          length_buffer_parameter
        );

        buffer_parameter[
          length_buffer_parameter
        ] = (
          '\0'
        );

        unsigned int length_buffer_value = (
          (
            length_buffer -
            0x02
          ) -
          (
            index_pointer +
            0x03
          )
        );

        char* buffer_value = (
          clic3_memory_allocate_raw(
            length_buffer_value +
            0x01
          )
        );

        clic3_bytes_copy(
          buffer_value,
          (
            buffer +
            index_pointer +
            0x03
          ),
          length_buffer_value
        );

        buffer_value[
          length_buffer_value
        ] = (
          '\0'
        );

        int index_parameter = clic3_char_arrays_within(
          buffer_parameter,
          #if !target_os_ios
          0x09,
          #else
          0x08,
          #endif
          "audio:volume",
          "rendering_properties:brightness",
          "rendering_properties:brightness_text",
          "rendering_properties:fps_display",
          "rendering_properties:colour_fps_display_r",
          "rendering_properties:colour_fps_display_g",
          "rendering_properties:colour_fps_display_b",
          "rendering_properties:colour_fps_display_a"
          #if !target_os_ios
          ,
          "rendering_properties:display_sync"
          #endif
        );

        switch (
          index_parameter
        ) {
          case -0x01: {
            char* message_debug_log_error_prefix = (
              clic3_char_arrays_concatenate(
                "unknown_configuration_parameter->{",
                buffer_parameter
              )
            );

            char* message_debug_log_error = (
              clic3_char_arrays_concatenate(
                message_debug_log_error_prefix,
                "};\n"
              )
            );

            metil_debug_log_error(
              metil_configuration->debug_log_level,
              message_debug_log_error
            );

            clic3_memory_free_raw(
              message_debug_log_error_prefix
            );

            clic3_memory_free_raw(
              message_debug_log_error
            );

            status_configuration_load = (
              status_configuration_load +
              0x01
            );

            break;
          }
          case 0x00: {
            float audio_volume = (
              metil_configuration_value_float_parse(
                metil_configuration,
                buffer_parameter,
                buffer_value
              )
            );

            if (
              audio_volume >=
              0x00
            ) {
              metil_configuration->audio.volume = (
                audio_volume
              );
            } else {
              status_configuration_load = (
                status_configuration_load +
                0x01
              );
            }

            break;
          }
          case 0x01: {
            float rendering_brightness = (
              metil_configuration_value_float_parse(
                metil_configuration,
                buffer_parameter,
                buffer_value
              )
            );

            if (
              rendering_brightness >=
              0x00
            ) {
              metil_configuration->rendering_properties.brightness = (
                rendering_brightness
              );
            } else {
              status_configuration_load = (
                status_configuration_load +
                0x01
              );
            }

            break;
          }
          case 0x02: {
            float rendering_brightness_text = (
              metil_configuration_value_float_parse(
                metil_configuration,
                buffer_parameter,
                buffer_value
              )
            );

            if (
              rendering_brightness_text >=
              0x00
            ) {
              metil_configuration->rendering_properties.brightness_text = (
                rendering_brightness_text
              );
            } else {
              status_configuration_load = (
                status_configuration_load +
                0x01
              );
            }

            break;
          }
          case 0x03: {
            int fps_display = (
              metil_configuration_value_int_parse(
                metil_configuration,
                buffer_parameter,
                buffer_value
              )
            );

            if (
              fps_display !=
              -0x01
            ) {
              metil_configuration->rendering_properties.fps_display = (
                fps_display
              );
            } else {
              status_configuration_load = (
                status_configuration_load +
                0x01
              );
            }

            break;
          }
          case 0x04: {
            float colour_fps_display_r = metil_configuration_value_float_parse(
              metil_configuration,
              buffer_parameter,
              buffer_value
            );

            if (
              (
                colour_fps_display_r >=
                0x00
              ) &&
              (
                colour_fps_display_r <=
                0x01
              )
            ) {
              metil_configuration->rendering_properties.colour_fps_display.x = (
                colour_fps_display_r
              );
            } else {
              status_configuration_load = (
                status_configuration_load +
                0x01
              );
            }

            break;
          }
          case 0x05: {
            float colour_fps_display_g = metil_configuration_value_float_parse(
              metil_configuration,
              buffer_parameter,
              buffer_value
            );

            if (
              (
                colour_fps_display_g >=
                0x00
              ) &&
              (
                colour_fps_display_g <=
                0x01
              )
            ) {
              metil_configuration->rendering_properties.colour_fps_display.y = (
                colour_fps_display_g
              );
            } else {
              status_configuration_load = (
                status_configuration_load +
                0x01
              );
            }

            break;
          }
          case 0x06: {
            float colour_fps_display_b = (
              metil_configuration_value_float_parse(
                metil_configuration,
                buffer_parameter,
                buffer_value
              )
            );

            if (
              (
                colour_fps_display_b >=
                0x00
              ) &&
              (
                colour_fps_display_b <=
                0x01
              )
            ) {
              metil_configuration->rendering_properties.colour_fps_display.z = (
                colour_fps_display_b
              );
            } else {
              status_configuration_load = (
                status_configuration_load +
                0x01
              );
            }

            break;
          }
          case 0x07: {
            float colour_fps_display_a = (
              metil_configuration_value_float_parse(
                metil_configuration,
                buffer_parameter,
                buffer_value
              )
            );

            if (
              (
                colour_fps_display_a >=
                0x00
              ) &&
              (
                colour_fps_display_a <=
                0x01
              )
            ) {
              metil_configuration->rendering_properties.colour_fps_display.w = (
                colour_fps_display_a
              );
            } else {
              status_configuration_load = (
                status_configuration_load +
                0x01
              );
            }

            break;
          }
          #if !target_os_ios
          case 0x08: {
            int display_sync = (
              metil_configuration_value_int_parse(
                metil_configuration,
                buffer_parameter,
                buffer_value
              )
            );

            if (
              (
                display_sync ==
                0x00
              ) ||
              (
                display_sync ==
                0x01
              )
            ) {
              metil_configuration->rendering_properties.display_sync = (
                display_sync
              );
            } else {
              status_configuration_load = (
                status_configuration_load +
                0x01
              );
            }

            break;
          }
          #endif
        }

        clic3_memory_free_raw(
          buffer_parameter
        );

        clic3_memory_free_raw(
          buffer_value
        );

        length_buffer = (
          0x00
        );
      }
    } else {
      length_buffer = (
        length_buffer +
        0x01
      );

      clic3_memory_reallocate_raw(
        &buffer,
        length_buffer
      );

      buffer[
        length_buffer -
        0x01
      ] = (
        c
      );
    }
  }

  clic3_memory_free_raw(
    buffer
  );

  fclose(
    file_configuration
  );

  return (
    status_configuration_load
  );
}

int metil_configuration_value_int_parse(
  struct metil_configuration* metil_configuration,
  char* parameter,
  char* value
) {
  int value_int;

  unsigned char valid_parameter = (
    clic3_char_array_to_int(
      value,
      &value_int
    )
  );

  if (
    (
      valid_parameter !=
      0x00
    ) ||
    (
      value_int !=
      0x00
    ) &&
    (
      value_int !=
      0x01
    )
  ) {
    metil_configuration_debug_log_parameter_invalid(
      metil_configuration,
      parameter,
      value
    );

    return -(
      0x01
    );
  }

  return (
    value_int
  );
}

float metil_configuration_value_float_parse(
  struct metil_configuration* metil_configuration,
  char* parameter,
  char* value
) {
  float value_float;

  unsigned char valid_parameter = (
    clic3_char_array_to_float(
      value,
      &value_float
    )
  );

  if (
    (
      valid_parameter !=
      0x00
    ) ||
    (
      value_float <
      0x00
    )
  ) {
    metil_configuration_debug_log_parameter_invalid(
      metil_configuration,
      parameter,
      value
    );

    return -(
      0x01
    );
  }

  return (
    value_float
  );
}

void metil_configuration_debug_log_parameter_invalid(
  struct metil_configuration* metil_configuration,
  char* parameter,
  char* value
) {
  char* message_debug_log_error_prefix = (
    clic3_char_arrays_concatenate(
      "invalid_configuration_value->{",
      parameter
    )
  );

  char* message_debug_log_error_split = (
    clic3_char_arrays_concatenate(
      message_debug_log_error_prefix,
      ":"
    )
  );

  char* message_debug_log_error_value = (
    clic3_char_arrays_concatenate(
      message_debug_log_error_split,
      value
    )
  );

  char* message_debug_log_error = (
    clic3_char_arrays_concatenate(
      message_debug_log_error_value,
      "};\n"
    )
  );

  metil_debug_log_error(
    metil_configuration->debug_log_level,
    message_debug_log_error
  );

  clic3_memory_free_raw(
    message_debug_log_error_prefix
  );

  clic3_memory_free_raw(
    message_debug_log_error_split
  );

  clic3_memory_free_raw(
    message_debug_log_error_value
  );

  clic3_memory_free_raw(
    message_debug_log_error
  );
}

void metil_configuration_destroy(
  struct metil_configuration* metil_configuration
) {
}
