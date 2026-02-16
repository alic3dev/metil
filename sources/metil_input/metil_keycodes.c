#include <metil_input/metil_keycodes.h>

unsigned char metil_keycode_from_char_shift_required(
  unsigned char character
) {
  switch (
    character
  ) {
    case '~':
    case '!':
    case '@':
    case '#':
    case '$':
    case '%':
    case '^':
    case '&':
    case '*':
    case '(':
    case ')':
    case '_':
    case '+':
    case '{':
    case '}':
    case '|':
    case ':':
    case '"':
    case '<':
    case '>':
    case '?': {
      return (
        1
      );
    }
    default: {
      break;
    }
  }

  if (
    character >= 'A' &&
    character <= 'Z'
  ) {
    return (
      1
    );
  }

  return (
    0
  );
}

unsigned char metil_keycode_from_char(
  unsigned char character
) {
  switch (
    character
  ) {
    case 'A':
    case 'a': {
      return (
        metil_keycode_a
      );
    }
    case 'S':
    case 's': {
      return (
        metil_keycode_s
      );
    }
    case 'D':
    case 'd': {
      return (
        metil_keycode_d
      );
    }
    case 'F':
    case 'f': {
      return (
        metil_keycode_f
      );
    }
    case 'H':
    case 'h': {
      return (
        metil_keycode_h
      );
    }
    case 'G':
    case 'g': {
      return (
        metil_keycode_g
      );
    }
    case 'Z':
    case 'z': {
      return (
        metil_keycode_z
      );
    }
    case 'X':
    case 'x': {
      return (
        metil_keycode_x
      );
    }
    case 'C':
    case 'c': {
      return (
        metil_keycode_c
      );
    }
    case 'V':
    case 'v': {
      return (
        metil_keycode_v
      );
    }
    case 'B':
    case 'b': {
      return (
        metil_keycode_b
      );
    }
    case 'Q':
    case 'q': {
      return (
        metil_keycode_q
      );
    }
    case 'W':
    case 'w': {
      return (
        metil_keycode_w
      );
    }
    case 'E':
    case 'e': {
      return (
        metil_keycode_e
      );
    }
    case 'R':
    case 'r': {
      return (
        metil_keycode_r
      );
    }
    case 'Y':
    case 'y': {
      return (
        metil_keycode_y
      );
    }
    case 'T':
    case 't': {
      return (
        metil_keycode_t
      );
    }
    case '!':
    case '1': {
      return (
        metil_keycode_1
      );
    }
    case '@':
    case '2': {
      return (
        metil_keycode_2
      );
    }
    case '#':
    case '3': {
      return (
        metil_keycode_3
      );
    }
    case '$':
    case '4': {
      return (
        metil_keycode_4
      );
    }
    case '^':
    case '6': {
      return (
        metil_keycode_6
      );
    }
    case '%':
    case '5': {
      return (
        metil_keycode_5
      );
    }
    case '+':
    case '=': {
      return (
        metil_keycode_equals
      );
    }
    case '(':
    case '9': {
      return (
        metil_keycode_9
      );
    }
    case '&':
    case '7': {
      return (
        metil_keycode_7
      );
    }
    case '_':
    case '-': {
      return (
        metil_keycode_minus
      );
    }
    case '*':
    case '8': {
      return (
        metil_keycode_8
      );
    }
    case ')':
    case '0': {
      return (
        metil_keycode_0
      );
    }
    case '}':
    case ']': {
      return (
        metil_keycode_closing_square_bracket
      );
    }
    case 'O':
    case 'o': {
      return (
        metil_keycode_o
      );
    }
    case 'U':
    case 'u': {
      return (
        metil_keycode_u
      );
    }
    case '{':
    case '[': {
      return (
        metil_keycode_opening_square_bracket
      );
    }
    case 'I':
    case 'i': {
      return (
        metil_keycode_i
      );
    }
    case 'P':
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
    case 'L':
    case 'l': {
      return (
        metil_keycode_l
      );
    }
    case 'J':
    case 'j': {
      return (
        metil_keycode_j
      );
    }
    case '\"':
    case '\'': {
      return (
        metil_keycode_single_quote
      );
    }
    case 'K':
    case 'k': {
      return (
        metil_keycode_k
      );
    }
    case ':':
    case ';': {
      return (
        metil_keycode_semi_colon
      );
    }
    case '|':
    case '\\': {
      return (
        metil_keycode_back_slash
      );
    }
    case '<':
    case ',': {
      return (
        metil_keycode_comma
      );
    }
    case '?':
    case '/': {
      return (
        metil_keycode_slash
      );
    }
    case 'N':
    case 'n': {
      return (
        metil_keycode_n
      );
    }
    case 'M':
    case 'm': {
      return (
        metil_keycode_m
      );
    }
    case '>':
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
    case '~':
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
