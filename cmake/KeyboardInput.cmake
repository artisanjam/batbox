add_library(batbox_keyboard_input src/ui/keyboard_input/KeyHelpers.cpp
  src/ui/keyboard_input/KeyNames.cpp src/ui/keyboard_input/Keypress.cpp
  src/ui/keyboard_input/Responses.cpp src/ui/keyboard_input/Multiple.cpp)
target_link_libraries(batbox_keyboard_input PUBLIC batbox_glob batbox_termio)
target_compile_options(batbox_keyboard_input PRIVATE -Wall -Wextra -Wpedantic)
