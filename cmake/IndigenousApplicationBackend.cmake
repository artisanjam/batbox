add_library(batbox_message_runtime src/core/messages/RuntimeMessages.cpp src/core/messages/Tag.cpp)
target_link_libraries(batbox_message_runtime PUBLIC batbox_core batbox_glob)
target_compile_options(batbox_message_runtime PRIVATE -Wall -Wextra -Wpedantic)

include(cmake/IndigenousTls.cmake)
add_library(batbox_application_model
  src/core/model/LocalModelService.cpp src/core/model/ServicesBase.cpp
  src/core/model/ServicesPreflight.cpp src/core/model/ServicesQuery.cpp
  src/core/model/ServicesReducer.cpp src/core/model/ServicesRequest.cpp
  src/core/model/ServicesRetry.cpp src/core/model/ContextImports.cpp
  src/core/model/Microcompact.cpp)
target_link_libraries(batbox_application_model PUBLIC batbox_query batbox_model
  batbox_diagnostics batbox_bats batbox_compaction batbox_indigenous_tls
  batbox_wire_clients)
target_compile_options(batbox_application_model PRIVATE -Wall -Wextra -Wpedantic)

add_library(batbox_application_engine src/core/engine/Engine.cpp
  src/core/engine/StopCursor.cpp src/core/engine/Compactor.cpp
  src/core/engine/CompactModel.cpp src/core/engine/Execution.cpp
  src/core/engine/GadgetErrors.cpp
  src/core/engine/CompactBinding.cpp src/core/engine/CompactFork.cpp
  src/core/engine/Defaults.cpp)
target_link_libraries(batbox_application_engine PUBLIC batbox_application_config
  batbox_application_model batbox_query batbox_compaction batbox_gadget_results
  batbox_message_runtime batbox_interactive batbox_shell)
target_compile_options(batbox_application_engine PRIVATE -Wall -Wextra -Wpedantic)

# Flight bindings plus the flight-restore layer (formerly the separate
# application_restore target, sourced from this same directory) and the
# application roost host (formerly application_roost). These three were one
# session-flight module split into three cmake slices.
add_library(batbox_application_flights src/app/flights/Flight.cpp
  src/app/flights/Plans.cpp
  src/app/roost/Roost.cpp
  src/core/flight_restore/State.cpp
  src/app/flights/RestoreLoad.cpp
  src/app/flights/RestoreApply.cpp
  src/app/flights/RestoreCommand.cpp)
target_link_libraries(batbox_application_flights PUBLIC batbox_application_config
  batbox_flights batbox_process batbox_message_runtime batbox_core
  batbox_core_commands batbox_roost batbox_instruction_async
  batbox_poetryEntries batbox_shell batbox_gadget_results
  batbox_event_loop)
target_compile_options(batbox_application_flights PRIVATE -Wall -Wextra -Wpedantic)

add_library(batbox_application_shell src/app/shell/ApplicationShell.cpp
  src/app/shell/AsyncBashHost.cpp src/app/shell/RuleMatch.cpp)
target_link_libraries(batbox_application_shell PUBLIC batbox_shell batbox_shell_media
  batbox_gadget_results batbox_glob batbox_event_loop)
target_compile_options(batbox_application_shell PRIVATE -Wall -Wextra -Wpedantic)

add_library(batbox_application_connectors src/app/connectors/Bootstrap.cpp
  src/app/connectors/Status.cpp)
target_link_libraries(batbox_application_connectors PUBLIC batbox_application_config
  batbox_connectors batbox_mcp batbox_event_loop)
target_compile_options(batbox_application_connectors PRIVATE -Wall -Wextra -Wpedantic)

include(cmake/ProjectRecovery.cmake)
add_library(batbox_application_poetry src/core/poetry/ProviderCore.cpp
  src/core/poetry/ProviderRecovery.cpp
  src/core/poetry/ProviderGit.cpp src/core/poetry/ProviderContext.cpp
  src/core/poetry/ProviderPoetry.cpp src/core/poetry/ProviderHead.cpp)
target_link_libraries(batbox_application_poetry PUBLIC batbox_application_config
  batbox_poetryEntries batbox_context batbox_git batbox_instruction_async
  batbox_instructions batbox_glob batbox_process batbox_roost batbox_project_recovery)
target_compile_options(batbox_application_poetry PRIVATE -Wall -Wextra -Wpedantic)

include(cmake/IndigenousBats.cmake)
# PermissionProvider is a leaf provider: it binds shell rules, gadget
# views, and app-state helpers. Owning it as a real target (instead of an
# INTERFACE alias to batbox_application_bats) keeps engine and hooks off
# the transitive application_bats path, which made hooks->engine->bats
# cyclic through this alias.
add_library(batbox_application_permissions src/app/permissions/PermissionProvider.cpp)
target_link_libraries(batbox_application_permissions PUBLIC
  batbox_core batbox_app_state batbox_application_shell batbox_web batbox_interactive)
target_compile_options(batbox_application_permissions PRIVATE -Wall -Wextra -Wpedantic)

add_library(batbox_application_hooks src/app/hooks/ProviderCore.cpp
  src/app/hooks/ProviderDispatch.cpp src/app/hooks/ProviderExecute.cpp
  src/app/hooks/ProviderBindings.cpp
  src/app/hooks/PermissionDecision.cpp src/app/hooks/ProviderRegistration.cpp
  src/app/hooks/ProviderWorktree.cpp
  src/app/hooks/ProviderFlightStart.cpp
  src/app/hooks/ProviderAsync.cpp
  src/app/hooks/ProviderEnv.cpp
  src/app/hooks/ProviderHttp.cpp
  src/app/hooks/ProviderPoetry.cpp
  src/app/hooks/ProviderBat.cpp
  src/app/hooks/ProviderFunction.cpp
  src/app/hooks/FileChangedWatcher.cpp)
target_link_libraries(batbox_application_hooks PUBLIC batbox_application_permissions batbox_application_config
  batbox_instruction_async batbox_application_model batbox_query batbox_glob
  batbox_shell batbox_skills batbox_settings batbox_synthetic_output
  batbox_interactive)
target_compile_options(batbox_application_hooks PRIVATE -Wall -Wextra -Wpedantic)
target_link_libraries(batbox_application_engine PUBLIC batbox_application_hooks
  batbox_application_poetry batbox_application_flights
  batbox_application_permissions
  batbox_attachments batbox_bootstrap_state batbox_memory_prefetch)

target_sources(batbox_application_gadgets PRIVATE src/app/gadgets/DefaultInputs.cpp)
# The file-history bindings (formerly their own application_file_history
# target) are gadget-side bindings over flight storage; merged here.
target_sources(batbox_application_gadgets PRIVATE
  src/core/file_history/HistoryState.cpp
  src/core/file_history/HistoryBackup.cpp
  src/core/file_history/HistorySnapshots.cpp
  src/core/file_history/HistoryRestore.cpp
  src/core/file_history/HistoryDiff.cpp
  src/core/file_history/HistoryResume.cpp)
target_link_libraries(batbox_application_gadgets PUBLIC batbox_application_model
  batbox_application_connectors batbox_application_shell batbox_application_bats
  batbox_application_permissions batbox_gadget_results batbox_settings
  batbox_application_flights batbox_core batbox_event_loop OpenSSL::Crypto)

# The presentation bindings (formerly application_presentation) and the
# rewind modal join the frontend bindings: one presentation-side module.
add_library(batbox_application_frontend src/app/frontend/Defaults.cpp
  src/app/frontend/RewindModal.cpp
  src/app/presentation/Bindings.cpp)
target_link_libraries(batbox_application_frontend PUBLIC batbox_application_runtime
  batbox_application_poetry batbox_application_flights batbox_application_bats
  batbox_application_permissions batbox_message_runtime batbox_application_gadgets
  batbox_terminal_ftxui batbox_text_sdk)
target_compile_options(batbox_application_frontend PRIVATE -Wall -Wextra -Wpedantic)

include(cmake/IndigenousCli.cmake)
include(cmake/IndigenousMemory.cmake)
include(cmake/IndigenousCommands.cmake)
include(cmake/IndigenousEndpointConfig.cmake)
include(cmake/IndigenousMissionUi.cmake)
include(cmake/Missions.cmake)
# The mission gadget store serves the gadget and command bindings (the
# mission UI TUs compile in application_commands via
# cmake/IndigenousMissionUi.cmake).
target_link_libraries(batbox_application_gadgets PUBLIC batbox_missions)
target_link_libraries(batbox_application_commands PUBLIC batbox_missions)
include(cmake/FlightRestoreTests.cmake)
include(cmake/IndigenousMedia.cmake)
include(cmake/IndigenousShellShutdown.cmake)
include(cmake/IndigenousSkills.cmake)
include(cmake/IndigenousMcp.cmake)
include(cmake/IndigenousHost.cmake)
include(cmake/IndigenousElicitation.cmake)
