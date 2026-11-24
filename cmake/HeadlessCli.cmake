add_library(batbox_headless_cli
  src/app/cli/headless/PermissionControl.cpp
)
target_link_libraries(batbox_headless_cli PUBLIC batbox_flights batbox_bat_context)
target_compile_options(batbox_headless_cli PRIVATE -Wall -Wextra -Wpedantic)
target_sources(batbox_headless_cli PRIVATE src/app/cli/util/Ndjson.cpp)
target_link_libraries(batbox_headless_cli PUBLIC batbox_cleanup)
