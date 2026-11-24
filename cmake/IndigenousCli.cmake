# Include after batbox_structured_io and batbox_application_runtime exist.
add_library(batbox_application_cli src/app/cli/Adapter.cpp
  src/app/cli/LocalOutput.cpp
  src/app/cli/headless/PermissionControl.cpp)
target_link_libraries(batbox_application_cli PUBLIC
  batbox_structured_io batbox_application_runtime batbox_core batbox_text_sdk)
target_compile_options(batbox_application_cli PRIVATE -Wall -Wextra -Wpedantic)
