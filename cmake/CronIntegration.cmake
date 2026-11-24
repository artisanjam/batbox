target_sources(batbox_cron PRIVATE
  src/services/cron/locale/NotificationDate.cpp
  src/services/cron/use_scheduled/FireTime.cpp
  src/services/cron/use_scheduled/Flight.cpp
  src/services/cron/use_scheduled/FlightIndigenous.cpp
  src/services/cron/print/HeadlessCron.cpp
)
target_link_libraries(batbox_cron PUBLIC ICU::i18n)
add_library(batbox_cron_gadgets
  src/core/gadgets/cron/CronBindings.cpp
  src/core/gadgets/cron/CronCreate.cpp
  src/core/gadgets/cron/CronDelete.cpp
  src/core/gadgets/cron/CronList.cpp
  src/core/gadgets/cron/CronPoetry.cpp
  src/core/gadgets/cron/CronGadgetSchema.cpp
  src/core/gadgets/cron/CronGadgetsIndigenous.cpp
)
target_link_libraries(batbox_cron_gadgets PUBLIC batbox_cron batbox_core batbox_text_sdk batbox_bat_context)
target_compile_options(batbox_cron_gadgets PRIVATE -Wall -Wextra -Wpedantic)
