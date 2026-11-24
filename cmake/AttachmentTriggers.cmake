add_library(batbox_attachment_triggers
  src/core/attachment_triggers/Directories.cpp src/core/attachment_triggers/MemoryFiles.cpp
  src/core/attachment_triggers/NestedMemory.cpp src/core/attachment_triggers/DynamicSkills.cpp)
target_link_libraries(batbox_attachment_triggers PUBLIC batbox_instruction_async
  batbox_app_state batbox_glob batbox_core batbox_event_loop)
target_compile_options(batbox_attachment_triggers PRIVATE -Wall -Wextra -Wpedantic)
