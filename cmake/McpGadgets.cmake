include(cmake/Icu.cmake)
add_library(batbox_mcp
  src/lib/mcp/Call.cpp src/lib/mcp/Codec.cpp src/lib/mcp/Collapse.cpp
  src/lib/mcp/CollapseRead1.cpp src/lib/mcp/CollapseRead2.cpp src/lib/mcp/CollapseRead3.cpp
  src/lib/mcp/CollapseSearch.cpp src/lib/mcp/Names.cpp src/lib/mcp/OutputStorage.cpp
  src/lib/mcp/ProcessResult.cpp src/lib/mcp/ResultContent.cpp src/lib/mcp/Sanitize.cpp
  src/lib/mcp/StdioProcess.cpp src/lib/mcp/StdioReader.cpp src/lib/mcp/StdioRequest.cpp
  src/lib/mcp/GadgetFactory.cpp src/lib/mcp/Validation.cpp)
target_link_libraries(batbox_mcp PUBLIC batbox_core batbox_media ICU::uc Threads::Threads)
target_compile_options(batbox_mcp PRIVATE -Wall -Wextra -Wpedantic)
