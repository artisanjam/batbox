add_library(batbox_memory_prefetch
  src/core/memory_prefetch/PoetryScan.cpp src/core/memory_prefetch/BatMemoryPath.cpp
  src/core/memory_prefetch/IndigenousIO.cpp src/core/memory_prefetch/Read.cpp
  src/core/memory_prefetch/Selector.cpp src/core/memory_prefetch/Collect.cpp
  src/core/memory_prefetch/Start.cpp
  src/core/memory_prefetch/Bindings.cpp
  # The one-shot side query (formerly batbox_side_query) exists to serve
  # memory prefetch -- a transport-level helper compiled beside its only
  # consumer.
  src/core/side_query/SideQuery.cpp)
target_link_libraries(batbox_memory_prefetch PUBLIC batbox_query batbox_instructions
  batbox_transport)
target_compile_options(batbox_memory_prefetch PRIVATE -Wall -Wextra -Wpedantic)
