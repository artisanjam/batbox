target_sources(batbox_bats PRIVATE src/core/bats/ResumeFilters.cpp)
# Indigenous application bat and permission providers. Include after the
# application engine, model and shell targets are declared.
target_sources(batbox_bats PRIVATE src/core/bats/IndigenousQueryBridge.cpp)
# The query bridge is a thin adapter over query iterators plus a factory
# callback; its translation unit needs only query/event_loop/core headers.
# Compiling it into batbox_bats (an L2 target that never links the engine)
# lets batbox_application_engine use the bridge without linking
# batbox_application_bats -- breaking the engine<->application_bats cycle.
add_library(batbox_application_bats
  src/core/bats/GeneralPurpose.cpp
  src/core/bats/BatServices.cpp
  src/core/bats/IndigenousBatCore.cpp
  src/core/bats/IndigenousBatGadget.cpp
  src/core/bats/IndigenousBatRunner.cpp
  src/core/bats/IndigenousBatMissions.cpp
  src/core/bats/IndigenousBatShutdown.cpp
  src/core/bats/IndigenousBatConversation.cpp
  src/core/bats/IndigenousBatLifetime.cpp
  src/core/bats/IndigenousBatInputs.cpp
  src/core/bats/IndigenousBatResume.cpp
  src/core/bats/IndigenousBatMessaging.cpp
  src/core/bats/IndigenousMissionOutput.cpp
  src/core/bats/IndigenousBatSkill.cpp
  src/core/bats/DefinitionsParse.cpp
  src/core/bats/DefinitionsDiscover.cpp
  src/core/bats/Memory.cpp
  src/core/bats/Worktree.cpp
  src/core/bats/WorktreeSetup.cpp
  src/core/bats/BuiltinDefinitions.cpp
  src/core/bats/BatMcp.cpp)
target_link_libraries(batbox_application_bats PUBLIC
  batbox_application_engine batbox_application_model batbox_application_shell
  batbox_application_permissions
  batbox_bats batbox_flights batbox_interactive batbox_settings batbox_glob
  batbox_roost batbox_web)
target_compile_options(batbox_application_bats PRIVATE -Wall -Wextra -Wpedantic)
