add_library(batbox_user_input
  src/app/commands/Roster.cpp src/ui/user_input/BashInput.cpp
  src/ui/user_input/BashIndigenousBinding.cpp src/ui/user_input/CommandMessages.cpp
  src/ui/user_input/InputCore.cpp src/ui/user_input/InputHooks.cpp
  src/ui/user_input/InputPasted.cpp src/ui/user_input/InputRoute.cpp
  src/ui/user_input/SlashDispatch.cpp src/ui/user_input/SlashHelpers.cpp
  src/ui/user_input/SlashKnown.cpp src/ui/user_input/SlashLocal.cpp
  src/ui/user_input/SlashUi.cpp src/ui/user_input/TextPoetry.cpp
  src/ui/user_input/UiCommandRouter.cpp)
target_link_libraries(batbox_user_input PUBLIC batbox_core batbox_event_loop
  batbox_instruction_async batbox_skills batbox_interactive batbox_shell
  batbox_gadget_results batbox_bats)
target_compile_options(batbox_user_input PRIVATE -Wall -Wextra -Wpedantic)
