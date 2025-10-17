name=metil

version_major=0
version_minor=0
version_patch=0
version_major_minor=${version_major}.${version_minor}
version=${version_major}.${version_minor}.${version_patch}

directory_examples=examples
directory_objects_base=objects
directory_library=library
directory_library_debug=${directory_library}_debug

directory_objects=${directory_objects_base}/release

ifeq (${debug}, 1)
	name:=${name}_debug
	directory_objects=${directory_objects_base}/debug
	directory_library:=${directory_library_debug}
endif

directory_include=include
directory_objects_c=${directory_objects}/c
directory_objects_objc=${directory_objects}/objc
directory_sources=sources
directory_storyboards=storyboards

version_target_cer0=0
version_target_clic3=0
version_target_interrupt_handler=0
version_target_math_c=0

directory_cer0=../cer0
directory_cer0_include=${directory_cer0}/include

directory_clic3=../clic3
directory_clic3_include=${directory_clic3}/include

directory_interrupt_handler=../interrupt_handler
directory_interrupt_handler_include=${directory_interrupt_handler}/include

directory_math_c=../math_c
directory_math_c_include=${directory_math_c}/include

ifeq (${debug}, 1)
directory_cer0_library=${directory_cer0}/library_debug
file_cer0_library=${directory_cer0_library}/cer0_debug.${version_target_cer0}.dylib
directory_clic3_library=${directory_clic3}/library_debug
file_clic3_library=${directory_clic3_library}/clic3_debug.${version_target_clic3}.dylib
directory_interrupt_handler_library=${directory_interrupt_handler}/library_debug
file_interrupt_handler_library=${directory_interrupt_handler_library}/interrupt_handler_debug.${version_target_interrupt_handler}.dylib
directory_math_c_library=${directory_math_c}/library_debug
file_math_c_library=${directory_math_c_library}/math_c_debug.${version_target_math_c}.dylib
else
directory_cer0_library=${directory_cer0}/library
file_cer0_library=${directory_cer0_library}/cer0.${version_target_cer0}.dylib
directory_clic3_library=${directory_clic3}/library
file_clic3_library=${directory_clic3_library}/clic3.${version_target_clic3}.dylib
directory_interrupt_handler_library=${directory_interrupt_handler}/library
file_interrupt_handler_library=${directory_interrupt_handler_library}/interrupt_handler.${version_target_interrupt_handler}.dylib
directory_math_c_library=${directory_math_c}/library
file_math_c_library=${directory_math_c_library}/math_c.${version_target_math_c}.dylib
file_math_c_library_object=${directory_math_c_library}/math_c.${version_target_math_c}.dylib
endif

directory_metal=metal
directory_air=air
directory_metalar=metalar

directory_macos_sdk=${shell xcrun --show-sdk-path}

file_air_fps_display=${directory_air}/metil_fps_display.air
file_air_wireframe=${directory_air}/metil_wireframe.air
file_info_plist=Info.plist

file_library_object=${directory_library}/${name}.o

name_library_dylib_major=${name}.${version_major}.dylib
file_library_dylib=${directory_library}/${name}.dylib
file_library_dylib_major=${directory_library}/${name_library_dylib_major}

name_library_dynamic_major=${name}.${version_major}.so
file_library_dynamic=${directory_library}/${name}.so
file_library_dynamic_major=${directory_library}/${name_library_dynamic_major}

file_library_static=${directory_library}/${name}.a

file_metalar_metil_all=${directory_metalar}/metil_all.metalar
file_metalar_metil_fps_display=${directory_metalar}/metil_fps_display.metalar
file_metalar_metil_wireframe=${directory_metalar}/metil_wireframe.metalar
file_output_metalar_metil_all=${directory_library}/metil_all.metalar
file_output_metalar_metil_fps_display=${directory_library}/metil_fps_display.metalar
file_output_metalar_metil_wireframe=${directory_library}/metil_wireframe.metalar

file_output_info_plist=${directory_library}/Info.plist
file_output_metal=${directory_library}/metil.metallib

files_sources_c=${shell find ${directory_sources} -name "*.c"}
files_sources_objc=${shell find ${directory_sources} -name "*.m"}

files_objects_c=${patsubst ${directory_sources}/%.c,${directory_objects_c}/%.o,${files_sources_c}}
files_objects_objc=${patsubst ${directory_sources}/%.m,${directory_objects_objc}/%.o,${files_sources_objc}}

files_metal=${wildcard ${directory_metal}/*.metal}
files_air=${patsubst ${directory_metal}/%.metal,${directory_air}/%.air,${files_metal}}

files_storyboards=${wildcard ${directory_storyboards}/*.storyboard}
files_storyboards_compiled=${patsubst ${directory_storyboards}/%.storyboard,${directory_library}/%.storyboardc,${files_storyboards}}

files_libraries=${file_cer0_library} ${file_clic3_library} ${file_interrupt_handler_library} ${file_math_c_library}

target_device=mac
ifndef target_macos_version
	target_macos_version=26.0
endif
target_macos_version_metal=${target_macos_version}
target_platform=arm64-apple-macos${target_macos_version}
target_platform_metal=air64-apple-macos${target_macos_version_metal}

frameworks=Metal MetalKit GameController CoreAudio CoreGraphics CoreText

cc=clang
c_flags_includes=-I${directory_include} -I${directory_cer0_include} -I${directory_clic3_include} -I${directory_interrupt_handler_include} -I${directory_math_c_include}
c_flags_platform=-target ${target_platform} -isysroot ${directory_macos_sdk}

c_flags_objc_debug=-O0 -g -v
c_flags_debug=${c_flags_objc_debug} -da -Q

c_flags_c=${c_flags_platform} ${c_flags_includes}
c_flags_objc=${c_flags_platform} ${c_flags_includes} -x objective-c -fmodules -fconstant-cfstrings -DTARGET_MACOS
c_flags_frameworks=${addprefix -framework ,${frameworks}}

ifeq (${debug}, 1)
	c_flags_c:=${c_flags_c} ${c_flags_debug}
	c_flags_objc:=${c_flags_objc} ${c_flags_objc_debug}
else
	c_flags_c:=${c_flags_c} -O3
	c_flags_objc:=${c_flags_objc} -O3
endif

ar=ar
ar_flags=cqS

ld=ld
ld_flags=

strip=strip
strip_flags=-x

metal=xcrun -sdk macosx metal
metal_ar=xcrun -sdk macosx metal-ar
metallib=xcrun -sdk macosx metallib
metal_flags_common=-target ${target_platform_metal}
metal_flags=${metal_flags_common} -I${directory_include} -I${directory_clic3_include} -isysroot ${directory_macos_sdk}

ifneq (${disable_metal_fast_options}, 1)
	metal_flags:=${metal_flags} -fmetal-math-mode\=fast -fmetal-math-fp32-functions\=fast
endif

metal_flags_output=

${name}: ${file_library_dylib} ${file_library_dynamic} ${file_library_object} ${file_library_static} ${file_output_metal} ${file_output_metalar_metil_all} ${file_output_metalar_metil_fps_display} ${file_output_metalar_metil_wireframe} ${files_storyboards_compiled} ${file_output_info_plist}

all: ${name} examples

${name}_objects: ${files_objects}

${name}_dylib: ${file_library_dylib}
${name}_dynamic: ${file_library_dynamic}
${name}_object: ${file_library_object}
${name}_static: ${file_library_static}

examples: .always
	cd ${directory_examples} && make all

${file_library_dylib}: ${files_objects_c} ${files_objects_objc}
	mkdir -p ${directory_library}
	${cc} -dynamiclib -install_name ${name_library_dylib_major} -current_version ${version} -compatibility_version ${version_major_minor} ${files_libraries} ${files_objects_c} ${files_objects_objc} -o ${file_library_dylib_major}
ifneq (${debug}, 1)
	${strip} ${strip_flags} ${file_library_dylib_major}
endif
	-rm ${file_library_dylib}
	ln -s ${name_library_dylib_major} ${file_library_dylib}

${file_library_dynamic}: ${files_objects_c} ${files_objects_objc}
	mkdir -p ${directory_library}
	${cc} -shared -install_name ${name_library_dynamic_major} -current_version ${version} -compatibility_version ${version_major_minor} ${files_libraries} ${files_objects_c} ${files_objects_objc} -o ${file_library_dynamic_major}
ifneq (${debug}, 1)
	${strip} ${strip_flags} ${file_library_dynamic_major}
endif
	-rm ${file_library_dynamic}
	ln -s ${name_library_dynamic_major} ${file_library_dynamic}

${file_library_object}: ${files_objects_c} ${files_objects_objc}
	mkdir -p ${directory_library}
	${ld} ${ld_flags} -r ${files_objects_c} ${files_objects_objc} -o ${file_library_object}
ifneq (${debug}, 1)
	${strip} ${strip_flags} ${file_library_object}
endif

${file_library_static}: ${files_objects_c} ${files_objects_objc}
	mkdir -p ${directory_library}
	${ar} ${ar_flags} ${file_library_static} ${files_objects_c} ${files_objects_objc}

${file_output_metal}: ${file_metalar_metil_all}
	${metallib} ${metal_flags_output} ${file_metalar_metil_all} -o ${file_output_metal}

${directory_library}/%.metalar: ${directory_metalar}/%.metalar
	cp $< $@

${file_metalar_metil_all}: ${files_air}
	mkdir -p ${directory_metalar}
	if [[ -f ${file_metalar_metil_all} ]]; then rm ${file_metalar_metil_all}; fi
	${metal_ar} -rc ${file_metalar_metil_all} ${files_air}

${file_metalar_metil_fps_display}: ${file_air_fps_display}
	mkdir -p ${directory_metalar}
	if [[ -f ${file_metalar_metil_fps_display} ]]; then rm ${file_metalar_metil_fps_display}; fi
	${metal_ar} -rc ${file_metalar_metil_fps_display} ${file_air_fps_display}

${file_metalar_metil_wireframe}: ${file_air_wireframe}
	mkdir -p ${directory_metalar}
	if [[ -f ${file_metalar_metil_wireframe} ]]; then rm ${file_metalar_metil_wireframe}; fi
	${metal_ar} -rc ${file_metalar_metil_wireframe} ${file_air_wireframe}

${directory_air}/%.air: ${directory_metal}/%.metal
	mkdir -p ${directory_air}
	${metal} ${metal_flags} -c $< -o $@

${directory_objects_c}/%.o: ${directory_sources}/%.c
	mkdir -p "${dir $@}"
	${cc} ${c_flags_c} -c $< -o $@

${directory_objects_objc}/%.o: ${directory_sources}/%.m
	mkdir -p "${dir $@}"
	${cc} ${c_flags_objc} -c $< -o $@

${directory_library}/%.storyboardc: ${directory_storyboards}/%.storyboard
	mkdir -p ${directory_library}
	ibtool --module ${name} --target-device ${target_device} --minimum-deployment-target ${target_macos_version} --output-format human-readable-text $< --compilation-directory ${directory_library}	

${file_output_info_plist}: ${file_info_plist}
	mkdir -p ${directory_library}
	cp ${file_info_plist} ${file_output_info_plist}

clean_all: clean clean_examples

clean: clean_air clean_metalar clean_objects clean_library

clean_examples:
	cd ${directory_examples} && make clean

clean_air:
	-rm -r ${directory_air} 2> /dev/null

clean_metalar:
	-rm -r ${directory_metalar} 2> /dev/null

clean_objects:
	-rm -r ${directory_objects_base} 2> /dev/null

clean_library:
	-rm -r ${directory_library} 2> /dev/null
	-rm -r ${directory_library_debug} 2> /dev/null

.always:
