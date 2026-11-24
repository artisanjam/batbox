add_library(batbox_core_commands
  src/core/commands_indigenous/Stashes.cpp
  src/core/commands_indigenous/Clear.cpp
  src/core/commands_indigenous/Compact.cpp
  src/core/commands_indigenous/CoreHelpers.cpp
  src/core/commands_indigenous/HelpModel.cpp
  src/core/commands_indigenous/Resume.cpp)
target_link_libraries(batbox_core_commands PUBLIC batbox_user_input
  batbox_interactive batbox_compaction batbox_query batbox_app_state
  batbox_event_loop batbox_core)
target_compile_options(batbox_core_commands PRIVATE -Wall -Wextra -Wpedantic)
