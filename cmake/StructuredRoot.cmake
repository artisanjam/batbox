add_library(batbox_structured_io
  src/app/cli/structured/ControlMessageCompat.cpp
  src/app/cli/structured/ProcessLine.cpp
  src/app/cli/structured/InputReader.cpp
  src/app/cli/structured/OutputWrite.cpp
)
target_link_libraries(batbox_structured_io PUBLIC batbox_headless_cli batbox_event_loop)
target_compile_options(batbox_structured_io PRIVATE -Wall -Wextra -Wpedantic)
