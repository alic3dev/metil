name=example_3d_rendering

directory_objects_base=objects
directory_output_base=output

directory_objects=${directory_objects_base}/release

ifeq (${debug}, 1)
	name:=${name}_debug
	directory_objects=${directory_objects_base}/debug
	directory_output=${directory_output_base}/debug
else
	directory_output=${directory_output_base}/release
endif

directory_metil=../..

directory_include=include
directory_objects_c=${directory_objects}/c
directory_objects_objc=${directory_objects}/objc
directory_sources=sources

directory_cer0=../../../cer0
directory_cer0_include=${directory_cer0}/include
directory_cer0_library=${directory_cer0}/library

directory_clic3=../../../clic3
directory_clic3_include=${directory_clic3}/include
directory_clic3_library=${directory_clic3}/library

directory_interrupt_handler=../../../interrupt_handler
directory_interrupt_handler_include=${directory_interrupt_handler}/include
directory_interrupt_handler_library=${directory_interrupt_handler}/library

directory_math_c=../../../math_c
directory_math_c_library=${directory_math_c}/library

directory_metil_include=${directory_metil}/include
ifeq (${debug}, 1)
	directory_metil_library=${directory_metil}/library_debug
else
	directory_metil_library=${directory_metil}/library
endif

directory_app=${directory_output}/${name}.app
directory_app_contents=${directory_app}/Contents
directory_app_contents_macos=${directory_app_contents}/MacOS
directory_app_contents_resources=${directory_app_contents}/Resources

directory_macos_sdk=${shell xcrun --show-sdk-path}

file_cer0_library=${directory_cer0_library}/cer0.o
file_clic3_library=${directory_clic3_library}/clic3.o
file_interrupt_handler_library=${directory_interrupt_handler_library}/interrupt_handler.o
file_math_c_library=${directory_math_c_library}/math_c.o

ifeq (${debug}, 1)
	file_metil_library=${directory_metil_library}/metil_debug.o
else
	file_metil_library=${directory_metil_library}/metil.o
endif

file_metil_metallib=${directory_metil_library}/metil.metallib
file_metil_storyboard=${directory_metil_library}/metil.storyboardc

file_info_plist=${directory_metil}/Info.plist
file_output=${directory_app_contents_macos}/${name}
file_output_info_plist=${directory_app_contents}/Info.plist
file_output_metal=${directory_app_contents_resources}/default.metallib
file_output_storyboard=${directory_app_contents_resources}/metil.storyboardc

files_libraries=${file_cer0_library} ${file_clic3_library} ${file_interrupt_handler_library} ${file_metil_library} ${file_math_c_library}

files_sources_c=${shell find ${directory_sources} -name "*.c"}
files_sources_objc=${shell find ${directory_sources} -name "*.m"}

files_objects_c=${patsubst ${directory_sources}/%.c,${directory_objects_c}/%.o,${files_sources_c}}
files_objects_objc=${patsubst ${directory_sources}/%.m,${directory_objects_objc}/%.o,${files_sources_objc}}

target_device=mac
ifndef target_macos_version
	target_macos_version=26.0
endif
target_platform=arm64-apple-macos${target_macos_version}

frameworks=Metal MetalKit GameController CoreAudio CoreGraphics CoreText

cc=clang
c_flags_includes=-I${directory_include} -I${directory_cer0_include} -I${directory_clic3_include} -I${directory_interrupt_handler_include} -I${directory_metil_include}
c_flags_platform=-target ${target_platform} -isysroot ${directory_macos_sdk}

c_flags_objc_debug=-O0 -g -v
c_flags_debug=${c_flags_objc_debug} -da -Q

c_flags_c=${c_flags_platform} ${c_flags_includes}
c_flags_objc=${c_flags_platform} ${c_flags_includes} -x objective-c -fmodules -fconstant-cfstrings -DTARGET_MACOS
c_flags_frameworks=${addprefix -framework ,${frameworks}}
c_flags_output=${c_flags_platform} ${c_flags_frameworks}

ifeq (${debug}, 1)
	c_flags_c:=${c_flags_c} ${c_flags_debug}
	c_flags_objc:=${c_flags_objc} ${c_flags_objc_debug}
	c_flags_output:=${c_flags_output} ${c_flags_objc_debug}
else
	c_flags_c:=${c_flags_c} -O3
	c_flags_objc:=${c_flags_objc} -O3
	c_flags_output:=${c_flags_output} -O3
endif

strip=strip
strip_flags=-x

all: ${name}

run: .always
	${file_output}

${name}: ${file_output}

${file_output}: ${files_objects_c} ${files_objects_objc} ${file_output_info_plist} ${file_output_metal} ${file_output_storyboard}
	mkdir -p ${directory_app_contents_macos}
	${cc} ${c_flags_output} ${files_objects_c} ${files_objects_objc} ${files_libraries} -o ${file_output}
ifneq (${debug}, 1)
	${strip} ${strip_flags} ${file_output}
endif

${file_output_metal}: ${file_metil_metallib}
	mkdir -p ${directory_app_contents_resources}
	cp ${file_metil_metallib} ${file_output_metal}

${directory_objects_c}/%.o: ${directory_sources}/%.c
	mkdir -p "${dir $@}"
	${cc} ${c_flags_c} -c $< -o $@

${directory_objects_objc}/%.o: ${directory_sources}/%.m
	mkdir -p "${dir $@}"
	${cc} ${c_flags_objc} -c $< -o $@

${file_output_storyboard}: ${file_metil_storyboard}
	mkdir -p ${directory_app_contents_resources}
	cp -r ${file_metil_storyboard} ${file_output_storyboard}

${file_output_info_plist}: ${file_info_plist}
	mkdir -p ${directory_app_contents}
	cp ${file_info_plist} ${file_output_info_plist}

clean_all: clean

clean: clean_objects clean_output

clean_objects:
	-rm -r ${directory_objects_base}

clean_output:
	-rm -r ${directory_output_base}

.always:
