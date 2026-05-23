name=metil_editor

target_build=release

suffix_library_build=

target_os=macos
target_device=mac

target_version_cer0=0
target_version_clic3=0
target_version_interrupt_handler=0
target_version_math_c=0
target_version_metil=3

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

directory_base_objects=objects
directory_base_output=output

directory_air=air
directory_include=include
directory_metal=metal
directory_objects=${directory_base_objects}/${target_build}
directory_output=${directory_base_output}/${target_build}
directory_sources=sources

directory_app=${directory_output}/${name}.app
directory_app_contents=${directory_app}/Contents
directory_app_contents_macos=${directory_app_contents}/MacOS
directory_app_contents_resources=${directory_app_contents}/Resources

directory_cer0=../../../cer0
directory_cer0_include=${directory_cer0}/include
directory_cer0_library=${directory_cer0}/library/macos/${target_build}

directory_clic3=../../../clic3
directory_clic3_include=${directory_clic3}/include
directory_clic3_library=${directory_clic3}/library/macos/${target_build}

directory_interrupt_handler=../../../interrupt_handler
directory_interrupt_handler_include=${directory_interrupt_handler}/include
directory_interrupt_handler_library=${directory_interrupt_handler}/library/macos/${target_build}

directory_math_c=../../../math_c
directory_math_c_include=${directory_math_c}/include
directory_math_c_library=${directory_math_c}/library/macos/${target_build}

directory_metil=../../../metil
directory_metil_include=${directory_metil}/include
directory_metil_library=${directory_metil}/library/macos/${target_build}
directory_metil_plist=${directory_metil}/plist

directories_includes=${directory_include} ${directory_cer0_include} ${directory_clic3_include} ${directory_interrupt_handler_include} ${directory_math_c_include} ${directory_metil_include}

file_library_cer0=${directory_cer0_library}/cer0.${target_version_cer0}.dylib
file_library_clic3=${directory_clic3_library}/clic3.${target_version_clic3}.dylib
file_library_interrupt_handler=${directory_interrupt_handler_library}/interrupt_handler.${target_version_interrupt_handler}.dylib
file_library_math_c=${directory_math_c_library}/math_c.${target_version_math_c}.dylib
file_library_metil=${directory_metil_library}/metil.${target_version_metil}.dylib

file_metil_metallib=${directory_metil_library}/metil.metallib
file_metil_storyboard=${directory_metil_library}/metil.storyboardc

file_info_plist=${directory_metil_plist}/Info.plist
file_output=${directory_app_contents_macos}/${name}
file_output_info_plist=${directory_app_contents}/Info.plist
file_output_metal=${directory_app_contents_resources}/default.metallib
file_output_storyboard=${directory_app_contents_resources}/metil.storyboardc

files_metal=${wildcard ${directory_metal}/*.metal}
files_air=${patsubst ${directory_metal}/%.metal,${directory_air}/%.air,${files_metal}}

files_sources_c=${shell find ${directory_sources} -name "*.c"}
files_sources_objective_c=${shell find ${directory_sources} -name "*.m"}

files_objects_c=${patsubst ${directory_sources}/%.c,${directory_objects}/%.o,${files_sources_c}}
files_objects_objective_c=${patsubst ${directory_sources}/%.m,${directory_objects}/%.o,${files_sources_objective_c}}

files_libraries=${file_library_cer0} ${file_library_clic3} ${file_library_interrupt_handler} ${file_library_math_c} ${file_library_metil}

frameworks=Metal MetalKit GameController CoreAudio CoreGraphics CoreText

cc=clang
c_flags=-O3
c_flags_includes=${addprefix -I,${directories_includes}}
c_flags_platform=-target ${target_platform} -isysroot ${directory_sdk}
c_flags_c=${c_flags} ${c_flags_platform} ${c_flags_includes}
c_flags_objective_c=${c_flags} ${c_flags_platform} -x objective-c -fmodules ${c_flags_includes}
c_flags_frameworks=${addprefix -framework ,${frameworks}}
c_flags_output=${c_flags} ${c_flags_platform} ${files_libraries}

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

all: ${file_output}

run:
	cd ${dir ${file_output}} && ./${shell basename ${file_output}}

${file_output}: ${files_objects_c} ${files_objects_objective_c} ${file_output_metal} ${file_output_storyboard} ${file_output_info_plist}
	if [[ ! -d ${dir ${@}} ]]; then mkdir -p ${dir ${@}}; fi
	${cc} ${c_flags_output} ${files_objects_c} ${files_objects_objective_c} ${files_libraries} -o ${file_output}
	${strip} ${strip_flags} ${file_output}

${file_output_metal}: ${files_air}
	if [[ ! -d ${dir ${@}} ]]; then mkdir -p ${dir ${@}}; fi
	${metallib} ${metal_flags_output} ${files_air} ${file_metalar_metil_wireframe} ${file_metalar_metil_fps_display} -o ${@}
		
${directory_air}/%.air: ${directory_metal}/%.metal
	if [[ ! -d ${dir ${@}} ]]; then mkdir -p ${dir ${@}}; fi

	${metal} ${metal_flags} -c ${<} -o ${@}

${directory_objects}/%.o: ${directory_sources}/%.c
	if [[ ! -d ${dir ${@}} ]]; then mkdir -p ${dir ${@}}; fi
	${cc} ${c_flags_c} -c ${<} -o ${@}

${directory_objects}/%.o: ${directory_sources}/%.m
	if [[ ! -d ${dir ${@}} ]]; then mkdir -p ${dir ${@}}; fi
	${cc} ${c_flags_objective_c} -c ${<} -o ${@}

${file_output_storyboard}: ${file_metil_storyboard}
	if [[ ! -d ${dir ${@}} ]]; then mkdir -p ${dir ${@}}; fi
	cp -r ${file_metil_storyboard} ${file_output_storyboard}		
${file_output_info_plist}: ${file_info_plist}
	if [[ ! -d ${dir ${@}} ]]; then mkdir -p ${dir ${@}}; fi

	cp ${file_info_plist} ${file_output_info_plist}

clean_all: clean
clean: clean_air clean_metallib clean_objects clean_output

clean_air:
	if [[ -d ${directory_air} ]]; then rm -r ${directory_air}; fi

clean_metallib:
	if [[ -f ${file_output_metal} ]]; then rm ${file_output_metal}; fi

clean_objects:
	if [[ -d ${directory_base_objects} ]]; then rm -r ${directory_base_objects}; fi

clean_output:
	if [[ -d ${directory_base_output} ]]; then rm -r ${directory_base_output}; fi
