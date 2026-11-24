add_library(batbox_cron src/services/cron/CronParse.cpp src/services/cron/CronCalendar.cpp)
target_sources(batbox_cron PRIVATE src/services/cron/CronRead.cpp src/services/cron/CronWrite.cpp
  src/services/cron/CronIndigenousFs.cpp src/services/cron/CronJitter.cpp)
target_link_libraries(batbox_cron PUBLIC batbox_core batbox_event_loop batbox_bootstrap_state)
target_compile_options(batbox_cron PRIVATE -Wall -Wextra -Wpedantic)
target_sources(batbox_cron PRIVATE src/services/cron/CronSchedulerCheck.cpp src/services/cron/CronSchedulerLifecycle.cpp
  src/services/cron/CronSchedulerIndigenous.cpp src/services/cron/CronMissed.cpp src/services/cron/CronLock.cpp
  src/services/cron/CronLockIndigenous.cpp src/services/cron/CronHuman.cpp src/services/cron/CronHumanIndigenous.cpp)
target_link_libraries(batbox_cron PUBLIC batbox_settings batbox_cleanup)
target_sources(batbox_cron PRIVATE
  src/services/cron/config/CronConfiguration.cpp
  src/services/cron/config/CronConfigurationIndigenous.cpp
)
