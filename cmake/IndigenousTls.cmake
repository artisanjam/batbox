add_library(batbox_indigenous_tls
  src/services/providers/client_factory/tls/CaCerts.cpp src/services/providers/client_factory/tls/Mtls.cpp
  src/services/providers/client_factory/tls/FetchOptions.cpp src/services/providers/client_factory/tls/IndigenousCerts.cpp
  src/services/providers/client_factory/tls/IndigenousRoots.cpp src/services/providers/client_factory/tls/IndigenousClientBinding.cpp)
target_link_libraries(batbox_indigenous_tls PUBLIC batbox_core CURL::libcurl)
target_compile_options(batbox_indigenous_tls PRIVATE -Wall -Wextra -Wpedantic)
if(WIN32)
  target_link_libraries(batbox_indigenous_tls PUBLIC crypt32)
endif()
