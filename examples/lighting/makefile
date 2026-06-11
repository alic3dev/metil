name=example_lighting

directory_objects_base=objects
directory_output_base=output

directory_air=air
directory_metal=metal
directory_objects=${directory_objects_base}/release

ifeq (${debug}, 1)
name:=${name}_debug
directory_objects=${directory_objects_base}/debug
directory_output=${directory_output_base}/debug
else
directory_output=${directory_output_base}/release
endif

version_target_cer0=0
version_target_clic3=0
version_target_interrupt_handler=0
version_target_math_c=0
version_target_metil=3

directory_include=include
directory_objects_c=${directory_objects}/c
directory_objects_objc=${directory_objects}/objc
directory_sources=sources

directory_cer0=../../../cer0
directory_cer0_include=${directory_cer0}/include

directory_clic3=../../../clic3
directory_clic3_include=${directory_clic3}/include

directory_interrupt_handler=../../../interrupt_handler

directory_math_c=../../../math_c
directory_math_c_include=${directory_math_c}/include

directory_metil=../..
directory_metil_include=${directory_metil}/include
directory_metil_library=${directory_metil}/library/macos
directory_metil_plist=${directory_metil}/plist

ifeq (${debug}, 1)
directory_cer0_library=${directory_cer0}/library/macos/debug
directory_clic3_library=${directory_clic3}/library/macos/debug
directory_interrupt_handler_library=${directory_interrupt_handler}/library/macos/debug
directory_math_c_library=${directory_math_c}/library/macos/debug
directory_metil_library:=${directory_metil_library}/debug

file_cer0_library=${directory_cer0_library}/cer0_debug.${version_target_cer0}.dylib
file_clic3_library=${directory_clic3_library}/clic3_debug.${version_target_clic3}.dylib
file_interrupt_handler_library=${directory_interrupt_handler_library}/interrupt_handler_debug.${version_target_interrupt_handler}.dylib
file_math_c_library=${directory_math_c_library}/math_c_debug.${version_target_math_c}.dylib
file_metil_library=${directory_metil_library}/metil_debug.${version_target_metil}.dylib
else
directory_cer0_library=${directory_cer0}/library/macos/release
directory_clic3_library=${directory_clic3}/library/macos/release
directory_interrupt_handler_library=${directory_interrupt_handler}/library/macos/release
directory_math_c_library=${directory_math_c}/library/macos/release
directory_metil_library:=${directory_metil_library}/release

file_cer0_library=${directory_cer0_library}/cer0.${version_target_cer0}.dylib
file_clic3_library=${directory_clic3_library}/clic3.${version_target_clic3}.dylib
file_interrupt_handler_library=${directory_interrupt_handler_library}/interrupt_handler.${version_target_interrupt_handler}.dylib
file_math_c_library=${directory_math_c_library}/math_c.${version_target_math_c}.dylib
file_metil_library=${directory_metil_library}/metil.${version_target_metil}.dylib
endif

directory_app=${directory_output}/${name}.app
directory_app_contents=${directory_app}/Contents
directory_app_contents_macos=${directory_app_contents}/MacOS
directory_app_contents_resources=${directory_app_contents}/Resources

ifndef target_device_version
target_device_version=26.1
endif

ifndef target_metal_version
target_metal_version=${target_device_version}
endif

ifndef target_metal_standard
target_metal_standard=metal4.0
endif

target_platform=arm64-apple-macos${target_device_version}
target_platform_metal=air64-apple-macos${target_metal_version}

directory_sdk=${shell xcrun --sdk macosx${target_device_version} --show-sdk-path}

file_metalar_metil_fps_display=${directory_metil_library}/metil_fps_display.metalar

file_metil_metallib=${directory_metil_library}/metil.metallib
file_metil_storyboard=${directory_metil_library}/metil.storyboardc

file_info_plist=${directory_metil_plist}/Info.plist
file_output=${directory_app_contents_macos}/${name}
file_output_info_plist=${directory_app_contents}/Info.plist
file_output_metal=${directory_app_contents_resources}/default.metallib
file_output_storyboard=${directory_app_contents_resources}/metil.storyboardc

files_libraries=${file_cer0_library} ${file_clic3_library} ${file_interrupt_handler_library} ${file_metil_library} ${file_math_c_library}

files_metal=${wildcard ${directory_metal}/*.metal}
files_air=${patsubst ${directory_metal}/%.metal,${directory_air}/%.air,${files_metal}}

files_sources_c=${shell find ${directory_sources} -name "*.c"}
files_sources_objc=${shell find ${directory_sources} -name "*.m"}

files_objects_c=${patsubst ${directory_sources}/%.c,${directory_objects_c}/%.o,${files_sources_c}}
files_objects_objc=${patsubst ${directory_sources}/%.m,${directory_objects_objc}/%.o,${files_sources_objc}}

frameworks=Metal MetalKit GameController CoreAudio CoreGraphics CoreText

cc=clang
c_flags_includes=-I${directory_include} -I${directory_cer0_include} -I${directory_clic3_include} -I${directory_math_c_include} -I${directory_metil_include}
c_flags_platform=-target ${target_platform} -isysroot ${directory_sdk}

c_flags_objc_debug=-O0 -g -v
c_flags_debug=${c_flags_objc_debug} -da -Q

c_flags_c=${c_flags_platform} ${c_flags_includes}
c_flags_objc=${c_flags_platform} ${c_flags_includes} -x objective-c -fmodules -DTARGET_MACOS
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

metal=xcrun -sdk macosx metal
metal_ar=xcrun -sdk macosx metal-ar
metallib=xcrun -sdk macosx metallib
metal_flags_common=-target ${target_platform_metal} -std=${target_metal_standard}

metal_flags=${metal_flags_common} -I${directory_include} -I${directory_math_c_include} -I${directory_metil_include} -isysroot ${directory_sdk}

ifneq (${disable_metal_fast_options}, 1)
metal_flags:=${metal_flags} -fmetal-math-mode\=fast -fmetal-math-fp32-functions\=fast
endif

metal_flags_output=

all: ${name}

run:
	cd ${dir ${file_output}} && ./${shell basename ${file_output}}

${name}: ${file_output}

${file_output}: ${files_objects_c} ${files_objects_objc} ${file_output_info_plist} ${file_output_metal} ${file_output_storyboard}
	mkdir -p ${directory_app_contents_macos}
	${cc} ${c_flags_output} ${files_objects_c} ${files_objects_objc} ${files_libraries} -o ${file_output}
ifneq (${debug}, 1)
	${strip} ${strip_flags} ${file_output}
endif
ifneq (${release}, 1)
ifeq (${debug}, 1)
	if [[ ! -f ${directory_app_contents_macos}/cer0_debug.${version_target_cer0}.dylib ]]; then ln -s ../../../../../${file_cer0_library} ${directory_app_contents_macos}/cer0_debug.${version_target_cer0}.dylib; fi
	if [[ ! -f ${directory_app_contents_macos}/clic3_debug.${version_target_clic3}.dylib ]]; then ln -s ../../../../../${file_clic3_library} ${directory_app_contents_macos}/clic3_debug.${version_target_clic3}.dylib; fi
	if [[ ! -f ${directory_app_contents_macos}/interrupt_handler_debug.${version_target_interrupt_handler}.dylib ]]; then ln -s ../../../../../${file_interrupt_handler_library} ${directory_app_contents_macos}/interrupt_handler_debug.${version_target_interrupt_handler}.dylib; fi
	if [[ ! -f ${directory_app_contents_macos}/math_c_debug.${version_target_math_c}.dylib ]]; then ln -s ../../../../../${file_math_c_library} ${directory_app_contents_macos}/math_c_debug.${version_target_math_c}.dylib; fi
	if [[ ! -f ${directory_app_contents_macos}/metil_debug.${version_target_metil}.dylib ]]; then ln -s ../../../../../${file_metil_library} ${directory_app_contents_macos}/metil_debug.${version_target_metil}.dylib; fi
else
	if [[ ! -f ${directory_app_contents_macos}/cer0.${version_target_cer0}.dylib ]]; then ln -s ../../../../../${file_cer0_library} ${directory_app_contents_macos}/cer0.${version_target_cer0}.dylib; fi
	if [[ ! -f ${directory_app_contents_macos}/clic3.${version_target_clic3}.dylib ]]; then ln -s ../../../../../${file_clic3_library} ${directory_app_contents_macos}/clic3.${version_target_clic3}.dylib; fi
	if [[ ! -f ${directory_app_contents_macos}/interrupt_handler.${version_target_interrupt_handler}.dylib ]]; then ln -s ../../../../../${file_interrupt_handler_library} ${directory_app_contents_macos}/interrupt_handler.${version_target_interrupt_handler}.dylib; fi
	if [[ ! -f ${directory_app_contents_macos}/math_c.${version_target_math_c}.dylib ]]; then ln -s ../../../../../${file_math_c_library} ${directory_app_contents_macos}/math_c.${version_target_math_c}.dylib; fi
	if [[ ! -f ${directory_app_contents_macos}/metil.${version_target_metil}.dylib ]]; then ln -s ../../../../../${file_metil_library} ${directory_app_contents_macos}/metil.${version_target_metil}.dylib; fi
endif
endif

${file_output_metal}: ${files_air}
	mkdir -p "${dir ${file_output_metal}}"
	${metallib} ${metal_flags_output} ${files_air} ${file_metalar_metil_wireframe} ${file_metalar_metil_fps_display} -o ${file_output_metal}

${directory_air}/%.air: ${directory_metal}/%.metal
	mkdir -p "${dir $@}"
	${metal} ${metal_flags} -c $< -o $@

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

clean: clean_metal clean_objects clean_output

clean_metal: clean_air clean_metalib

clean_air:
	-rm -r "${directory_air}" 2> /dev/null

clean_metalib:
	-rm "${file_output_metal}" 2> /dev/null

clean_objects:
	-rm -r ${directory_objects_base}

clean_output:
	-rm -r ${directory_output_base}
