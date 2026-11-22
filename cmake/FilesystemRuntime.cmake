target_sources(batbox_diagnostics PRIVATE src/diagnostics/LogDates.cpp)
add_library(batbox_fs_operations src/lib/fs_operations/PathChecks.cpp
  src/lib/fs_operations/IndigenousPathChecks.cpp)
target_link_libraries(batbox_fs_operations PUBLIC batbox_core batbox_event_loop)
target_compile_options(batbox_fs_operations PRIVATE -Wall -Wextra -Wpedantic)
target_sources(batbox_fs_operations PRIVATE
  src/lib/fs_operations/NodeFsAsyncIndigenous.cpp
  src/lib/fs_operations/NodeFsBytesIndigenous.cpp
  src/lib/fs_operations/ReverseLines.cpp)
