#include <metil_system_information.h>

#include <metil_configuration/metil_configuration.h>
#include <metil_debug/metil_debug_log.h>

#include <sys/sysctl.h>

void metil_system_information_initialize(
  struct metil_system_information* metil_system_information,
  struct metil_configuration* metil_configuration
) {
  unsigned int count_cores_cpu;
  
  unsigned long length_count_cores_cpu = (
    sizeof(
      unsigned int
    )
  );

  metil_system_information->cores_cpu = (
    0x01
  );

  int status_core_count = (
    sysctlbyname(
      "hw.ncpu",
      &count_cores_cpu,
      &length_count_cores_cpu,
      0x00,
      0x00
    )
  );

  if (
    status_core_count ==
    0x00
  ) {
    metil_system_information->cores_cpu = (
      count_cores_cpu
    );
  } else {
    metil_debug_log_error(
      metil_configuration->debug_log_level,
      "unable_to_retrieve:system_information->{hw.ncpu};\n"
    );
  }
}
