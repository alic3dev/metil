directory_base=.

prefix_directory=__directory__
prefix_directory_clean=$(prefix_directory)__clean__

directories=$(dir $(wildcard $(directory_base)/*/makefile))

directories_prefixed=$(addprefix $(prefix_directory)/, $(directories))
directories_prefixed_clean=$(addprefix $(prefix_directory_clean)/, $(directories))

ifndef target_device_version
target_device_version=26.1
endif

ifndef target_metal_version
target_metal_version=${target_device_version}
endif

ifndef target_metal_standard
target_metal_standard=metal4.0
endif

all: $(directories_prefixed)

clean: clean_all
clean_all: $(directories_prefixed_clean)

$(prefix_directory)/%: %
	cd $< && if [[ -z "$$(cat makefile | grep "all:")" ]]; then make target_device_version=${{ env.target_device_version }} target_metal_standard=${{ env.target_metal_standard }}; else make all; fi

$(prefix_directory_clean)/%: %
	cd $< && if [[ -z "$$(cat makefile | grep "clean_all:")" ]]; then make clean; else make clean_all; fi
