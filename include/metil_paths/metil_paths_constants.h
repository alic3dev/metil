#ifndef __metil_paths_metil_paths_constants_h
#define __metil_paths_metil_paths_constants_h

#define metil_paths_length_directory_configuration 0x08
#if target_os_ios
#define metil_paths_length_directory_resources 0x02
#else
#define metil_paths_length_directory_resources 0x0d
#endif
#define metil_paths_length_directory_textures 0x09

#define metil_paths_directory_configuration ".config/"

#if target_os_ios
#define metil_paths_directory_resources "./"
#else
#define metil_paths_directory_resources "../Resources/"
#endif
#define metil_paths_directory_textures "textures/"

#endif
