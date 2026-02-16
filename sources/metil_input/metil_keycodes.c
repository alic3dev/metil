#include <metil_input/metil_keycodes.h>

unsigned char metil_keycode_from_char(
  unsigned char character
) {
  switch (
    character
  ) {
    case 'a': {
      return (
        metil_keycode_a
      );
    }
    case 's': {
      return (
        metil_keycode_s
      );
    }
    case 'd': {
      return (
        metil_keycode_d
      );
    }
    case 'f': {
      return (
        metil_keycode_f
      );
    }
    case 'h': {
      return (
        metil_keycode_h
      );
    }
    case 'g': {
      return (
        metil_keycode_g
      );
    }
    case 'z': {
      return (
        metil_keycode_z
      );
    }
    case 'x': {
      return (
        metil_keycode_x
      );
    }
    case 'c': {
      return (
        metil_keycode_c
      );
    }
    case 'v': {
      return (
        metil_keycode_v
      );
    }
    case 'b': {
      return (
        metil_keycode_b
      );
    }
    case 'q': {
      return (
        metil_keycode_q
      );
    }
    case 'w': {
      return (
        metil_keycode_w
      );
    }
    case 'e': {
      return (
        metil_keycode_e
      );
    }
    case 'r': {
      return (
        metil_keycode_r
      );
    }
    case 'y': {
      return (
        metil_keycode_y
      );
    }
    case 't': {
      return (
        metil_keycode_t
      );
    }
    case '1': {
      return (
        metil_keycode_1
      );
    }
    case '2': {
      return (
        metil_keycode_2
      );
    }
    case '3': {
      return (
        metil_keycode_3
      );
    }
    case '4': {
      return (
        metil_keycode_4
      );
    }
    case '6': {
      return (
        metil_keycode_6
      );
    }
    case '5': {
      return (
        metil_keycode_5
      );
    }
    case '=': {
      return (
        metil_keycode_equals
      );
    }
    case '9': {
      return (
        metil_keycode_9
      );
    }
    case '7': {
      return (
        metil_keycode_7
      );
    }
    case '-': {
      return (
        metil_keycode_minus
      );
    }
    case '8': {
      return (
        metil_keycode_8
      );
    }
    case '0': {
      return (
        metil_keycode_0
      );
    }
    case ']': {
      return (
        metil_keycode_closing_square_bracket
      );
    }
    case 'o': {
      return (
        metil_keycode_o
      );
    }
    case 'u': {
      return (
        metil_keycode_u
      );
    }
    case '[': {
      return (
        metil_keycode_opening_square_bracket
      );
    }
    case 'i': {
      return (
        metil_keycode_i
      );
    }
    case 'p': {
      return (
        metil_keycode_p
      );
    }
    case '\n': {
      return (
        metil_keycode_return
      );
    }
    case 'l': {
      return (
        metil_keycode_l
      );
    }
    case 'j': {
      return (
        metil_keycode_j
      );
    }
    case '\'': {
      return (
        metil_keycode_single_quote
      );
    }
    case 'k': {
      return (
        metil_keycode_k
      );
    }
    case ';': {
      return (
        metil_keycode_semi_colon
      );
    }
    case '\\': {
      return (
        metil_keycode_back_slash
      );
    }
    case ',': {
      return (
        metil_keycode_comma
      );
    }
    case '/': {
      return (
        metil_keycode_slash
      );
    }
    case 'n': {
      return (
        metil_keycode_n
      );
    }
    case 'm': {
      return (
        metil_keycode_m
      );
    }
    case '.': {
      return (
        metil_keycode_period
      );
    }
    case '\t': {
      return (
        metil_keycode_tab
      );
    }
    case ' ': {
      return (
        metil_keycode_space
      );
    }
    case '`': {
      return (
        metil_keycode_back_tick
      );
    }
  }

  return (
    0xff
  );
}
