name=metil

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

directory_cer0=../cer0
directory_cer0_include=${directory_cer0}/include
directory_cer0_library=${directory_cer0}/library

directory_clic3=../clic3
directory_clic3_include=${directory_clic3}/include
directory_clic3_library=${directory_clic3}/library

directory_interrupt_handler=../interrupt_handler
directory_interrupt_handler_include=${directory_interrupt_handler}/include
directory_interrupt_handler_library=${directory_interrupt_handler}/library

directory_metal=metal
directory_air=air

directory_macos_sdk=${shell xcrun --show-sdk-path}

file_info_plist=Info.plist
file_library=${directory_library}/${name}.o
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

target_device=mac
target_macos_version=15.0
target_macos_version_metal=${target_macos_version}
target_platform=arm64-apple-macos${target_macos_version}
target_platform_metal=air64-apple-macos${target_macos_version_metal}

frameworks=Metal MetalKit GameController CoreAudio CoreGraphics CoreText

cc=clang
c_flags_includes=-I${directory_include} -I${directory_cer0_include} -I${directory_clic3_include} -I${directory_interrupt_handler_include}
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

ld=ld
ld_flags=

strip=strip
strip_flags=-x

metal=xcrun -sdk macosx metal
metal_flags_common=-target ${target_platform_metal}
metal_flags=${metal_flags_common} -I${directory_include} -I${directory_clic3_include} -isysroot ${directory_macos_sdk}

ifneq (${disable_metal_fast_options}, 1)
	metal_flags:=${metal_flags} -fmetal-math-mode\=fast -fmetal-math-fp32-functions\=fast
endif

metal_flags_output=${metal_flags_common}

${name}: ${file_library} ${file_output_metal} ${files_storyboards_compiled} ${file_output_info_plist}

all: ${name} examples

examples: .always
	cd ${directory_examples} && make all

${file_library}: ${files_objects_c} ${files_objects_objc}
	mkdir -p ${directory_library}
	${ld} ${ld_flags} -r ${files_objects_c} ${files_objects_objc} -o $@
ifneq (${debug}, 1)
	${strip} ${strip_flags} ${file_library}
endif

${file_output_metal}: ${files_air}
	${metal} ${metal_flags_output} ${files_air} -o ${file_output_metal}

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

clean: clean_air clean_objects clean_library

clean_examples:
	cd ${directory_examples} && make clean

clean_air:
	-rm -r ${directory_air} 2> /dev/null

clean_objects:
	-rm -r ${directory_objects_base} 2> /dev/null

clean_library:
	-rm -r ${directory_library} 2> /dev/null
	-rm -r ${directory_library_debug} 2> /dev/null

.always:
