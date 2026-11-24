add_library(batbox_application_commands src/app/commands/Commands.cpp
  src/app/commands/CommandsMcp.cpp src/app/commands/MemoryPanel.cpp
  src/app/commands/PermissionCommand.cpp
  src/app/commands/ProjectCommand.cpp src/app/commands/PoetryCommand.cpp
  src/app/commands/EffortCommand.cpp src/app/commands/ThemeCommand.cpp
  src/app/commands/ConnectorsCommand.cpp
  src/app/commands/ProvidersCommand.cpp
  src/app/usage/UsageCommand.cpp src/app/commands/FlightTitles.cpp)
target_link_libraries(batbox_application_commands PUBLIC
  batbox_core_commands batbox_application_runtime batbox_application_model
  batbox_application_poetry batbox_application_flights
  batbox_terminal_ftxui batbox_user_input
  batbox_application_memory batbox_bootstrap_state
  batbox_flight_titles batbox_application_connectors batbox_providers)
target_compile_options(batbox_application_commands PRIVATE -Wall -Wextra -Wpedantic)
