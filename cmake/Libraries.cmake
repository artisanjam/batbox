include(cmake/Icu.cmake)
add_library(batbox_core
  src/core/runtime/Version.cpp
  src/core/runtime/ArrayJoin.cpp
  src/core/runtime/JsonValue.cpp
  src/core/runtime/Platform.cpp
  src/core/runtime/Strings.cpp
  src/core/runtime/JsonParse.cpp
  src/core/runtime/Encoding.cpp
  src/core/runtime/EncodeUtf8.cpp
  src/core/runtime/PrettyJson.cpp
  src/core/runtime/PathSanitization.cpp src/util/hash.cpp
  src/core/runtime/Unicode.cpp
  src/lib/shell/PosixPath.cpp
  src/util/envUtils.cpp
  src/util/tokens.cpp
  src/util/messages.cpp
)
# The one place the project version enters the sources.
set_source_files_properties(src/core/runtime/Version.cpp PROPERTIES
  COMPILE_DEFINITIONS "BATBOX_VERSION=\"${PROJECT_VERSION}\"")
target_include_directories(batbox_core PUBLIC src)
target_link_libraries(batbox_core PUBLIC nlohmann_json::nlohmann_json Threads::Threads ICU::uc)
target_compile_options(batbox_core PRIVATE -Wall -Wextra -Wpedantic)
# The conversation/wire protocol mechanism layer: message construction and
# pairing, request assembly, stream reduction, retry policy, API error
# rendering, content normalization, model naming, and formatting. It was
# compiled into batbox_core, mixing L2 protocol code with the foundation.
# batbox_core links this target PUBLIC so existing consumers keep resolving.
add_library(batbox_protocol
  src/core/messages/TextContent.cpp
  src/core/messages/Construction.cpp
  src/core/messages/Context.cpp
  src/core/messages/Normalization.cpp
  src/core/messages/Pairing.cpp
  src/lib/http/assembly.cpp
  src/lib/http/params.cpp
  src/lib/http/RequestBuilder.cpp
  src/lib/http/PoetryStash.cpp
  src/ui/streaming/Reducer.cpp
  src/lib/http/Machine.cpp src/lib/http/MachineDirect.cpp
  src/lib/http/ErrorDetails.cpp
  src/lib/http/Policy.cpp
  src/lib/http/Retry.cpp
  src/lib/http/Sleep.cpp
  src/core/api_errors/Messages.cpp
  src/core/api_errors/Helpers.cpp
  src/core/api_errors/Formatting.cpp
  src/core/api_errors/RendererHelpers.cpp
  src/core/api_errors/Renderer.cpp
  src/core/normalization/AttachmentDeltas.cpp
  src/core/normalization/AttachmentMore.cpp
  src/core/normalization/AttachmentPlanText.cpp
  src/core/normalization/AttachmentPlans.cpp
  src/core/normalization/AttachmentGadgets.cpp
  src/core/normalization/Attachments.cpp
  src/core/normalization/Cleanup.cpp
  src/core/normalization/Content.cpp
  src/core/normalization/ImageValidation.cpp
  src/core/normalization/Pipeline.cpp
  src/core/normalization/References.cpp
  src/services/providers/model/ModelNames.cpp
  src/ui/formatting/Format.cpp
  # Tag-string scrubbing: message normalization living with the other
  # message transforms, reached through the core aggregate.
  src/core/messages/Tags.cpp
  # services/ helpers: token estimation, API usage, compaction grouping --
  # protocol-level helpers over messages, moved with the layer.
  src/services/tokenEstimation.cpp
  src/services/api/emptyUsage.cpp
  src/services/api/batbox.cpp
  src/services/compact/autoCompact.cpp
  src/services/compact/grouping.cpp
)
target_include_directories(batbox_protocol PUBLIC src)
target_link_libraries(batbox_protocol PUBLIC batbox_core batbox_glob)
target_compile_options(batbox_protocol PRIVATE -Wall -Wextra -Wpedantic)
# Same aggregate pattern as batbox_file_gadgets: no core TU references
# protocol symbols, so the core -> protocol archive order is acyclic at the
# declaration level.
target_link_libraries(batbox_core PUBLIC batbox_protocol)
include(cmake/FileGadgets.cmake)
include(cmake/EventLoop.cmake)
add_library(batbox_connectors src/services/connectors/Searxng.cpp src/services/connectors/Scrapling.cpp
  src/services/connectors/Executable.cpp)
target_include_directories(batbox_connectors PUBLIC src)
target_link_libraries(batbox_connectors PUBLIC batbox_core CURL::libcurl)
target_compile_options(batbox_connectors PRIVATE -Wall -Wextra -Wpedantic)
add_library(batbox_transport
  src/lib/transport/Messages.cpp
  src/lib/transport/Errors.cpp
  src/lib/transport/SSE.cpp src/lib/transport/Client.cpp)
target_sources(batbox_transport PRIVATE src/lib/transport/RetryAdapter.cpp
  src/lib/transport/RawHttp.cpp src/lib/transport/Perform.cpp src/lib/transport/WireClient.cpp
  src/lib/transport/openai_chat/Translate.cpp src/lib/transport/openai_chat/StreamDecoder.cpp
  src/lib/transport/openai_chat/OpenAIChatClient.cpp)
target_include_directories(batbox_transport PUBLIC src)
target_link_libraries(batbox_transport PUBLIC batbox_core CURL::libcurl)
target_compile_options(batbox_transport PRIVATE -Wall -Wextra -Wpedantic)
target_sources(batbox_core PRIVATE
  src/core/accounting/Cost.cpp
  src/core/accounting/Flight.cpp
)
# The gadget mechanism layer: the gadget interface, schema, input
# normalization, catalog, and the app-state execution modifiers. Like the
# protocol and file-gadget layers, it was compiled into batbox_core; it is
# L2 execution/mechanism code, not foundation. batbox_core re-exposes it
# PUBLIC so existing consumers keep resolving.
add_library(batbox_gadget_execution
  src/core/gadgets/Gadget.cpp
  src/core/gadgets/Schema.cpp
  src/core/gadgets/InputNormalization.cpp
  src/core/gadgets/Catalog.cpp
  src/app/execution/AppStateModifier.cpp
  src/app/execution/TypedAppStateModifier.cpp
)
target_include_directories(batbox_gadget_execution PUBLIC src)
target_link_libraries(batbox_gadget_execution PUBLIC batbox_core
  batbox_protocol batbox_file_gadgets batbox_app_state batbox_gadget_results)
target_compile_options(batbox_gadget_execution PRIVATE -Wall -Wextra -Wpedantic)
target_link_libraries(batbox_core PUBLIC batbox_gadget_execution)
add_library(batbox_model
  src/services/providers/model/SimpleQueries.cpp
  src/services/providers/model/StreamObservation.cpp
  src/services/providers/model/Completion.cpp
  src/services/providers/model/PostStream.cpp
  src/services/providers/model/Lifecycle.cpp
  src/services/providers/model/LiveStream.cpp
  src/services/providers/model/LiveStreamAdapter.cpp
  src/services/providers/model/ModelWrappers.cpp
  src/services/providers/model/NonStreaming.cpp
  src/services/providers/model/Preflight.cpp
  src/services/providers/model/QueryModel.cpp
  src/services/providers/model/StreamingAttempt.cpp
  src/services/providers/model/Watchdog.cpp
)
target_link_libraries(batbox_model PUBLIC batbox_transport batbox_core batbox_event_loop)
target_compile_options(batbox_model PRIVATE -Wall -Wextra -Wpedantic)
add_library(batbox_compaction
  src/core/compaction/Restore.cpp
  src/core/compaction/Summary.cpp
  src/core/compaction/Workflow.cpp
  src/core/compaction/Auto.cpp src/core/compaction/FlightPolicy.cpp
  src/core/compaction/Helpers.cpp src/core/compaction/Cleanup.cpp
  src/core/compaction/Poetry.cpp src/core/compaction/poetryEntries/Base.cpp
  src/core/compaction/poetryEntries/Boundary.cpp)
target_link_libraries(batbox_compaction PUBLIC batbox_core)
target_compile_options(batbox_compaction PRIVATE -Wall -Wextra -Wpedantic)
if(WIN32)
  set(BATBOX_SHELL_SPAWN_SOURCE src/lib/shell/SpawnWin.cpp)
  set(BATBOX_SHELL_SNAPSHOT_SOURCE src/lib/shell/SnapshotRunWin.cpp)
else()
  set(BATBOX_SHELL_SPAWN_SOURCE src/lib/shell/Spawn.cpp)
  set(BATBOX_SHELL_SNAPSHOT_SOURCE src/lib/shell/SnapshotRun.cpp)
endif()
add_library(batbox_shell
  src/lib/shell/BashProvider.cpp src/lib/shell/SnapshotIntegrations.cpp
  src/lib/shell/SnapshotUser.cpp src/lib/shell/SnapshotScript.cpp ${BATBOX_SHELL_SNAPSHOT_SOURCE}
  src/lib/shell/ShellQuoteChecks.cpp src/lib/shell/PipeCommand.cpp
  src/lib/shell/CommandQuoting.cpp src/lib/shell/CommandQuotingSyntax.cpp
  src/lib/shell/CommandRedirects.cpp src/lib/shell/CommandPrefix.cpp
  src/lib/shell/Heredoc.cpp src/lib/shell/HeredocCollect.cpp src/lib/shell/HeredocSyntax.cpp
  src/lib/shell/ShellQuoteParse.cpp src/lib/shell/ShellQuoteQuote.cpp
  src/lib/shell/CommandSplitter.cpp src/lib/shell/CommandSplitterRedirections.cpp
  # The mission roster, output and stop gadgets now compile in batbox_missions.
  src/lib/shell/ManagedShell.cpp ${BATBOX_SHELL_SPAWN_SOURCE} src/lib/shell/WindowsPaths.cpp
  src/lib/shell/Output.cpp src/lib/shell/ShellDiscovery.cpp
  src/lib/shell/CommandHandle.cpp src/lib/shell/TailFile.cpp src/lib/shell/MissionOutputPoller.cpp
  src/lib/shell/FormatDuration.cpp src/lib/shell/ShellCwdCompletion.cpp
  src/core/gadgets/bash/Helpers.cpp src/core/gadgets/bash/Result.cpp src/core/gadgets/bash/BashGadget.cpp
  src/core/gadgets/bash/Schema.cpp src/core/gadgets/bash/Accumulator.cpp
  src/core/gadgets/bash/Hints.cpp src/core/gadgets/bash/CwdPolicy.cpp)
target_sources(batbox_shell PRIVATE src/core/gadgets/bash/RunShellCommand.cpp)
target_sources(batbox_shell PRIVATE src/lib/shell/AsyncCommandResult.cpp
  src/lib/shell/LoopMissionOutput.cpp)
target_sources(batbox_shell PRIVATE
  src/core/gadgets/bash/AsyncRunShellCommand.cpp src/core/gadgets/bash/AsyncRunBindings.cpp
  src/core/gadgets/bash/AsyncShellBinding.cpp src/core/gadgets/bash/BashCompletion.cpp
  src/core/gadgets/bash/AsyncBashCall.cpp src/core/gadgets/bash/AsyncBashFactory.cpp)
# batbox_missions includes shell headers (ManagedShell, MissionOutputPoller);
# the shell consumes the roster -- the declared cycle folds in the aggregate.
target_link_libraries(batbox_shell PUBLIC batbox_core batbox_event_loop batbox_missions)
target_compile_options(batbox_shell PRIVATE -Wall -Wextra -Wpedantic)
add_library(batbox_query
  src/app/execution/Dispatch.cpp src/app/execution/Call.cpp
  src/app/execution/Orchestration.cpp
  src/core/query/Recovery.cpp
  src/core/query/Entry.cpp src/core/query/Setup.cpp src/core/query/ModelPass.cpp
  src/core/query/Completion.cpp src/core/query/GadgetTurn.cpp src/core/query/Engine.cpp
  src/core/query/StopHooks.cpp src/core/query/StopHooksPartner.cpp)
target_link_libraries(batbox_query PUBLIC batbox_model batbox_core)
target_compile_options(batbox_query PRIVATE -Wall -Wextra -Wpedantic)
target_sources(batbox_query PRIVATE src/core/query/AsyncSetupStart.cpp src/core/query/AsyncSetupFinish.cpp)
target_sources(batbox_query PRIVATE
  src/core/query/AsyncModelStart.cpp src/core/query/AsyncModelMessage.cpp
  src/core/query/AsyncModelRecovery.cpp
  src/core/query/AsyncEngineStart.cpp src/core/query/AsyncEngineModel.cpp src/core/query/AsyncEngineAbort.cpp)
target_link_libraries(batbox_query PUBLIC batbox_event_loop)
add_library(batbox_bats
  src/core/bats/RunBatPreflight.cpp
  src/core/bats/RunBatHelpers.cpp
  src/core/bats/RunBatSetup.cpp src/core/bats/RunBatLoop.cpp
  src/core/bats/ResumeBat.cpp src/core/bats/BatGadgetResults.cpp src/core/bats/AsyncLifecycle.cpp
  src/core/bats/BatGadgets.cpp src/core/bats/BatMissionProgress.cpp src/core/bats/BatMissionState.cpp
  src/core/bats/BatMissionNotification.cpp src/core/bats/BatMissionBinding.cpp
  src/core/bats/BatMissionRegistration.cpp src/core/bats/BatMissionRuntime.cpp
  src/core/bats/BatMissionForeground.cpp
  src/core/bats/BatGadgetPresentation.cpp
  src/core/bats/BatGadgetPreflight.cpp
  src/core/bats/BatGadgetWorktree.cpp
  src/core/bats/StashSafe.cpp src/core/bats/SubagentContext.cpp
  src/core/bats/SnapshotBridge.cpp
  src/core/bats/TypedBatState.cpp)
target_link_libraries(batbox_bats PUBLIC batbox_query)
target_compile_options(batbox_bats PRIVATE -Wall -Wextra -Wpedantic)
include(cmake/BatGadgets.cmake)
include(cmake/FlightStorage.cmake)
include(cmake/GadgetResults.cmake)
include(cmake/WebGadgets.cmake)
include(cmake/MediaGadgets.cmake)
include(cmake/McpGadgets.cmake)
include(cmake/InstructionGadgets.cmake)
include(cmake/Foundation.cmake)
include(cmake/MemoryPrefetch.cmake)
include(cmake/IndigenousDependencies.cmake)
include(cmake/HostRuntime.cmake)
include(cmake/FtxuiDependency.cmake)
include(cmake/FtxuiPresentation.cmake)
include(cmake/UserInput.cmake)
include(cmake/AttachmentTriggers.cmake)
include(cmake/Attachments.cmake)
include(cmake/CoreCommands.cmake)

# Scoped context is shared by low-level timer/future adapters and the owner
# loop: it belongs to the event-loop mechanism, not the foundation bundle.
target_sources(batbox_event_loop PRIVATE src/lib/runtime/AsyncContext.cpp)
include(cmake/CloudProviders.cmake)
