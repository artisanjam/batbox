add_library(batbox_locking src/core/locking/FileOps.cpp src/core/locking/ProperLock.cpp
  src/core/locking/Heartbeat.cpp)
target_link_libraries(batbox_locking PUBLIC batbox_core batbox_event_loop)
target_compile_options(batbox_locking PRIVATE -Wall -Wextra -Wpedantic)
target_sources(batbox_auth PRIVATE
  src/services/providers/auth/storage/Fallback.cpp
  src/services/providers/auth/storage/KeychainHelpers.cpp
  src/services/providers/auth/storage/MacKeychain.cpp
  src/services/providers/auth/storage/IndigenousPlaintext.cpp
  src/services/providers/auth/storage/IndigenousSecurity.cpp
  src/services/providers/auth/storage/Plaintext.cpp
)
target_link_libraries(batbox_auth PUBLIC batbox_locking batbox_process CURL::libcurl OpenSSL::Crypto)
target_sources(batbox_auth PRIVATE src/services/providers/auth/oauth_client/FormUrl.cpp)
target_link_libraries(batbox_auth PUBLIC batbox_url)
target_sources(batbox_auth PRIVATE src/services/providers/auth/oauth_listener/IndigenousServerUv.cpp)
