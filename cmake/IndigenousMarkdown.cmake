include(cmake/CmarkDependency.cmake)
target_sources(batbox_interactive PRIVATE
  src/ui/markdown/Lexer.cpp
  src/ui/markdown/Format.cpp
  src/ui/markdown/Table.cpp
  src/ui/markdown/Highlight.cpp)
target_link_libraries(batbox_interactive PUBLIC PkgConfig::CMARK_GFM)
target_sources(batbox_terminal_ftxui PRIVATE
  src/ui/markdown/AnsiProjection.cpp
  src/ui/markdown/Blocks.cpp
  src/ui/markdown/Renderer.cpp
  src/ui/markdown/IndigenousRenderer.cpp)
target_link_libraries(batbox_terminal_ftxui PUBLIC batbox_text_sdk)
