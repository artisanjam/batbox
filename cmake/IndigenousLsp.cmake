add_library(batbox_indigenous_lsp
  src/services/lsp/Protocol.cpp src/services/lsp/Client.cpp src/services/lsp/Diagnostics.cpp src/services/lsp/Manager.cpp
  src/app/lsp/Format.cpp src/app/lsp/Runtime.cpp
  src/app/lsp/Gadget.cpp src/app/lsp/Symbol.cpp)
target_link_libraries(batbox_indigenous_lsp PUBLIC batbox_core batbox_indigenous_jsonl_process)
target_compile_options(batbox_indigenous_lsp PRIVATE -Wall -Wextra -Wpedantic)
target_link_libraries(batbox_application_gadgets PUBLIC batbox_indigenous_lsp)
target_link_libraries(batbox_indigenous_host PUBLIC batbox_indigenous_lsp)
