# The hook runtime: all of src/lib/instructions/hooks/runtime except
# HookResponseSchema.cpp, which stays its own leaf target (hook_schema in
# cmake/SyntheticOutput.cmake) so schema consumers can reach it without the
# runtime. The 60 runtime sources were compiled in pieces inside
# batbox_instruction_async and the host-runtime slice; the hook execution
# system is one module, reached through instruction_async's PUBLIC link.
if(WIN32)
  set(BATBOX_HOOK_COMMAND_SOURCE src/lib/instructions/hooks/runtime/IndigenousCommandProcessWin.cpp)
  set(BATBOX_HOOK_MANAGED_SOURCE src/lib/instructions/hooks/runtime/IndigenousManagedHookProcessWin.cpp)
else()
  set(BATBOX_HOOK_COMMAND_SOURCE src/lib/instructions/hooks/runtime/IndigenousCommandProcess.cpp)
  set(BATBOX_HOOK_MANAGED_SOURCE src/lib/instructions/hooks/runtime/IndigenousManagedHookProcess.cpp)
endif()
add_library(batbox_hooks
  src/lib/instructions/hooks/runtime/AsyncHookDetection.cpp
  src/lib/instructions/hooks/runtime/AsyncHookRoster.cpp
  src/lib/instructions/hooks/runtime/AsyncHookRosterFinalize.cpp
  src/lib/instructions/hooks/runtime/AsyncHookRosterPoll.cpp
  src/lib/instructions/hooks/runtime/BackgroundHook.cpp
  src/lib/instructions/hooks/runtime/BaseHookInput.cpp
  src/lib/instructions/hooks/runtime/BatHookExecutor.cpp
  src/lib/instructions/hooks/runtime/BatOwnerQueryBinding.cpp
  src/lib/instructions/hooks/runtime/BatSyntheticGadgetBinding.cpp
  src/lib/instructions/hooks/runtime/CombinedAbort.cpp
  src/lib/instructions/hooks/runtime/CompactHooks.cpp
  src/lib/instructions/hooks/runtime/ElicitationHookParser.cpp
  src/lib/instructions/hooks/runtime/ElicitationHooks.cpp
  src/lib/instructions/hooks/runtime/EnvHooks.cpp
  src/lib/instructions/hooks/runtime/ExecuteHooks.cpp
  src/lib/instructions/hooks/runtime/FlightEnvironment.cpp
  src/lib/instructions/hooks/runtime/FlightEnvironmentClear.cpp
  src/lib/instructions/hooks/runtime/FlightEnvironmentFs.cpp
  src/lib/instructions/hooks/runtime/FlightEnvironmentLoad.cpp
  src/lib/instructions/hooks/runtime/FlightHookBinding.cpp
  src/lib/instructions/hooks/runtime/FlightHookStore.cpp
  src/lib/instructions/hooks/runtime/FlightHookViews.cpp
  src/lib/instructions/hooks/runtime/FunctionHook.cpp
  src/lib/instructions/hooks/runtime/HookAbort.cpp
  src/lib/instructions/hooks/runtime/HookBatchStart.cpp
  src/lib/instructions/hooks/runtime/HookBlockingMessages.cpp
  src/lib/instructions/hooks/runtime/HookCallback.cpp
  src/lib/instructions/hooks/runtime/HookConfig.cpp
  src/lib/instructions/hooks/runtime/HookEventWrappers.cpp
  src/lib/instructions/hooks/runtime/HookMatching.cpp
  src/lib/instructions/hooks/runtime/HookOutputParser.cpp
  src/lib/instructions/hooks/runtime/HookPerHookCommand.cpp
  src/lib/instructions/hooks/runtime/HookPerHookHttp.cpp
  src/lib/instructions/hooks/runtime/HookPerHookModel.cpp
  src/lib/instructions/hooks/runtime/HookPerHookSimple.cpp
  src/lib/instructions/hooks/runtime/HookPoetryStream.cpp
  src/lib/instructions/hooks/runtime/HookResultLoop.cpp
  src/lib/instructions/hooks/runtime/HookRuntimeBindings.cpp
  src/lib/instructions/hooks/runtime/HookSchema.cpp
  src/lib/instructions/hooks/runtime/HttpHook.cpp
  src/lib/instructions/hooks/runtime/IfCondition.cpp
  src/lib/instructions/hooks/runtime/IndigenousCommandFull.cpp
  src/lib/instructions/hooks/runtime/IndigenousCommandPreparation.cpp
  src/lib/instructions/hooks/runtime/IndigenousCommandPrepared.cpp
  ${BATBOX_HOOK_COMMAND_SOURCE}
  src/lib/instructions/hooks/runtime/IndigenousHttp.cpp
  ${BATBOX_HOOK_MANAGED_SOURCE}
  src/lib/instructions/hooks/runtime/LazyHookJsonInput.cpp
  src/lib/instructions/hooks/runtime/NotificationHooks.cpp
  src/lib/instructions/hooks/runtime/OutsideRepl.cpp
  src/lib/instructions/hooks/runtime/OutsideReplBranches.cpp
  src/lib/instructions/hooks/runtime/PoetryHookExecutor.cpp
  src/lib/instructions/hooks/runtime/PoetryModelBinding.cpp
  src/lib/instructions/hooks/runtime/ProcessHookJson.cpp
  src/lib/instructions/hooks/runtime/ProcessHookJsonCommon.cpp
  src/lib/instructions/hooks/runtime/ProcessHookJsonSpecific.cpp
  src/lib/instructions/hooks/runtime/SsrfGuard.cpp
  src/lib/instructions/hooks/runtime/StructuredOutputEnforcement.cpp
  src/lib/instructions/hooks/runtime/WorktreeHooks.cpp)
target_link_libraries(batbox_hooks PUBLIC batbox_core batbox_event_loop
  batbox_instructions batbox_context batbox_glob batbox_shell batbox_settings
  batbox_query batbox_synthetic_output batbox_hook_schema CURL::libcurl)
target_compile_options(batbox_hooks PRIVATE -Wall -Wextra -Wpedantic)
target_link_libraries(batbox_instruction_async PUBLIC batbox_hooks)
