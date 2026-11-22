# MCP authentication, connection state machines, and the Indigenous SDK transport boundary.
add_library(batbox_indigenous_jsonl_process src/core/process/IndigenousJsonlProcess.cpp)
target_link_libraries(batbox_indigenous_jsonl_process PUBLIC batbox_core
  PkgConfig::LIBUV Threads::Threads)
target_compile_options(batbox_indigenous_jsonl_process PRIVATE -Wall -Wextra -Wpedantic)
target_link_libraries(batbox_mcp PUBLIC batbox_indigenous_jsonl_process)
target_link_libraries(batbox_connectors PUBLIC batbox_indigenous_jsonl_process batbox_mcp)
if(WIN32)
  target_link_libraries(batbox_instruction_async PUBLIC batbox_indigenous_jsonl_process ws2_32)
  target_link_libraries(batbox_diagnostics PUBLIC psapi)
  target_link_libraries(batbox_media PUBLIC batbox_indigenous_jsonl_process)
endif()
if(WIN32)
  target_link_libraries(batbox_core PUBLIC bcrypt)
  # The Win ripgrep process source (compiled into batbox_core) uses
  # batbox_indigenous_jsonl_process, which itself links batbox_core.
  # That edge made the static-link graph cyclic; the MSVC linker is
  # order-insensitive across archives, so consumers resolve it without
  # the core->jsonl_process declaration.
endif()

add_library(batbox_mcp_runtime
  src/lib/mcp/http/IndigenousHttp.cpp
  src/lib/mcp/auth/Helpers.cpp src/lib/mcp/auth/Provider.cpp src/lib/mcp/auth/Refresh.cpp
  src/lib/mcp/auth/Revocation.cpp
  src/lib/mcp/auth/Discovery.cpp src/lib/mcp/auth/OAuthFlight.cpp
  src/lib/mcp/auth/IndigenousServices.cpp src/lib/mcp/auth/Flow.cpp
  src/lib/mcp/remote/RemoteCore.cpp src/lib/mcp/remote/RemoteRequest.cpp
  src/lib/mcp/remote/RemoteRead.cpp
  src/lib/mcp/manager/ManagerCore.cpp src/lib/mcp/manager/ManagerConnect.cpp
  src/lib/mcp/manager/ManagerEvents.cpp src/lib/mcp/manager/IndigenousRuntime.cpp
  src/lib/mcp/manager/IndigenousConfiguration.cpp src/lib/mcp/manager/IndigenousFactory.cpp
  src/lib/mcp/manager/IndigenousAuth.cpp)
target_link_libraries(batbox_mcp_runtime PUBLIC batbox_mcp batbox_auth
  batbox_process batbox_url batbox_event_loop batbox_transport CURL::libcurl OpenSSL::Crypto)
target_compile_options(batbox_mcp_runtime PRIVATE -Wall -Wextra -Wpedantic)
target_link_libraries(batbox_application_connectors PUBLIC batbox_mcp_runtime)
target_link_libraries(batbox_application_bats PUBLIC batbox_mcp_runtime)
