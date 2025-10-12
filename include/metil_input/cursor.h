#ifndef __metil_cursor_h
#define __metil_cursor_h

#include <clic3_vector.h>

extern unsigned char metil_input_locked_cursor;
extern unsigned char metil_input_dragging_cursor;

extern struct clic3_vector2_float metil_input_delta_cursor;
extern struct clic3_vector2_float metil_input_position_cursor_screen;
extern struct clic3_vector2_float metil_input_position_cursor_window;

#endif
