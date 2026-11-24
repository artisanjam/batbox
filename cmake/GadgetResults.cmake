add_library(batbox_gadget_results
  src/ui/gadget_results/Helpers.cpp src/ui/gadget_results/Storage.cpp
  src/ui/gadget_results/IndigenousFileSystem.cpp src/ui/gadget_results/Process.cpp
  src/ui/gadget_results/Candidates.cpp src/ui/gadget_results/Replacements.cpp
  src/ui/gadget_results/Budget.cpp)
target_link_libraries(batbox_gadget_results PUBLIC batbox_event_loop batbox_core)
target_compile_options(batbox_gadget_results PRIVATE -Wall -Wextra -Wpedantic)
