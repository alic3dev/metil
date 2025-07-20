name=metil

directory_air=air
directory_examples=examples
directory_include=include
directory_library=library
directory_macos_sdk=${shell xcrun --show-sdk-path}
directory_metal=metal
directory_objects=objects
directory_sources=sources

file_library=${directory_library}/${name}.o
file_library_metal=${directory_library}/metil.metallib

files_sources=${wildcard ${directory_sources}/*.m}
files_objects=${patsubst ${directory_sources}/%.m,${directory_objects}/%.o,${files_sources}}

files_metal=${wildcard ${directory_metal}/*.metal}
files_air=${patsubst ${directory_metal}/%.metal,${directory_air}/%.air,${files_metal}}

target_device=mac
target_macos_version=10.15
target_macos_version_metal=${target_macos_version}
target_platform=arm64-apple-macos${target_macos_version}
target_platform_metal=air64-apple-macos${target_macos_version_metal}

cc=clang
c_flags=-O3 -I${directory_include} -target ${target_platform} -isysroot ${directory_macos_sdk} -x objective-c -fmodules -DTARGET_MACOS

ld=ld
ld_flags=

metal=xcrun -sdk macosx metal
metal_flags_common=-target ${target_platform_metal}
metal_flags=${metal_flags_common} -I${directory_include} -isysroot ${directory_macos_sdk}
metal_flags_output=${metal_flags_common}

strip=strip
strip_flags=-x

${name}: ${file_library} ${file_library_metal}

all: ${name} examples

${file_library}: ${files_objects} ${directory_library}
	${ld} ${ld_flags} -r ${files_objects} -o ${file_library}
	${strip} ${strip_flags} ${file_library}

${directory_objects}/%.o: ${directory_sources}/%.m ${directory_objects}
	${cc} ${c_flags} -c $< -o $@

${file_library_metal}: ${files_air} ${directory_app_contents_resources}
	${metal} ${metal_flags_output} ${files_air} -o ${file_library_metal}

${directory_air}/%.air: ${directory_metal}/%.metal ${directory_air}
	${metal} ${metal_flags} -c $< -o $@

examples: .always
	cd examples && make all

run_example_%: examples/% examples/%/output/%.app/Contents/MacOS/% .always
	cd $< && make run

examples/%/output/%.app/Contents/MacOS/%: examples/%
	cd $< && make

examples/%:

directories: ${directory_air} ${directory_objects} ${directory_library}

${directory_air}:
	mkdir -p ${directory_air}

${directory_objects}:
	mkdir -p ${directory_objects}

${directory_library}:
	mkdir -p ${directory_library}

clean_all: clean clean_examples

clean: clean_air clean_library clean_objects

clean_examples:
	-cd examples && make clean_all

clean_example_%: examples/%
	cd $< && make clean_all

clean_air:
	-rm -r ${directory_air}

clean_library:
	-rm -r ${directory_library}

clean_objects:
	-rm -r ${directory_objects}

.always:
