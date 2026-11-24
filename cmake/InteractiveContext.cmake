target_sources(batbox_interactive PRIVATE
  src/ui/context/GadgetPool.cpp
  src/ui/context/ContextFactoryCore.cpp
  src/ui/context/ContextFactoryCallbacks.cpp
  src/ui/context/ContextProjection.cpp)
target_link_libraries(batbox_interactive PUBLIC batbox_bats)
