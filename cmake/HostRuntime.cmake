if(WIN32)
  set(BATBOX_SHELL_BOOTSTRAP_SOURCE src/lib/shell/ShellBootstrapWin.cpp)
else()
  set(BATBOX_SHELL_BOOTSTRAP_SOURCE src/lib/shell/ShellBootstrapIndigenous.cpp)
endif()
# The hook runtime (src/lib/instructions/hooks/runtime/) is its own target in
# cmake/HooksCore.cmake, with the Indigenous process sources there too.
add_library(batbox_roost src/core/async_context/Override.cpp
  src/lib/shell/ShellBootstrap.cpp ${BATBOX_SHELL_BOOTSTRAP_SOURCE})
target_link_libraries(batbox_roost PUBLIC batbox_shell batbox_core batbox_event_loop)
target_compile_options(batbox_roost PRIVATE -Wall -Wextra -Wpedantic)
add_library(batbox_cleanup src/app/cleanup/Roster.cpp src/app/cleanup/Retention.cpp
  src/app/cleanup/RetentionIndigenous.cpp)
target_link_libraries(batbox_cleanup PUBLIC batbox_core batbox_shell batbox_event_loop)
target_compile_options(batbox_cleanup PRIVATE -Wall -Wextra -Wpedantic)
target_sources(batbox_cleanup PRIVATE src/app/cleanup/FlightRetention.cpp
  src/app/cleanup/MiscRetention.cpp src/app/cleanup/ExtraRetentionIndigenous.cpp
  src/app/cleanup/Background.cpp src/app/cleanup/Terminal.cpp src/app/cleanup/TerminalIndigenous.cpp)
add_library(batbox_settings src/app/settings/RuleParser.cpp src/app/settings/RuleValidation.cpp
  src/app/settings/GadgetValidation.cpp)
target_link_libraries(batbox_settings PUBLIC batbox_core ICU::uc)
target_compile_options(batbox_settings PRIVATE -Wall -Wextra -Wpedantic)
target_sources(batbox_settings PRIVATE src/app/settings/schema/Common.cpp
  src/app/settings/schema/Environment.cpp src/app/settings/schema/Permissions.cpp)
target_sources(batbox_settings PRIVATE src/app/settings/schema/Descriptor.cpp
  src/app/settings/schema/Main.cpp src/app/settings/schema/Runtime.cpp
  src/app/settings/schema/Scalar.cpp)
target_sources(batbox_settings PRIVATE
  src/app/settings/schema/imports/Bindings.cpp
  src/app/settings/schema/imports/HooksDescriptor.cpp src/app/settings/schema/imports/HooksParse.cpp)
target_link_libraries(batbox_settings PUBLIC batbox_url)
find_package(OpenSSL REQUIRED COMPONENTS Crypto)
# The git binding half (src/lib/git/) now compiles inside batbox_git
# (Foundation.cmake); the former batbox_git_utils target was a name inversion.
target_sources(batbox_settings PRIVATE src/app/settings/persistence/WatchTargets.cpp)
add_library(batbox_instruction_async
  src/lib/instructions/project/async/IndigenousFs.cpp src/lib/instructions/project/async/AsyncFile.cpp
  src/lib/instructions/project/async/AsyncRules.cpp src/lib/instructions/project/async/AsyncStash.cpp
  src/lib/instructions/project/async/MemoryStages.cpp src/lib/instructions/project/async/MemoryFinish.cpp
  src/lib/instructions/project/async/ContextBinding.cpp src/lib/instructions/project/async/ConditionalRules.cpp
  src/lib/instructions/project/async/ManagedConditional.cpp src/lib/instructions/project/async/NestedConditional.cpp
  src/lib/instructions/hooks/InstructionsLoaded.cpp)
target_link_libraries(batbox_instruction_async PUBLIC batbox_instructions batbox_context batbox_event_loop)
target_compile_options(batbox_instruction_async PRIVATE -Wall -Wextra -Wpedantic)

target_sources(batbox_settings PRIVATE src/app/settings/watcher/IndigenousWatcher.cpp)
target_link_libraries(batbox_settings PUBLIC batbox_event_loop)
pkg_check_modules(PCRE2_16 REQUIRED IMPORTED_TARGET libpcre2-16)
add_library(batbox_glob src/lib/glob/Regex16.cpp src/lib/glob/IgnorePattern.cpp
  src/lib/glob/IgnoreMatcher.cpp src/lib/glob/PicomatchCore.cpp src/lib/glob/PicomatchSyntax.cpp
  src/lib/glob/PicomatchStars.cpp src/lib/glob/PicomatchSafety.cpp src/lib/glob/PicomatchMatch.cpp
  src/lib/glob/DiscoveryMatcherBinding.cpp)
target_link_libraries(batbox_glob PUBLIC batbox_instructions PkgConfig::PCRE2_16)
target_compile_options(batbox_glob PRIVATE -Wall -Wextra -Wpedantic)

add_library(batbox_diagnostics src/app/diagnostics/DebugLog.cpp)
target_link_libraries(batbox_diagnostics PUBLIC batbox_core batbox_event_loop)
target_compile_options(batbox_diagnostics PRIVATE -Wall -Wextra -Wpedantic)
# Profiler (memory-usage sampling) is observability beside the debug log;
# formerly a single-file target with one consumer.
target_sources(batbox_diagnostics PRIVATE src/app/profiler/Indigenous.cpp)

add_library(batbox_flight_titles src/core/flights/Title.cpp src/core/flights/TitleText.cpp
  src/core/flights/TitlePoetry.cpp)
target_link_libraries(batbox_flight_titles PUBLIC batbox_query batbox_settings)
target_compile_options(batbox_flight_titles PRIVATE -Wall -Wextra -Wpedantic)

target_sources(batbox_diagnostics PRIVATE src/app/diagnostics/DebugFilter.cpp)
add_library(batbox_auth)
target_link_libraries(batbox_auth PUBLIC batbox_core batbox_event_loop batbox_url ICU::uc)
target_compile_options(batbox_auth PRIVATE -Wall -Wextra -Wpedantic)


# Tag-string scrubbing (src/core/messages/Tags.cpp) now compiles into batbox_protocol;
# flights resolves it through the core aggregate.
target_sources(batbox_flights PRIVATE src/core/flights/DisplayTitle.cpp)

include(cmake/SyntheticOutput.cmake)
include(cmake/HooksCore.cmake)
include(cmake/AuthRuntime.cmake)
include(cmake/FilesystemRuntime.cmake)
include(cmake/HistoryRuntime.cmake)
include(cmake/Monster.cmake)
include(cmake/Intl.cmake)
include(cmake/TextWidth.cmake)
include(cmake/Bootstrap.cmake)
include(cmake/AppState.cmake)
include(cmake/Cron.cmake)
include(cmake/TerminalEvents.cmake)
include(cmake/KeyboardInput.cmake)
include(cmake/Clipboard.cmake)

include(cmake/BatContext.cmake)
include(cmake/CronIntegration.cmake)
include(cmake/HeadlessCli.cmake)
include(cmake/StructuredRoot.cmake)
include(cmake/ProtocolHelpers.cmake)
include(cmake/ConversationRuntime.cmake)
include(cmake/StructuredFlight.cmake)
