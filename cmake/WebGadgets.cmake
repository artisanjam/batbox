add_library(batbox_web
  src/core/gadgets/web/Factories.cpp src/core/gadgets/web/FetchStash.cpp src/core/gadgets/web/FetchCall.cpp
  src/core/gadgets/web/FetchModel.cpp src/core/gadgets/web/FetchPermission.cpp src/core/gadgets/web/FetchURL.cpp
  src/core/gadgets/web/ModelAdapter.cpp src/core/gadgets/web/Parse.cpp src/core/gadgets/web/PoetryEntries.cpp
  src/core/gadgets/web/Schemas.cpp src/core/gadgets/web/ScraplingFetch.cpp src/core/gadgets/web/SearchCore.cpp)
target_link_libraries(batbox_web PUBLIC batbox_connectors batbox_model batbox_core)
target_compile_options(batbox_web PRIVATE -Wall -Wextra -Wpedantic)
