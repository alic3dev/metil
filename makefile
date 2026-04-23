name=metil

ifeq (${debug}, 1)
target_build=debug
suffix_library_target_build=_${target_build}
else
target_build=release
suffix_library_target_build=
endif

name:=${name}${suffix_library_target_build}

version_major=3
version_minor=0
version_patch=0
version_major_minor=${version_major}.${version_minor}
version=${version_major}.${version_minor}.${version_patch}

ifndef target_device
target_device=mac
endif

ifeq (${target_device},mac)
target_os=macos
target_sdk=macosx
suffix_library_target_os=
endif

ifeq (${target_device},iphone)
target_os=ios
target_sdk=iphoneos
suffix_library_target_os=_${target_os}
endif

directory_objects_base=objects
directory_library_base=library

directory_examples=examples
directory_include=include
directory_library=${directory_library_base}/${target_os}/${target_build}
directory_objects:=${directory_objects_base}/${target_os}/${target_build}
directory_objects_c=${directory_objects}/c
directory_objects_objc=${directory_objects}/objc
directory_plist=plist
directory_sources=sources
directory_storyboards=storyboards

version_target_cer0=0
version_target_clic3=0
version_target_interrupt_handler=0
version_target_math_c=0

directory_cer0=../cer0
directory_cer0_include=${directory_cer0}/include
directory_cer0_library=${directory_cer0}/library/${target_os}/${target_build}

directory_clic3=../clic3
directory_clic3_include=${directory_clic3}/include
directory_clic3_library=${directory_clic3}/library/${target_os}/${target_build}

directory_interrupt_handler=../interrupt_handler
directory_interrupt_handler_include=${directory_interrupt_handler}/include
directory_interrupt_handler_library=${directory_interrupt_handler}/library/${target_os}/${target_build}

directory_math_c=../math_c
directory_math_c_include=${directory_math_c}/include
directory_math_c_library=${directory_math_c}/library/${target_os}/${target_build}

file_cer0_library=${directory_cer0_library}/cer0${suffix_library_target_os}${suffix_library_target_build}.${version_target_cer0}.dylib
file_clic3_library=${directory_clic3_library}/clic3${suffix_library_target_os}${suffix_library_target_build}.${version_target_clic3}.dylib
file_interrupt_handler_library=${directory_interrupt_handler_library}/interrupt_handler${suffix_library_target_os}${suffix_library_target_build}.${version_target_interrupt_handler}.dylib
file_math_c_library=${directory_math_c_library}/math_c${suffix_library_target_os}${suffix_library_target_build}.${version_target_math_c}.dylib

directory_metal=metal

directory_air_base=air
directory_metalar_base=metalar

directory_air=${directory_air_base}/${target_os}
directory_metalar=${directory_metalar_base}/${target_os}

ifndef target_device_version
target_device_version=26.1
endif

ifndef target_metal_version
target_metal_version=${target_device_version}
endif

ifndef target_metal_standard
target_metal_standard=metal4.0
endif

target_platform=arm64-apple-${target_os}${target_device_version}
target_platform_metal=air64-apple-${target_os}${target_metal_version}

directory_sdk=${shell xcrun --sdk ${target_sdk}${target_device_version} --show-sdk-path}

file_info_plist=${directory_plist}/Info${suffix_library_target_os}.plist

file_library_object=${directory_library}/${name}.o

name_library_dylib_major=${name}.${version_major}.dylib
file_library_dylib=${directory_library}/${name}.dylib
file_library_dylib_major=${directory_library}/${name_library_dylib_major}

name_library_dynamic_major=${name}.${version_major}.so
file_library_dynamic=${directory_library}/${name}.so
file_library_dynamic_major=${directory_library}/${name_library_dynamic_major}

file_library_static=${directory_library}/${name}.a

file_metalar_metil_all=${directory_metalar}/metil_all.metalar
file_metalar_metil_model=${directory_metalar}/metil_metal_model.metalar

file_output_metalar_metil_all=${directory_library}/metil_all.metalar
file_output_metalar_metil_model=${directory_library}/metil_metal_model.metalar

file_output_info_plist=${directory_library}/Info${suffix_library_target_os}.plist

file_output_metal=${directory_library}/metil.metallib

files_sources_c=${shell find ${directory_sources} -name "*.c"}
files_sources_objc=${shell find ${directory_sources} -name "*.m"}

files_objects_c=${patsubst ${directory_sources}/%.c,${directory_objects_c}/%.o,${files_sources_c}}
files_objects_objc=${patsubst ${directory_sources}/%.m,${directory_objects_objc}/%.o,${files_sources_objc}}

files_metal=${wildcard ${directory_metal}/*.metal}
files_air=${patsubst ${directory_metal}/%.metal,${directory_air}/%.air,${files_metal}}
files_metalar=${patsubst ${directory_air}/%.air,${directory_metalar}/%.metalar,${files_air}}
files_output_metalar=${patsubst ${directory_metalar}/%.metalar,${directory_library}/%.metalar,${files_metalar}}

files_storyboards=${wildcard ${directory_storyboards}/*.storyboard}

ifneq (${target_device},iphone)
files_storyboards:=${filter-out ${directory_storyboards}/metil_ios.storyboard,${files_storyboards}}
else
files_storyboards:=${filter-out ${directory_storyboards}/metil.storyboard,${files_storyboards}}
endif

files_storyboards_compiled=${patsubst ${directory_storyboards}/%.storyboard,${directory_library}/%.storyboardc,${files_storyboards}}

files_libraries=${file_cer0_library} ${file_clic3_library} ${file_interrupt_handler_library} ${file_math_c_library}

frameworks=Metal MetalKit GameController CoreGraphics CoreText

ifneq (${target_os},ios)
frameworks:=${frameworks} CoreAudio
endif

cc=clang
c_flags_includes=-I${directory_include} -I${directory_cer0_include} -I${directory_clic3_include} -I${directory_interrupt_handler_include} -I${directory_math_c_include}
c_flags_platform=-target ${target_platform} -isysroot ${directory_sdk}

c_flags_objc_debug=-O0 -g -v
c_flags_debug=${c_flags_objc_debug}

c_flags_c=${c_flags_platform} ${c_flags_includes}
c_flags_objc=${c_flags_platform} ${c_flags_includes} -x objective-c -fmodules

ifeq (${target_device},iphone)
c_flags_c:=${c_flags_c} -Dtarget_os_ios
c_flags_objc:=${c_flags_objc} -Dtarget_os_ios
endif

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
metal_flags_common=-target ${target_platform_metal} -std=${target_metal_standard}

metal_flags=${metal_flags_common} -I${directory_include} -I${directory_math_c_include} -isysroot ${directory_sdk}

ifneq (${disable_metal_fast_options}, 1)
metal_flags:=${metal_flags} -fmetal-math-mode\=fast -fmetal-math-fp32-functions\=fast
endif

metal_flags_output=

${name}: ${file_library_dylib} ${file_library_dynamic} ${file_library_object} ${file_library_static} ${file_output_metal} ${file_output_metalar_metil_all} ${file_output_metalar_metil_model} ${files_metalar} ${files_output_metalar} ${files_storyboards_compiled} ${file_output_info_plist}

all: ${name} examples

${name}_objects: ${files_objects}

${name}_dylib: ${file_library_dylib}
${name}_dynamic: ${file_library_dynamic}
${name}_object: ${file_library_object}
${name}_static: ${file_library_static}

examples: .always
	cd ${directory_examples} && make all target_device_version=${target_device_version} target_metal_version=${target_device_version} target_metal_standard=${target_metal_standard}

${file_library_dylib}: ${files_objects_c} ${files_objects_objc}
	mkdir -p ${directory_library}
	${cc} -dynamiclib -install_name ${name_library_dylib_major} -target ${target_platform} -isysroot ${directory_sdk} -current_version ${version} -compatibility_version ${version_major_minor} ${files_libraries} ${files_objects_c} ${files_objects_objc} -o ${file_library_dylib_major}
ifneq (${debug}, 1)
	${strip} ${strip_flags} ${file_library_dylib_major}
endif
	-rm ${file_library_dylib}
	ln -s ${name_library_dylib_major} ${file_library_dylib}

${file_library_dynamic}: ${files_objects_c} ${files_objects_objc}
	mkdir -p ${directory_library}
	${cc} -shared -install_name ${name_library_dynamic_major} -target ${target_platform} -isysroot ${directory_sdk} -current_version ${version} -compatibility_version ${version_major_minor} ${files_libraries} ${files_objects_c} ${files_objects_objc} -o ${file_library_dynamic_major}
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

${file_metalar_metil_model}: ${directory_air}/metil_metal_joint.air ${directory_air}/metil_metal_model_object.air
	mkdir -p ${directory_metalar}
	if [[ -f ${file_metalar_metil_model} ]]; then rm ${file_metalar_metil_model}; fi
	${metal_ar} -rc ${file_metalar_metil_model} ${directory_air}/metil_metal_joint.air ${directory_air}/metil_metal_model_object.air

${directory_metalar}/%.metalar: ${directory_air}/%.air
	mkdir -p ${directory_metalar}
	if [[ -f "$@" ]]; then rm "$@"; fi
	${metal_ar} -rc "$@" "$<"

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
	ibtool --module ${name} --target-device ${target_device} --minimum-deployment-target ${target_device_version} --output-format human-readable-text $< --compilation-directory ${directory_library}	

${file_output_info_plist}: ${file_info_plist}
	mkdir -p ${directory_library}
	cp ${file_info_plist} ${file_output_info_plist}

clean_all: clean clean_examples

clean: clean_air clean_metalar clean_objects clean_library

clean_examples:
	cd ${directory_examples} && make clean

clean_air:
	-rm -r ${directory_air_base} 2> /dev/null

clean_metalar:
	-rm -r ${directory_metalar_base} 2> /dev/null

clean_objects:
	-rm -r ${directory_objects_base} 2> /dev/null

clean_library:
	-rm -r ${directory_library_base} 2> /dev/null

.always:
