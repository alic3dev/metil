#include <metil_system_information.h>

#include <metil_debug/log.h>

#include <sys/sysctl.h>

struct metil_system_information metil_system_information = {
  .cores_cpu = 1
};

void metil_system_information_initialize() {
  unsigned int count_cores_cpu;
  unsigned long length_count_cores_cpu = sizeof(unsigned int);

  int status_core_count = sysctlbyname(
    "hw.ncpu",
    &count_cores_cpu,
    &length_count_cores_cpu,
    (void*)0,
    0
  );

  if (
    status_core_count == 0
  ) {
    metil_system_information.cores_cpu = count_cores_cpu;
  } else {
    metil_debug_log_error(
      "unable_to_retrieve:system_information->{hw.ncpu};\n"
    );
  }
}
