#ifndef __metil_paths_paths_constants_h
#define __metil_paths_paths_constants_h

#define metil_paths_length_directory_configuration 8
#if target_os_ios
#define metil_paths_length_directory_resources 2
#else
#define metil_paths_length_directory_resources 13
#endif
#define metil_paths_length_directory_textures 9

#define metil_paths_directory_configuration ".config/"

#if target_os_ios
#define metil_paths_directory_resources "./"
#else
#define metil_paths_directory_resources "../Resources/"
#endif
#define metil_paths_directory_textures "textures/"

#endif
