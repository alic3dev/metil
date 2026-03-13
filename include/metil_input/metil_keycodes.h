#ifndef __metil_input_metil_keycodes_h
#define __metil_input_metil_keycodes_h

#define metil_keycode_a 0
#define metil_keycode_s 1
#define metil_keycode_d 2
#define metil_keycode_f 3
#define metil_keycode_h 4
#define metil_keycode_g 5
#define metil_keycode_z 6
#define metil_keycode_x 7
#define metil_keycode_c 8
#define metil_keycode_v 9
#define metil_keycode_b 11
#define metil_keycode_q 12
#define metil_keycode_w 13
#define metil_keycode_e 14
#define metil_keycode_r 15
#define metil_keycode_y 16
#define metil_keycode_t 17
#define metil_keycode_1 18
#define metil_keycode_2 19
#define metil_keycode_3 20
#define metil_keycode_4 21
#define metil_keycode_6 22
#define metil_keycode_5 23
#define metil_keycode_equals 24
#define metil_keycode_9 25
#define metil_keycode_7 26
#define metil_keycode_minus 27
#define metil_keycode_8 28
#define metil_keycode_0 29
#define metil_keycode_closing_square_bracket 30
#define metil_keycode_o 31
#define metil_keycode_u 32
#define metil_keycode_opening_square_bracket 33
#define metil_keycode_i 34
#define metil_keycode_p 35
#define metil_keycode_return 36
#define metil_keycode_l 37
#define metil_keycode_j 38
#define metil_keycode_single_quote 39
#define metil_keycode_k 40
#define metil_keycode_semi_colon 41
#define metil_keycode_back_slash 42
#define metil_keycode_comma 43
#define metil_keycode_slash 44
#define metil_keycode_n 45
#define metil_keycode_m 46
#define metil_keycode_period 47
#define metil_keycode_tab 48
#define metil_keycode_space 49
#define metil_keycode_back_tick 50
#define metil_keycode_delete 51
#define metil_keycode_esc 53
#define metil_keycode_command_right 54
#define metil_keycode_command_left 55
#define metil_keycode_shift_left 56
#define metil_keycode_caps_lock 57
#define metil_keycode_option_left 58
#define metil_keycode_control 59
#define metil_keycode_shift_right 60
#define metil_keycode_option_right 61
#define metil_keycode_fn 63
#define metil_keycode_left_arrow 123
#define metil_keycode_right_arrow 124
#define metil_keycode_down_arrow 125
#define metil_keycode_up_arrow 126

#define metil_keycode_max_value 126

unsigned char metil_keycode_from_char_shift_required(
  unsigned char
);

unsigned char metil_keycode_from_char(
  unsigned char
);

#endif
